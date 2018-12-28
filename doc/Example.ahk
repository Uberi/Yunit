#Include ..\Yunit.ahk
; #Include ..\Window.ahk
#Include ..\StdOut.ahk
; #Include ..\JUnit.ahk
; #Include ..\OutputDebug.ahk

; Yunit.Use(YunitStdOut, YunitWindow, YunitJUnit, YunitOutputDebug).Test(NumberTestSuite, StringTestSuite)
Yunit.Use(YunitPorcelainStdOut).Test(NumberTestSuite, StringTestSuite)

class NumberTestSuite
{
    Begin()
    {
        this.x := 123
        this.y := 456
    }
    
    Test_Sum()
    {
        Yunit.that(579, this.x + this.y)
    }
    
    Test_Division()
    {
        Yunit.assert(this.x / this.y < 1)
        Yunit.assert(this.x / this.y > 0.25)
    }
    
    Test_Multiplication()
    {
        Yunit.that(56088, this.x * this.y)
    }
    
    End()
    {
        this.Delete("x")
        this.Delete("y")
    }
    
    class Negatives
    {
        Begin()
        {
            this.x := -123
            this.y := 456
        }
        
        Test_Sum()
        {
            Yunit.that(333, this.x + this.y)
        }
        
        Test_Division()
        {
            Yunit.assert(this.x / this.y > -1)
            Yunit.assert(this.x / this.y < -0.25)
        }
        
        Test_Multiplication()
        {
            Yunit.that(-56088, this.x * this.y)
        }
        
        Test_Fails()
        {
            Yunit.that(0, this.x - this.y, "oops!")
        }
        
        Test_Fails_NoMessage()
        {
            Yunit.that(0, this.x - this.y)
        }

        End()
        {
            this.Delete("x")
            this.Delete("y")
        }
    }
}

class StringTestSuite
{
    Begin()
    {
        this.a := "abc"
        this.b := "cdef"
    }
    
    Test_Concat()
    {
        Yunit.that("abccdef", this.a . this.b)
    }
    
    Test_Substring()
    {
        Yunit.that("de", SubStr(this.b, 2, 2))
    }
    
    Test_InStr()
    {
        Yunit.that(3, InStr(this.a, "c"))
    }
    
    Test_ExpectedException_Success()
    {
        this.ExpectedException := Exception("SomeCustomException")
        if SubStr(this.a, 3, 1) == SubStr(this.b, 1, 1)
            throw Exception("SomeCustomException")
    }
    
    Test_ExpectedException_Fail()
    {
        this.ExpectedException := "fubar"
        Yunit.that(this.a, this.b)
        ; no exception thrown!
    }
    
    End()
    {
        this.Delete("a")
        this.Delete("b")
    }
}
