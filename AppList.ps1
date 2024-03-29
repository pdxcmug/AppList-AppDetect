<# 
********************************************************************************************************* 
			             Created by Tyler Lane, 5/21/2018		 	                
*********************************************************************************************************
Modified by   |  Date   | Revision | Comments                                                       
_________________________________________________________________________________________________________
Tyler Lane    | 5/21/18 |   v1.0   | First version
Tyler Lane    | 6/26/19 |   v1.1   | Cleaned up code, added comments, prepared for collaboration                                                 
_________________________________________________________________________________________________________
.NAME
	AppList
.SYNOPSIS 
    This script will query the installed applications on a workstation and optionally list the uninstall 
	command as well. It is best used with AppDetect, which can use the application names that are output 
	from this script as a detection method for applications in SCCM. 
.PARAMETERS 
    None
.EXAMPLE 
    None 
.NOTES 
    None
#>

# Configure Variables
$64BitOS = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

# Query SysNative apps
$SysNativeApps = GCI -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty -Name DisplayName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select -ExpandProperty DisplayName
$SysNativeApps = $SysNativeApps -replace '[][)(\/+-,]',' '
$SysNativeApps = $SysNativeApps | Sort

Write-Host -ForegroundColor Red "                    SysNative Applications Installed"
Write ""
$SysNativeApps
Write ""

# Query Wow6432 apps
If (Test-Path $64BitOS) {

$Wow6432Apps = GCI -Path "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty -Name DisplayName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select -ExpandProperty DisplayName
$Wow6432Apps = $Wow6432Apps -replace '[][)(\/+-,]',' '
$Wow6432Apps = $Wow6432Apps | Sort

Write-Host -ForegroundColor Red "                    Wow6432 Applications Installed"
Write ""
$Wow6432Apps
Write ""

}

# Query uninstall information or quit script
Do {

	$UserResponse = Read-Host "If you want the uninstall string for a specific application, search for the name in this field. Otherwise, press Enter to quit"

	If ($UserResponse -ne "") {

		GCI -Path "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Where DisplayName -like "*$UserResponse*" | Select DisplayName,ModifyPath,UninstallString | Format-List
		GCI -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Where DisplayName -like "*$UserResponse*" | Select DisplayName,ModifyPath,UninstallString | Format-List

		}

}

While ($UserResponse -ne "")