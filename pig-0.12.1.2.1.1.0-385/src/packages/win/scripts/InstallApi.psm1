### Licensed to the Apache Software Foundation (ASF) under one or more
### contributor license agreements.  See the NOTICE file distributed with
### this work for additional information regarding copyright ownership.
### The ASF licenses this file to You under the Apache License, Version 2.0
### (the "License"); you may not use this file except in compliance with
### the License.  You may obtain a copy of the License at
###
###     http://www.apache.org/licenses/LICENSE-2.0
###
### Unless required by applicable law or agreed to in writing, software
### distributed under the License is distributed on an "AS IS" BASIS,
### WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
### See the License for the specific language governing permissions and
### limitations under the License.

###
### A set of basic PowerShell routines that can be used to install and
### manage Hadoop services on a single node. For use-case see install.ps1.
###

###
### Global variables
###
$ScriptDir = Resolve-Path (Split-Path $MyInvocation.MyCommand.Path)
$FinalName = "@final.name@"


###############################################################################
###
### Installs Pig component.
###
### Arguments:
###     component: Component to be installed, it should be pig
###     nodeInstallRoot: Target install folder (for example "C:\Hadoop")
###     serviceCredential: Credential object used for service creation
###     role: pig
###
###############################################################################
function Install(
    [String]
    [Parameter( Position=0, Mandatory=$true )]
    $component,
    [String]
    [Parameter( Position=1, Mandatory=$true )]
    $nodeInstallRoot,
    [System.Management.Automation.PSCredential]
    [Parameter( Position=2, Mandatory=$false )]
    $serviceCredential,
    [String]
    [Parameter( Position=3, Mandatory=$false )]
    $role
    )
{
    if ( $component -eq "pig" )
    {
        $HDP_INSTALL_PATH, $HDP_RESOURCES_DIR = Initialize-InstallationEnv $scriptDir "$FinalName.winpkg.log"
        Write-Log "Checking the JAVA Installation."
        if( -not (Test-Path $ENV:JAVA_HOME\bin\java.exe))
        {
            Write-Log "JAVA_HOME not set properly; $ENV:JAVA_HOME\bin\java.exe does not exist" "Failure"
            throw "Install: JAVA_HOME not set properly; $ENV:JAVA_HOME\bin\java.exe does not exist."
        }

        Write-Log "Checking the Hadoop Installation."
        if( -not (Test-Path $ENV:HADOOP_HOME\bin\winutils.exe))
        {

          Write-Log "HADOOP_HOME not set properly; $ENV:HADOOP_HOME\bin\winutils.exe does not exist" "Failure"
          throw "Install: HADOOP_HOME not set properly; $ENV:HADOOP_HOME\bin\winutils.exe does not exist."
        }

	    ### $pigInstallPath: the name of the folder containing the application, after unzipping
	    $pigInstallPath = Join-Path $nodeInstallRoot $FinalName

	    Write-Log "Installing Apache Pig @final.name@ to $pigInstallPath"

        ### Create Node Install Root directory
        if( -not (Test-Path "$nodeInstallRoot"))
        {
            Write-Log "Creating Node Install Root directory: `"$nodeInstallRoot`""
            $cmd = "mkdir `"$nodeInstallRoot`""
            Invoke-CmdChk $cmd
        }


        ###
        ###  Unzip Hadoop distribution from compressed archive
        ###
        Write-Log "Extracting $FinalName.zip to $pigInstallPath"
        if ( Test-Path ENV:UNZIP_CMD )
        {
            ### Use external unzip command if given
            $unzipExpr = $ENV:UNZIP_CMD.Replace("@SRC", "`"$HDP_RESOURCES_DIR\$FinalName.zip`"")
            $unzipExpr = $unzipExpr.Replace("@DEST", "`"$nodeInstallRoot`"")
            ### We ignore the error code of the unzip command for now to be
            ### consistent with prior behavior.
            Invoke-Ps $unzipExpr
        }
        else
        {
            $shellApplication = new-object -com shell.application
            $zipPackage = $shellApplication.NameSpace("$HDP_RESOURCES_DIR\$FinalName.zip")
            $destinationFolder = $shellApplication.NameSpace($nodeInstallRoot)
            $destinationFolder.CopyHere($zipPackage.Items(), 20)
        }

        ###
        ### Set PIG_HOME environment variable
        ###
        Write-Log "Setting the PIG_HOME environment variable at machine scope to `"$pigInstallPath`""
        [Environment]::SetEnvironmentVariable("PIG_HOME", $pigInstallPath, [EnvironmentVariableTarget]::Machine)
        $ENV:PIG_HOME = "$pigInstallPath"
		###
        ### Change pig properties
		###
		$conf_file = Join-Path $ENV:PIG_HOME "conf\pig.properties"
		Write-log "$env:HADOOP_NODE_INSTALL_ROOT"
		$path  = Join-Path $env:HADOOP_NODE_INSTALL_ROOT "hcatalog-@hcat.version@\\bin\\hcat.py"
		(Get-Content $conf_file) | Foreach-Object {
	    $_ -replace "hcat.bin=/usr/local/hcat/bin/hcat", "hcat.bin=$path"
	    } | Set-Content $conf_file

        Write-Log "Finished installing Apache Pig"
    }
    else
    {
        throw "Install: Unsupported compoment argument."
    }
}

###############################################################################
###
### Uninstalls Pig component.
###
### Arguments:
###     component: Component to be uninstalled.
###     nodeInstallRoot: Install folder (for example "C:\Hadoop")
###
###############################################################################
function Uninstall(
    [String]
    [Parameter( Position=0, Mandatory=$true )]
    $component,
    [String]
    [Parameter( Position=1, Mandatory=$true )]
    $nodeInstallRoot
    )
{
    if ( $component -eq "pig" )
    {
        $HDP_INSTALL_PATH, $HDP_RESOURCES_DIR = Initialize-InstallationEnv $scriptDir "$FinalName.winpkg.log"

        Write-Log "Uninstalling Apache Pig $FinalName"
        $pigInstallPath = Join-Path $nodeInstallRoot $FinalName

        ### If Hadoop Core root does not exist exit early
        if ( -not (Test-Path $pigInstallPath) )
        {
            return
        }

        ###
        ### Delete install dir
        ###
        $cmd = "rd /s /q `"$pigInstallPath`""
        Invoke-Cmd $cmd

        ### Removing PIG_HOME environment variable
        Write-Log "Removing the PIG_HOME environment variable"
        [Environment]::SetEnvironmentVariable( "PIG_HOME", $null, [EnvironmentVariableTarget]::Machine )

        Write-Log "Successfully uninstalled Pig"

    }
    else
    {
        throw "Uninstall: Unsupported compoment argument."
    }
}

###############################################################################
###
### Alters the configuration of the Pig component.
###
### Arguments:
###     component: Component to be configured, it should be "pig"
###     nodeInstallRoot: Target install folder (for example "C:\Hadoop")
###     serviceCredential: Credential object used for service creation
###     configs:
###
###############################################################################
function Configure(
    [String]
    [Parameter( Position=0, Mandatory=$true )]
    $component,
    [String]
    [Parameter( Position=1, Mandatory=$true )]
    $nodeInstallRoot,
    [System.Management.Automation.PSCredential]
    [Parameter( Position=2, Mandatory=$false )]
    $serviceCredential,
    [hashtable]
    [parameter( Position=3 )]
    $configs = @{},
    [bool]
    [parameter( Position=4 )]
    $aclAllFolders = $True
    )
{

    if ( $component -eq "pig" )
    {
        Write-Log "Configure: Pig does not have any configurations"
    }
    else
    {
        throw "Configure: Unsupported compoment argument."
    }
}

###############################################################################
###
### Start component services.
###
### Arguments:
###     component: Component name
###     roles: List of space separated service to start
###
###############################################################################
function StartService(
    [String]
    [Parameter( Position=0, Mandatory=$true )]
    $component,
    [String]
    [Parameter( Position=1, Mandatory=$true )]
    $roles
    )
{
    Write-Log "Starting `"$component`" `"$roles`" services"

    if ( $component -eq "pig" )
    {
        Write-Log "StartService: Pig does not have any services"
    }
    else
    {
        throw "StartService: Unsupported compoment argument."
    }
}

###############################################################################
###
### Stop component services.
###
### Arguments:
###     component: Component name
###     roles: List of space separated service to stop
###
###############################################################################
function StopService(
    [String]
    [Parameter( Position=0, Mandatory=$true )]
    $component,
    [String]
    [Parameter( Position=1, Mandatory=$true )]
    $roles
    )
{
    Write-Log "Stopping `"$component`" `"$roles`" services"

    if ( $component -eq "pig" )
    {
        Write-Log "StopService: Pig does not have any services"
    }
    else
    {
        throw "StartService: Unsupported compoment argument."
    }
}


###
### Public API
###
Export-ModuleMember -Function Install
Export-ModuleMember -Function Uninstall
Export-ModuleMember -Function Configure
Export-ModuleMember -Function StartService
Export-ModuleMember -Function StopService