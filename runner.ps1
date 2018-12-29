# CLI: .\runner.ps1 -Monitor $false
param (
	[string]$path = $(Get-Location),
	[string]$file = "*Tests.ahk",
	[bool]$monitor = $true,
	[string]$autohotkeyExe = "Autohotkey" # assumes it's in $env:PATH
	# [string]autohotkey='C:\Program Files\AutoHotkey\AutoHotkey.exe'
 )

# Example output
# *****************
# ** Start Yunit **
# *****************
# Running tests in .\Yunit\doc\*Tests.ahk
#
# File: doc\Example.ahk
#   PASS: SuiteName.Test1
#   FAIL: SuiteName.Test2
#         Message: Oops!
#         Expected: value
#         But got: diffValue
#
#         on line 58 of .\Yunit\doc\ExampleTests.ahk
#


. "$PSScriptRoot\runner\run-watcher.ps1"
. "$PSScriptRoot\runner\run-tests.ps1"
. "$PSScriptRoot\runner\TestResult.ps1"
. "$PSScriptRoot\runner\Writer.ps1"



$config = @{
	autohotkeyPath=$autohotkeyExe; monitorPath=$path; match=$file;
	failColor='Magenta'; errorColor='Red'; passColor='Green';
	infoColor='White'; titleColor='Blue';
	indent='  ';
}


# Execute tests
$write = [Writer]::new($config)
$write.title("Start Yunit")
Run-AllTests $config.monitorPath $config.match
if ($monitor) {
	Run-Watcher $config.monitorPath $config.match
}
