<#
 .Synopsis
 More special Vector tests
#>

using module .\VectorMatricesClasses.psm1
using module .\VectorHelpers.psm1

describe "more specialized tests with vectors" {

    it "calculates the distance between a point and a line" {

        $v
        param([Vector]$PVector, [Double]$Angle)

        Point2LineDistance2
    }

}
