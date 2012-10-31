#NoEnv

#Include Yunit.ahk

#Warn All
#Warn LocalSameAsGlobal, Off

Yunit.ShowWindow() ;wip
Gui, Yunit:Default

Yunit.Window := True
Yunit.Stdout := True

Yunit.Test(Tests)
Return

class Tests
{
    Test_Success()
    {
        
    }

    Test_Success_Message()
    {
        Return, "Success!"
    }

    Test_Error()
    {
        throw ""
    }

    Test_Error_Message()
    {
        throw "Error!"
    }
}