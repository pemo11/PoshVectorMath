<#
 .Synopsis
 A few simple tests for the VectorMath module
#>

using module .\VectorMatricesClasses.psm1
using module .\VectorHelpers.psm1

describe "Calculating the vector product of vectors with three components" {

    it "Calculates the product of two vectors" {
        $v1 = v(2, -3, 4)
        $v2 = v(5, 6, 10)
        VectorScalarProd($v1, $v2)  | Should be 32
    }
}

describe "Calculating length of vectors with 2 components" {

    it "Calculates the length of a vector" {
        $v = v([Math]::Sqrt(3), 1)
        Vector2Len($v) | Should be 2
    }

    it "Calculates the length of a vector with rounding" {
        $v = v([Math]::Sqrt(3), 3)
        [Int](Vector2Len($v)) | Should be 3
    }
}

describe "Calculating the length of vectors with 3 components" {

    it "Calculates the length of a vector" {
        $v = v(2, -3, 4)
        $ResultValue = VectorLen($v)
        [Math]::Round($ResultValue, 3) | Should be 5.385
    }

    it "Calculates the length of a vector" {
        $v = v(5, 6, 10)
        $ResultValue = VectorLen($v)
        [Math]::Round($ResultValue, 3) | Should be 12.689
    }
 }

 describe "Norm vector" {

    it "Calculates the norm vector of an vector" {
       $v = v(@(1, 2, 3))
       $vNormValues = Get-NormVector -Vector $v
       # Sadly this seems to be necessary due to the fact that Get-NormVector should return
       # a vector object but for some reasons unknown to me doesn't
       $vNorm = v($vNormValues.Values)
       $vCompare = v(@(0.267, 0.535, 0.802))
       [Vector]::Compare($vNorm, $vCompare, 3) | Should be $true
    }

}

