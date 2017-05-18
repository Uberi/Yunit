;############################
; description: Generate output for Yunit-Framework (https://github.com/Uberi/Yunit) using OutputDebug
;
; author: hoppfrosch
; date: 20170427
;############################
class YunitOutputDebug{
	__new(instance) {
		this.tests := {}
		this.tests.pass := 0
		this.tests.fail := 0
		this.tests.overall := 0
		this.prefix := "[YUnit] "
		OutputDebug % this.prefix "  "
		OutputDebug % this.prefix "***********************************************************************************************************"
		OutputDebug % this.prefix "*** START OF TESTSUITE ************************************************************************************" 
		Return this
	}

	__Delete() { 
		OutputDebug % this.prefix "*** STATISTICS OF TESTSUITE: performed: " this.tests.overall " - failed: " this.tests.fail " - passed: " this.tests.pass 
		OutputDebug % this.prefix "***********************************************************************************************************"
		OutputDebug % this.prefix "  "
	}

	Update(Category, TestName, Result)	{
		this.tests.overall := this.tests.overall + 1
		if IsObject(Result) {
			this.tests.fail := this.tests.fail + 1
			Details := "at line " Result.Line " (" Result.Message ")"
			Status := "FAIL"
		} else {
			this.tests.pass := this.tests.pass + 1
			Details := ""
			Status := "PASS"
		}
		cnt := format("{:3}", this.tests.overall) 
		msg := "(" cnt ") " status ": " Category "." Testname " " details
		OutputDebug % this.prefix msg
	}
}
