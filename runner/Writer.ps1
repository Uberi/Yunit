class Writer
{
	hidden $config
	hidden [int]$indentValue

	Writer($config)
	{
		$this.config = $config
		$this.indentValue = 0
	}

	hidden [string] getIndented($str)
	{
		return ($this.config.indent * $this.indentValue) + $str
	}

	info($str)
	{
		$str = $this.getIndented($str)
		Write-Host $str -foregroundColor $this.config.infoColor
	}

	fail([TestResult]$result)
	{
		$indent = $this.getIndented("")
		$str = "$indent$($result.status): $($result.category).$($result.testName)"
		Write-Host $str -foregroundColor $this.config.failColor

		$in = "       "

		if ($result.errorMessage) {
			$str = "$in Message: "
			Write-Host $str -foregroundColor $this.config.failColor -NoNewline
			Write-Host $result.errorMessage -foregroundColor $this.config.errorColor
		}

		$str = "$in Expected: "
		Write-Host $str -foregroundColor $this.config.failColor -NoNewline
		Write-Host $result.expectedValue -foregroundColor $this.config.infoColor

		$str = "$in But got:  "
		Write-Host $str -foregroundColor $this.config.failColor -NoNewline
		Write-Host $result.actualValue -foregroundColor $this.config.infoColor

		Write-Host

		Write-Host "$in on line " -foregroundColor $this.config.failColor -NoNewline
		Write-Host $result.lineNumber -foregroundColor $this.config.infoColor -NoNewline
		Write-Host " of " -foregroundColor $this.config.failColor -NoNewline
		Write-Host $result.fileName -foregroundColor $this.config.infoColor

		Write-Host
		Write-Host
	}

	pass([TestResult]$result)
	{
		$indent = $this.getIndented("")
		$str = "$indent$($result.status): $($result.category).$($result.testName)"
		Write-Host $str -foregroundColor $this.config.passColor
	}

	indent()
	{
		$this.indentValue++
	}

	outdent()
	{
		$this.indentValue--
	}

	title($str)
	{
		$titleLength = $str.length + 6
		Write-Host ("*" * $titleLength) -ForegroundColor $this.config.titleColor
		Write-Host "** $str **" -ForegroundColor $this.config.titleColor
		Write-Host ("*" * $titleLength) -ForegroundColor $this.config.titleColor
	}
}
