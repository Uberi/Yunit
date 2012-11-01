#NoEnv

; Yunit.Test(class1, class2, ...)
class Yunit {
    Test(classes*) { ; static method
        instance := new this()
        instance.results := {}
        for k,class in classes {
            obj := {}
            instance.results[class.__class] := obj
            instance.TestClass(obj, class)
        }
    }
    
    Update(category, test, result) {
        FileAppend, Yunit.log, %category%.%test% = %result%`n
    }
    
    TestClass(results, class) {
        environment := new class() ; calls __New
        for k,v in class {
            if IsObject(v) && IsFunc(v) { ;test
                if ObjHasKey(environment,"Begin") 
                && IsFunc(environment.Begin)
                    environment.Begin()
                try  {
                    environment.%v%()
                    results[k] := 0
                }
                catch error {
                    results[k] := error
                }
                this.Update(class.__class, k, results[k])
                if ObjHasKey(environment,"End")
                && IsFunc(environment.End)
                    environment.End()
            }
            else if IsObject(v)
            && ObjHasKey(v, "class") ;category
                this.classes.insert(class) 
                ;todo: should insert directly after this class
        }
        environment := "" ; force call to __Delete immideately
    }
}

; YunitGui.Test(class1, class2, ...)
class YunitGui extends Yunit { 
    __New() {
        ; create gui here
    }
    
    Update(category, test, result) { ; overload update function
        ; update gui here
    }
}
