class YunitWindow
{
    __new(instance)
    {
        global YunitWindowTitle, YunitWindowEntries, YunitWindowStatusBar
        MyGui := GuiCreate(,"YUnit Output")
        MyGui.Opt("+PrefixYUnit_")
        MyGui.SetFont("s16, Arial")
        MyGui.Add("Text", "x0 y0 h30 vYunitWindowTitle Center", "Test Results")
        
        hImageList := IL_Create()
        IL_Add(hImageList,"shell32.dll",132) ;red X
        IL_Add(hImageList,"shell32.dll",78) ;yellow triangle with exclamation mark
        IL_Add(hImageList,"shell32.dll",147) ;green up arrow
        IL_Add(hImageList,"shell32.dll",135) ;two sheets of paper
        this.icons := {fail: "Icon1", issue: "Icon2", pass: "Icon3", detail: "Icon4"}
        
        MyGui.SetFont("s10")
        this.tv := MyGui.Add("TreeView","x10 y30 w680 h740 vYunitWindowEntries ImageList%hImageList%")
        
        MyGui.SetFont("s8")
        MyGui.Add("StatusBar","vYunitWindowStatusBar -Theme BackgroundGreen")
        MyGui.Options("+Resize +MinSize320x200")
        MyGui.Show("w700 h800", "Yunit Testing")
        MyGui.Options("+LastFound")

        MyGui.OnClose := "OnClose" 
        MyGui.OnSize := "OnSize" 
        
        this.gui := MyGui
        
        this.Categories := {}
        Return this
    }
    
    Update(Category, TestName, Result)
    {
        If !this.Categories.HasKey(Category)
            this.AddCategories(Category)
        Parent := this.Categories[Category]
        If IsObject(result)
        {
            hChildNode := this.tv.Add(TestName,Parent,this.icons.fail)
            this.tv.Add("Line #" result.line ": " result.message,hChildNode,this.icons.detail)
            this.gui.Control["YunitWindowStatusBar"].Opt("+BackgroundRed")
            key := category
            pos := 1
            while (pos)
            {
                this.tv.Modify(this.Categories[key], this.icons.issue)
                pos := InStr(key, ".", false, (A_AhkVersion < "2") ? 0 : -1, 1)
                key := SubStr(key, 1, pos-1)
            }
        }
        Else 
        {
            this.tv.Add(TestName,Parent,this.icons.pass)
        }
        this.tv.Modify(Parent, "Expand")
        this.tv.Modify(this.tv.GetNext(), "VisFirst")   ;// scroll the treeview back to the top
    }
    
    AddCategories(Categories)
    {
        Parent := 0
        Category := ""
        Categories_Array := StrSplit(Categories, ".")
        for k,v in Categories_Array
        {
            Category .= (Category == "" ? "" : ".") v
            If (!this.Categories.HasKey(Category))
                this.Categories[Category] := this.tv.Add(v, Parent, this.icons.pass)
            Parent := this.Categories[Category]
        }
    }
}

YUnit_OnClose(Gui) {
  ExitApp
}

YUnit_OnSize(MyGui, EventInfo, Width, Height) {
  MyGui.Control["YunitWindowTitle"].Move("w" . Width)
  MyGui.Control["YunitWindowEntries"].Move("w" . (Width - 20) . " h" . (Height - 60))
  MyGui.Options("+LastFound")
  DllCall("user32.dll\InvalidateRect", "uInt", WinExist(), "uInt", 0, "uInt", 1)
  Return
}

