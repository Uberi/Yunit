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
	$write.info("")
}


function Run-TestFile($file) {
	Push-Location $file.Directory.FullName

	$test = & $config.autohotkeyPath $file.FullName
	$arr = $test -split "`n"

	$write.info("`nFile: $file")
	$write.indent()
	foreach ($testLine in $arr) {
		$test = [TestResult]::new($testLine)
		if ($test.passed()) {
			$totals.pass++
			$write.pass($test)
		} else {
			$totals.fail++
			$write.fail($test)
		}
	}
	$write.outdent()
	$write.info("")

	Pop-Location
}
