function Run-Watcher($path, $match) {
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
		Run-AllTests $path $match
	}
}
