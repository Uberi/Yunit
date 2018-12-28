# CLI: .\runner.ps1 -Monitor $false
param (
	[bool]$monitor = $true
 )

# Example output
# *****************
# ** Start Yunit **
# *****************
# Running tests in .\Yunit\doc\Example.ahk
#
# File: doc\Example.ahk
#   PASS: SuiteName.TestName
#   FAIL: SuiteName.TestName
#         Expected: value
#         But got: diffValue
#
#         on line 58 of .\Yunit\doc\Example.ahk
#

. ".\runner\run-watcher.ps1"
. ".\runner\run-tests.ps1"
. ".\runner\TestResult.ps1"
. ".\runner\Writer.ps1"


$config = @{
	autohotkeyPath='Autohotkey'; # assumes it's in $env:PATH
	# autohotkeyPath='C:\Program Files\AutoHotkey\AutoHotkey.exe';
	failColor='Magenta';
	errorColor='Red';
	passColor='Green';
	infoColor='White';
	titleColor='Blue';
	indent='  ';

	monitorPath=(get-location);
	# match='*.ahk';
	match='Example.ahk';
}


# Execute tests
$write = [Writer]::new($config)
$write.title("Start Yunit")
$path = $config.monitorPath
Run-AllTests $path $config.match
if ($monitor) {
	Run-Watcher $path $config.match
}


