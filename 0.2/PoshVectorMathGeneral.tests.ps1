<#
 .Synopsis
 A few general tests with matrices, vectors etc.
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