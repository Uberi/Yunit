class YunitWindow
{
    Initialize()
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

    Update(TestName,Passed,Information,Parent = "")
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
}