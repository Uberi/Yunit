#NoEnv

class Atest
{
    ShowWindow()
    {
        global AtestWindowTitle, AtestWindowEntries
        Gui, Atest:Font, s16, Arial
        Gui, Atest:Add, Text, x0 y0 h30 vAtestWindowTitle Center, Test Results:

        hImageList := IL_Create()
        IL_Add(hImageList,"shell32.dll",78) ;yellow triangle with exclamation mark
        IL_Add(hImageList,"shell32.dll",138) ;green circle with arrow facing right
        IL_Add(hImageList,"shell32.dll",135) ;two sheets of paper
        Gui, Atest:Font, s10
        Gui, Atest:Add, TreeView, x10 y30 vAtestWindowEntries ImageList%hImageList%

        Gui, Atest:Font, s8
        Gui, Atest:Add, StatusBar
        Gui, Atest:+Resize +MinSize320x200
        Gui, Atest:Show, w500 h400, Unit Test
        Gui, Atest:+LastFound
        Return

        AtestGuiSize:
        GuiControl, Atest:Move, AtestWindowTitle, w%A_GuiWidth%
        GuiControl, Atest:Move, AtestWindowEntries, % "w" . (A_GuiWidth - 20) . " h" . (A_GuiHeight - 60)
        Gui, Atest:+LastFound
        WinSet, Redraw
        Return

        AtestGuiClose:
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
        static TestPrefix := "Test_"
        static CategoryPrefix := "Category_"

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
                If RegExMatch(Key,"iS)" . TestPrefix . "\K[\w_]+",TestName) ;test found
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
                    this.UpdateWindow(TestName,Passed,Information,hNode)
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
            }
            Else If IsObject(Value) ;possible category found
            {
                If RegExMatch(Key,"iS)" . CategoryPrefix . "\K[\w_]+",CategoryName) ;category found
                {
                    hChildNode := TV_Add(CategoryName,hNode,"Icon2 Expand Bold Sort")
                    If !UnitTest.Test(Value,hChildNode,State) ;test category
                    {
                        CurrentStatus := False
                        TV_Modify(hChildNode,"Icon1")
                    }
                }
            }
        }

        Return, CurrentStatus
    }
}