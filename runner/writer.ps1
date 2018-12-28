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

	fail($str)
	{
		$str = $this.getIndented($str)
		Write-Host $str -foregroundColor $this.config.failColor
	}

	pass($str)
	{
		$str = $this.getIndented($str)
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
