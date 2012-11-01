Yunit.TestGui(SomeTestSuiteClass, SomeOtherSuiteClass)

class SomeTestSuiteClass {
    __New() {
    }
    Test1() {
    }
    Test2() {
    }
    __Delete() {
    }
    class SomeCategory {
        __New() {
            this.x := 123
            this.y := 456
        }
        Test() {
            Yunit.assert(this.x+this.y == 579)
        }
        class NestedCategory { ; categories can be nested
            __New() {
                this.x := 123
                this.y := 456
            }
            Test1() {
                Yunit.assert(this.x/this.y < 1) ; like this
            }
        }
    }
}