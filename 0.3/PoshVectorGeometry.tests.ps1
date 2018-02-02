<#
 .Synopsis
 Tests for geometric operations with vectors
#>

using module .\VectorMatricesClasses.psm1
using module .\MatriceHelpers.psm1
using module .\VectorHelpers.psm1

describe "tests with triangles" {

    it "tests if a point is not inside a triangle" {
        $vA = v(0,2)
        $vB = v(6,0)
        $vC = v(3,6)
        $vP = v(5,4)
        PointInTriangle($vA, $vB, $vC, $vP) | Should be $false 
    }

    it "tests the area of a triangle" {
        $vA = v(2, 1)
        $vB = v(5, 4)
        $vC = v(-1, 6)
        AreaTriangle($vA, $vB, $vC) | Should be 12
    }

}

describe "Calculating the distance between a point a line" {

    it "Calculates the distance between a point a line" {
        $vP = v(5,3)
        $vA = v(1,1)
        $vB = v(1,-1)
        Point2LineDistance(@($vA, $vB, $vP)) | Should be 2
    }
 }

 describe "Calculating the angle between two vectors" {

     it "Calculates an angle of 30 degree" {
        $v1 = v([Math]::Sqrt(3), 1)
        $v2 = v([Math]::Sqrt(3), 3)
        $ResultValue = Vector2Angle($v1, $v2)
        $ResultValue | Should be 30
     }

     it "Calculates an angle of two vectors with 3 components" {
        $v1 = v(2, -3, 4)
        $v2 = v(5, 6, 10)
        $ResultValue = VectorAngle($v1, $v2)
        [Math]::Round($ResultValue, 1)  | Should be 62.1
     }

 }

 describe "more specialized tests with vectors" {

    it "calculates the distance between a point and a line" {
        $vA = v(1,1)
        $vB = v(3,3)
        $vP = v(2,3)
        $pD = Point2LineDistance($vA, $vB, $vP)
    }

}
