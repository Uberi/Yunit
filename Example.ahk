#Include <Yunit>

Yunit.Test(NumberTestSuite)
; YunitGui.Test(NumberTestSuite)

class NumberTestSuite
{
    Begin()
    {
        this.x := 123
        this.y := 456
    }
    Test_Sum()
    {
        Yunit.assert(this.x + this.y == 579)
    }
    Test_Division()
    {
        Yunit.assert(this.x / this.y < 1)
        Yunit.assert(this.x / this.y > 0.25)
    }
    Test_Multiplication()
    {
        Yunit.assert(this.x * this.y == 56088)
    }
    End()
    {
        this.remove("x")
        this.remove("y")
    }
    class Negatives
    {
        Begin()
        {
            this.x := -123
            this.y := 456
        }
        Test_Sum()
        {
            Yunit.assert(this.x + this.y == 333)
        }
        Test_Division()
        {
            Yunit.assert(this.x / this.y > -1)
            Yunit.assert(this.x / this.y < -0.25)
        }
        Test_Multiplication()
        {
            Yunit.assert(this.x * this.y == -56088)
        }
        Test_Fails()
        {
            Yunit.assert(this.x - this.y == 0, "oops!")
        }
        End()
        {
            this.remove("x")
            this.remove("y")
        }
    }
}
