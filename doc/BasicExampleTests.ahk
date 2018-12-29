#Include ..\Yunit.ahk
#Include ..\StdOut.ahk
; #Include ..\Window.ahk
#Include ..\StdOut.ahk
; #Include ..\JUnit.ahk
; #Include ..\OutputDebug.ahk

; Yunit.Use(YunitStdOut, YunitWindow, YunitJUnit, YunitOutputDebug).Test(NumberTests, StringTests)
Yunit.Use(YunitPorcelainStdOut).Test(EqualityTests, OtherTests)

class EqualityTests
{
    Begin()
    {
        ; Executes before each test
        this.expected := 123
    }

    IsEqual()
    {
        actual := 123
        Yunit.that(this.expected, actual, "extra fail msg")
    }

    End()
    {
        ; Executes after each test
        this.Delete("expected")
    }
}

; Nesting is possible:
class OtherTests
{
    class InnerTests
    {
    }
}
