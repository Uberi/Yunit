#Include ..\Yunit.ahk
; #Include ..\Window.ahk
#Include ..\StdOut.ahk
; #Include ..\JUnit.ahk
; #Include ..\OutputDebug.ahk

; Yunit.Use(YunitStdOut, YunitWindow, YunitJUnit, YunitOutputDebug).Test(NumberTests, StringTests)
Yunit.Use(YunitPorcelainStdOut).Test(NumberTests, StringTests)

class NumberTests
{
    Begin()
    {
        this.x := 123
        this.y := 456
    }
    
    Sum()
    {
        Yunit.that(579, this.x + this.y)
    }
    
    Division()
    {
        Yunit.assert(this.x / this.y < 1)
        Yunit.assert(this.x / this.y > 0.25)
    }
    
    Multiplication()
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
        
        Sum()
        {
            Yunit.that(333, this.x + this.y)
        }
        
        Division()
        {
            Yunit.assert(this.x / this.y > -1)
            Yunit.assert(this.x / this.y < -0.25)
        }
        
        Multiplication()
        {
            Yunit.that(-56088, this.x * this.y)
        }
        
        Fails()
        {
            Yunit.that(0, this.x - this.y, "oops!")
        }
        
        Fails_NoMessage()
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

class StringTests
{
    Begin()
    {
        this.a := "abc"
        this.b := "cdef"
    }
    
    Concat()
    {
        Yunit.that("abccdef", this.a . this.b)
    }
    
    Substring()
    {
        Yunit.that("de", SubStr(this.b, 2, 2))
    }
    
    InStr()
    {
        Yunit.that(3, InStr(this.a, "c"))
    }
    
    ExpectedException_Success()
    {
        this.ExpectedException := Exception("SomeCustomException")
        if SubStr(this.a, 3, 1) == SubStr(this.b, 1, 1)
            throw Exception("SomeCustomException")
    }
    
    ExpectedException_Fail()
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
