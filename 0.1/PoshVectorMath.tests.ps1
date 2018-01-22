<#
 .Synopsis
 A few simple tests for the VectorMath module
#>

using module .\VectorMatricesClasses.psm1
using module .\VectorMatricesHelpers.psm1

describe "calculating the determinate of 2x2 matrices" {

    it "calculates the determinate of a 2x2 matrice" {
        $v1 = v(1,2)
        $v2 = v(3,4)
        $M = m($v1, $v2)
        detv2($M) | Should be -2
    }

    it "calculates the determinate of a 2x2 matrice" {
        $v1 = v(0, 3)
        $v2 = v(2,-1)
        $M = m($v1, $v2)
        detv2($M) | Should be -6
    }
}

describe "calculating the vector product" {

    it "calculates the product of two vectors" {
        $v1 = v([Math]::Sqrt(3), 1)
        $v2 = v([Math]::Sqrt(3), 3)
        vector2prod($v1, $v2)  | Should be 6
    }

}

describe "calculating the vector length" {

    it "calculates the length of a vector" {
        $v = v([Math]::Sqrt(3), 1)
        vector2len($v) | Should be 2
    }

    it "calculates the length of a vector with rounding" {
        $v = v([Math]::Sqrt(3), 3)
        [Int](vector2len($v)) | Should be 3
    }

 }
