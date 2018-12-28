class TestResult
{
	# Common Pass/Fail
	[string]$status
	[string]$category
	[string]$testName

	# Exception details
	[string]$lineNumber
	[string]$fileName
	[string]$errorMessage

	# Assert.That values
	$expectedValue
	$actualValue

	TestResult($line)
	{
		$parts = $line -split "`t"
		$this.status = $parts[0] # PASS / FAIL
		$this.category = $parts[1]
		$this.testName = $parts[2]
		if ($parts.Length -gt 3) {
			$this.lineNumber = $parts[3]
			$this.fileName = $parts[4]
			$this.errorMessage = $parts[5]
			$this.expectedValue = $parts[6]
			$this.actualValue = $parts[7]
		}
	}

	[bool]passed()
	{
		return $this.status -eq "PASS"
	}
}
