#NoEnv

class Yunit
{
    static Modules := [Yunit.StdOut]

    class Tester extends Yunit ;wip: use Yunit.Test(Classes).Start(YunitStdout, YunitWindow)
    {
        __New(Modules)
        {
            this.Modules := Modules
        }

        Test(Classes*)
        {
            this.Results := {}
            this.Classes := Classes
            for Index, cls in Classes
            {
                this.Current := Index
                Results := {}
                this.ClassResults[cls.__Class] := Results ;wip: remove references to __class, since that can be modified, use &obj instead
                this.TestClass(Results, cls)
            }
            return this
        }

        Update(Category, Test, Result)
        {
            for Key, Module in this.Modules
                Module.Update(Category, Test, Result)
        }

        TestClass(Results, cls)
        {
            Environment := new cls() ; calls __New
            for Key, Value in cls
            {
                if IsObject(Value) && IsFunc(Value) ;current value is a test
                {
                    if (Key = "Begin" || Key = "End") ;skip beginning and ending callbacks
                        continue

                    if ObjHasKey(cls, "Begin") && IsFunc(cls.Begin) ;initialization callback defined
                        Environment.Begin()

                    Result := 0
                    try
                    {
                        Value.(Environment) ;run the test
                        if ObjHasKey(Environment, "ExpectedException")
                            Result := Environment.ExpectedException ;wip: need better way to convey the issue
                    }
                    catch Error
                    {
                        if !ObjHasKey(Environment, "ExpectedException") ;no exception was expected
                            Result := Error
                        else if !this.CompareValues(Environment.ExpectedException, Error) ;received exception was not what was expected
                            Result := Error
                    }
                    ObjRemove(Environment, "ExpectedException") ;remove the value of the expected exception, if defined

                    Results[Key] := Result ;store the result of the test
                    this.Update(cls.__Class, Key, Result) ;update the output modules

                    if ObjHasKey(cls, "End") && IsFunc(cls.End) ;uninitialization callback defined
                        Environment.End()
                }
                else if IsObject(Value) && ObjHasKey(Value, "__Class") ;current value is a category
                    this.Classes.Insert(Value) ;store the classes list for later processing ;wip: not sure how this works on nested classes
            }
        }
    }

    Use(Modules*)
    {
        return new this.Tester(Modules)
    }

    Assert(Value, Message = "FAIL")
    {
        if !Value
            throw Exception(Message, -1)
        return Value
    }

    ;wip: needs to either be renamed to CompareExceptions or extended to compare exceptions with custom extensions
    CompareValues(v1, v2)
    {
        if !IsObject(v1) || !IsObject(v2)
            return v1 = v2 ;obey StringCaseSense
        if !ObjHasKey(v1, "Message") || !ObjHasKey(v2, "Message")
            return False
        return v1.Message = v2.Message
    }
    
    CompareValues(v1, v2)
    {   ; Support for simple exceptions. May need to be extended in the future.
        if !IsObject(v1) || !IsObject(v2)
            return v1 = v2   ; obey StringCaseSense
        if !ObjHasKey(v1, "Message") || !ObjHasKey(v2, "Message")
            return False
        return v1.Message = v2.Message
    }
}

/* Module example.

; file should be Lib\Yunit\MyModule.ahk
; included like this: 
#Include <Yunit\MyModule>

; usage:
Yunit.Use(YunitMyModule).Test(class1, class2, ...)

class YunitMyModule
{ 
    __New(instance)
    {
        ; setup code here
        ; instance is the instance of Yunit
        ; instance.results is a persistent object that 
        ;   is updated just before Update() is called
    }
    
    Update(category, test, result)
    {
        ; update code here
        ; called every time a test is finished
    }
}

*/