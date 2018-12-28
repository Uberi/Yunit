# CLI: .\runner.ps1

# Example output
# ****************************
# ** Start Yunit Monitoring **
# ****************************
# Running tests in .\Yunit\doc\Example.ahk
#
# File: doc\Example.ahk
#   PASS: SuiteName.TestName
#   FAIL: SuiteName.TestName StackTrace

$config = @{
	autohotkeyPath='Autohotkey'; # assumes it's in $env:PATH
	# autohotkeyPath='C:\Program Files\AutoHotkey\AutoHotkey.exe';
	failColor='Magenta';
	passColor='Green';
	infoColor='White';
	titleColor='Blue';
	indent='  ';

	monitorPath=(get-location);
	# match='*.ahk';
	match='Example.ahk';
}

. ".\runner\writer.ps1"
$write = [Writer]::new($config)

function initializeTotals() {
	return @{
		pass=0;
		fail=0;
	}
}

$totals = initializeTotals


function Run-AllTests($path, $match) {
	$totals = initializeTotals
	$write.info("Running tests in $path\$match")
	Get-ChildItem "$path\$match" -Recurse | % {
		Run-TestFile $_
	}

	$write.info("Failed:  " + $totals.fail + "  |  Success:  " + $totals.pass)
}


function Run-TestFile($file) {
	Push-Location $file.Directory.FullName

	$test = & $config.autohotkeyPath $file.FullName
	$arr = $test -split "`n"

	$write.info("`nFile: $file")
	$write.indent()
	foreach ($test in $arr) {
		if ($test -like "FAIL*") {
			$totals.fail++
			$write.fail("$test")
		} else {
			$totals.pass++
			$write.pass("$test")
		}
	}
	$write.outdent()

	Pop-Location
}


function Run-Watcher($path) {
	# Blocking function!
	$watcher = New-Object System.IO.FileSystemWatcher
	$watcher.Path = $path
	$watcher.IncludeSubdirectories = $true
	$watcher.EnableRaisingEvents = $false
	$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName

	while ($TRUE) {
		$result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
		if ($result.TimedOut) {
			continue;

		}

		if ($result.Name -like ".git*") {
			continue;
		}

		cls
		$write.info("Change in " + $result.Name + " on " + (get-date -f F))
		Run-AllTests $path $config.match
	}
}


# Pretty Title print
$write.title("Start Yunit Monitoring")

# Execute tests
$path = $config.monitorPath
Run-AllTests $path $config.match
Run-Watcher $path
