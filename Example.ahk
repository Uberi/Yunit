#NoEnv

#Include <Yunit>

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
    Success()
    {
        
    }

    Success_Message()
    {
        Return, "Success!"
    }

    Error()
    {
        throw ""
    }

    Error_Message()
    {
        throw "Error!"
    }

    Wait()
    {
        Sleep, 3000
    }
}