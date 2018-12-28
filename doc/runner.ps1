# .\runner.ps1

$config = @{
	autohotkeyPath='Autohotkey'; # assumes it's in $env:PATH
	# autohotkeyPath='C:\Program Files\AutoHotkey\AutoHotkey.exe';
	failColor='Magenta';
	passColor='Green';
	infoColor='White';
	titleColor='Blue';

	monitorPath=(get-location);
}



function Run-AllTests($path, $match = "\*.ahk") {
	Write-Host "Running tests in $path$match" -ForegroundColor $config.infoColor
	Get-ChildItem "$path$match" -Recurse | % {
		Run-TestFile $_
	}
}


function Run-TestFile($file) {
	Push-Location $file.Directory.FullName

	$test = & $config.autohotkeyPath $file.FullName
	$arr = $test -split "`n"

	foreach ($test in $arr) {
		if ($test -like "FAIL*") {
			Write-Host $test -ForegroundColor $config.failColor
		} else {
			Write-Host $test -ForegroundColor $config.passColor
		}
	}

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
		Write-Host "Change in" $result.Name "on" (get-date -f F) -ForegroundColor $config.infoColor
		Run-AllTests $path
	}
}


# Pretty Title print
$title = "Start Yunit Monitoring"
$titleBarLength = $title.length + 6
Write-Host ("*" * $titleBarLength) -ForegroundColor $config.titleColor
Write-Host "** $title **" -ForegroundColor $config.titleColor
Write-Host ("*" * $titleBarLength) -ForegroundColor $config.titleColor

# Execute tests
$path = $config.monitorPath
Run-AllTests $path
Run-Watcher $path
