#NoEnv

class Yunit
{
    class Outputs
    {
        #Include Window.ahk
    }

    static _ := Yunit.Initialize()

    Initialize()
    {
        For Name, Output In Yunit.Outputs
            Output.Initialize()
    }

    Test(Tests,hNode = 0,State = "")
    {
        If !IsObject(State)
        {
            State := Object()
            State.Passed := 0
            State.Failed := 0
        }

        CurrentStatus := True
        For Key, Value In Tests
        {
            If IsFunc(Value) ;possible test found
            {
                ;run the test
                Passed := True
                ;try Information := Value() ;wip
                try Information := Object("Value",Value).Value()
                catch e
                {
                    CurrentStatus := False
                    Passed := False
                    Information := e
                }

                ;update the interface
                For Name, Output In this.Outputs
                    Output.Update(Key,Passed,Information,hNode) ;wip: remove hNode
                If Passed ;test passed
                    State.Passed ++
                Else ;test failed
                    State.Failed ++

                ;update the status bar
                If State.Failed ;tests failed
                    SB_SetIcon("shell32.dll",78) ;yellow triangle with exclamation mark
                Else ;all tests passed
                    SB_SetIcon("shell32.dll",138) ;green circle with arrow facing right
                SB_SetText(State.Passed . " of " . (State.Passed + State.Failed) . " tests passed.")
            }
            Else If IsObject(Value) ;possible category found
            {
                hChildNode := TV_Add(Key,hNode,"Icon2 Expand Bold Sort")
                If !UnitTest.Test(Value,hChildNode,State) ;test category
                {
                    CurrentStatus := False
                    TV_Modify(hChildNode,"Icon1")
                }
            }
        }
        Return, CurrentStatus
    }
}