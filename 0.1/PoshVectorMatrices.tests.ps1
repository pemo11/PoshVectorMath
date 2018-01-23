<#
 .Synopsis
 A few tests with matrices
#>

using module .\VectorMatricesClasses.psm1
using module .\VectorMatricesHelpers.psm1

describe "calculating the product of two matrices" {

    it "calculates the product of a 2x3 and a 3x2 matrice" {
        $v1 = v(1, 2, 1)
        $v2 = v(2, 1, 2)
        $M1 = m($v1,$v2)
        
        $v1 = v(1,2)
        $v2 = v(0,3)
        $v3 = v(2,0)
        $M2 = m($v1,$v2,$v3)
        
        $M = MatriceMul($M1, $M2)

        $v1 = v(5,11,4)
        $v2 = v(1,2,0)
        $v3 = v(5,13,12)
        
        $MResult = m($v1,$v2,$v3)

        [Matrice]::Compare($M, $MResult) | Should be $true  
    }

}
