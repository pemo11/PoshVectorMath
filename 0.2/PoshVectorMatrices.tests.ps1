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

        $v1 = v(5,4,5)
        $v2 = v(6,3,6)
        $v3 = v(2,4,2)
        
        $MResult = m($v1,$v2,$v3)

        [Matrice]::Compare($M, $MResult) | Should be $true  
    }
}

describe "calculating the determinant of 3x3 matrices" {
        
        it "calculates thedeterminant of a 3x3 matrice" {
            $v1 = v(1, 4, 7)
            $v2 = v(2, 5, 8)
            $v3 = v(3, 6, 9)
            $M = m($v1, $v2, $v3)
            $det = Get-Det3x3Matrice($M)
            $det | Should be 0
        }
}

describe "calculating the determinant of 4x4 matrices" {

    it "calculates the determinant of the first 4x4 matrice" {
        $v1 = v(2, 1, 1, 3)
        $v2 = v(4, 3, 2, -2)
        $v3 = v(-1, 6, 4, 1)
        $v4 = v(2, 4, 5, 1)
        $M = m($v1, $v2, $v3, $v4)
        $ResultValue = -238
        Get-Laplace4x4Det $M | Should be $ResultValue
    }

    it "calculates the determinant of the second 4x4 matrice" {
        $v1 = v(1, 2, 3, 4)
        $v2 = v(5, 6, 7, 8)
        $v3 = v(1, 2, 3, 4)
        $v4 = v(5, 6, 7, 8)
        $M = m($v1, $v2, $v3, $v4)
        $ResultValue = 0
        Get-Laplace4x4Det $M | Should be $ResultValue
    }
        
}
