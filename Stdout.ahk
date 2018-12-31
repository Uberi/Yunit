class YunitStdOut
{
    Update(Category, Test, Result) ;wip: this only supports one level of nesting?
    {
        if IsObject(Result)
        {
            Details := " at line " Result.Line " " Result.Message "(" Result.File ")"
            Status := "FAIL"
        }
        else
        {
            Details := ""
            Status := "PASS"
        }
        FileAppend, %Status%: %Category%.%Test% %Details%`n, *
    }
}



class YunitPorcelainStdOut
{
    Update(Category, Test, Result) ;wip: this only supports one level of nesting?
    {
        if IsObject(Result)
        {
            ; Not displayed: What/Extra: Exception(Message [, What, Extra])
            Details := "`t" Result.Line "`t" Result.File "`t" Result.Message
            Status := "FAIL"
        }
        else
        {
            Details := ""
            Status := "PASS"
        }
        FileAppend, %Status%`t%Category%`t%Test%%Details%`n, *
    }
}
