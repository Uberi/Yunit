#NoEnv

#Include Atest.ahk

#Warn All
#Warn LocalSameAsGlobal, Off

Atest.ShowWindow() ;wip
Gui, Atest:Default

Atest.Window := True
Atest.Stdout := True

Atest.Test(Tests)
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