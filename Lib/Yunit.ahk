#NoEnv

class Yunit
{
    ShowWindow()
    {
        global YunitWindowTitle, YunitWindowEntries
        Gui, Yunit:Font, s16, Arial
        Gui, Yunit:Add, Text, x0 y0 h30 vYunitWindowTitle Center, Test Results:

        hImageList := IL_Create()
        IL_Add(hImageList,"shell32.dll",78) ;yellow triangle with exclamation mark
        IL_Add(hImageList,"shell32.dll",138) ;green circle with arrow facing right
        IL_Add(hImageList,"shell32.dll",135) ;two sheets of paper
        Gui, Yunit:Font, s10
        Gui, Yunit:Add, TreeView, x10 y30 vYunitWindowEntries ImageList%hImageList%

        Gui, Yunit:Font, s8
        Gui, Yunit:Add, StatusBar
        Gui, Yunit:+Resize +MinSize320x200
        Gui, Yunit:Show, w500 h400, Unit Test
        Gui, Yunit:+LastFound
        Return

        YunitGuiSize:
        GuiControl, Yunit:Move, YunitWindowTitle, w%A_GuiWidth%
        GuiControl, Yunit:Move, YunitWindowEntries, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 60)
        Gui, Yunit:+LastFound
        WinSet, Redraw
        Return

        YunitGuiClose:
        ExitApp
    }

    UpdateWindow(TestName,Passed,Information,Parent = "")
    {
        If !Parent
            Parent := 0
        If Passed
            hChildNode := TV_Add(TestName,Parent,"Icon2 Sort")
        Else
            hChildNode := TV_Add(TestName,Parent,"Icon1 Sort")
        If (Information != "") ;additional information
            TV_Add(Information,hChildNode,"Icon3")
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
                this.UpdateWindow(Key,Passed,Information,hNode)
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