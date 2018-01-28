<#
 .Synopsis
 More special Vector tests
#>

using module .\VectorMatricesClasses.psm1
using module .\VectorHelpers.psm1

describe "more specialized tests with vectors" {

    it "calculates the distance between a point and a line" {

        $vA = v(1,1)
        $vB = v(3,3)
        $vP = v(2,3)
        $pD = Point2LineDistance($vA, $vB, $vP)
        
    }

}
