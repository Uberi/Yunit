class YunitStdOut
{
    Update(category, test, result) ;wip: this only supports one level of nesting?
    {
        if IsObject(result)
        {
            details := " at line " result.line " " result.message
            result := "FAIL"
        }
        else
        {
            details := ""
            result := "PASS"
        }
        FileAppend, %result%: %category%.%test% %details%`n, *
    }
}