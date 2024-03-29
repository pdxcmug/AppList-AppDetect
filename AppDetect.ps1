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
	AppDetect
.SYNOPSIS 
    This script is used as a detection method for SCCM. The TargetAppName variable below can be filled in 
	with the name of an application as it is returned from the AppList script, and the entire script can be 
	pasted in as a detection method. 
.PARAMETERS 
    None
.EXAMPLE 
    None 
.NOTES 
	Search for "DATA_REQUIRED" to see any data points that need filled in for the script to work properly
#>

# Configure Variables
$TargetAppName = ""  <# DATA_REQUIRED : Application name as output from AppList script #>
$64BitOS = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"

# Query SysNative apps
$SysNativeApps = GCI -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty -Name DisplayName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select -ExpandProperty DisplayName
$SysNativeApps = $SysNativeApps -replace '[][)(\/+-,]',' '
$SysNativeApps = $SysNativeApps | Sort

ForEach ($SysNativeApp In $SysNativeApps) {If ($TargetAppName -Match $SysNativeApp) {Write $SysNativeApp}}

# Query Wow6432 apps
If (Test-Path $64BitOS) {

$Wow6432Apps = GCI -Path "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty -Name DisplayName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select -ExpandProperty DisplayName
$Wow6432Apps = $Wow6432Apps -replace '[][)(\/+-,]',' '
$Wow6432Apps = $Wow6432Apps | Sort

ForEach ($Wow6432App In $Wow6432Apps) { If ($TargetAppName -Match $Wow6432App) {Write $Wow6432App}}

}