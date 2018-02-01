<#
 .Synopsis
 A few helper functions for dealing with matrices
#>

# really helpful otherwise this module won't be able to use the class definitions
using module .\VectorMatricesClasses.psm1

Import-LocalizedData -BindingVariable Msg -FileName PoshVectorMathMessages.psd1

<#
 .Synopsis
 Creates a vector based on dobule values
 .Outputs
 Vector
#>
function v([Decimal[]]$Values)
{
    # , operator is necessary otherwise each value of the array will be used
    New-Object -TypeName Vector -ArgumentList (,$Values)
}

<#
 .Synopsis
 Creates a matrice with Vectors
 .Outputs
 Matrice
#>
function m([Vector[]]$Vectors)
{
    # , operator is necessary otherwise each value of the array will be used
    New-Object -TypeName Matrice -ArgumentList (,$Vectors)
}

<#
 .Synopsis
 Helper functions for outputting the values of a matrice
 .Notes
 The matrice class has an overwritten ToString() method
#>
function Out-Matrice
{
    $OutVal = ""
    for($Row=0;$Row -lt $this.Matrice.GetLength(0);$Row++)
    {
        for($Column=0;$Column -lt $this.Matrice.GetLength(1);$Column++)
        {
            $OutVal += ("{0,8:n2}" -f $this.Matrice[$Row, $Column])
        }
        $OutVal
    }
    return $OutVal
}

<#
 .Synopsis
 Caculcate the determinant of a 2x2 matrice
 .Notes
 Returns a single double value
 .Outputs
 System.Decimal
#>
function Get-Det2x2Matrice
{
    param([Matrice]$M)
    # return type is Decimal
    return ($M.Vectors[0].Values[0] * $M.Vectors[1].Values[1] -
     $M.Vectors[1].Values[0] * $M.Vectors[0].Values[1])
}

<#
 .Synopsis
 Calculates the determinant of a 3x3 matrice following famous Sarrus rule
 .Notes
 Returns a single decimal value
 .Outputs
 System.Decimal
#>
function Get-Det3x3Matrice
{
    [CmdletBinding()]
    param([Matrice]$M)
    # Create a matrice with 5 columns as a 2 dimensional array
    $SarrusMatrice = New-Object -TypeName "Decimal[,]" -ArgumentList 3,5
    # Copy the first three columns
    (0..2).ForEach{
        $Column = $_
        (0..2).ForEach{
            $Row = $_
            $SarrusMatrice[$Column, $Row] = $M.Values[$Column, $Row]
        }
    }
    # Append column 1 and 2 to the new matrice
    (0..2).ForEach{$SarrusMatrice[$_,3] = $M.Values[$_,0]}
    (0..2).ForEach{$SarrusMatrice[$_,4] = $M.Values[$_,1]}

    # Calculate the determinant
    [Decimal]$Det = 0
    for($x = 0; $x -le 2; $x++)
    {
        $DiagonalProduct = 1
        for($y=0; $y -le 2; $y++)
        {
            $DiagonalProduct *= $SarrusMatrice[$y, ($y+$x)]
        }
        $Det += $DiagonalProduct
    }

    for($x = 4; $x -ge 2; $x--)
    {
        $DiagonalProduct = 1
        for($y=0; $y -le 2; $y++)
        {
            $DiagonalProduct *= $SarrusMatrice[$y, ($x-$y)]
        }
        $Det -= $DiagonalProduct
    }
    # the decimal return value
    return $Det
}

<#
 .Synopsis
 Calculates the determinant of a 3x3 matrice following famous Sarrus'rule
 .Notes
 Same kind of function as Get-Det3x3Matrice but uses Decimal values as input values
 .Input
 [Decimal[,]]
 .Outputs
 System.Decimal
#>
function Get-Det3x3
{
    [CmdletBinding()]
    param([Decimal[,]]$M)
    $SarrusM = New-Object -TypeName "Decimal[,]" -ArgumentList 3,5
    for($Row=0;$Row -lt 3;$Row++)
    {
        for($Column=0;$Column -lt 3;$Column++)
        {
            $SarrusM[$Row, $Column] = $M[$Row, $Column]
        }
    }
    for($Row=0;$Row -lt 3;$Row++)
    {
        $SarrusM[$Row,3] = $M[$Row,0]
        $SarrusM[$Row,4] = $M[$Row,1]
    }

    [Decimal]$Det = 0
    for($Column = 0;$Column -lt 3;$Column++)
    {
        $DiagonalProduct = 1
        for($Row=0;$Row -lt 3;$Row++)
        {
            $DiagonalProduct *= $SarrusM[$Row, ($Column+$Row)]
        }
        $Det += $DiagonalProduct
    }

    for($Column=4;$Column -ge 2;$Column--)
    {
        $DiagonalProduct = 1
        for($Row=0;$Row -lt 3;$Row++)
        {
            $DiagonalProduct *= $SarrusM[$Row, ($Column-$Row)]
        }
        $Det -= $DiagonalProduct
    }
    return $Det
}

<#
 .Synopsis
Calculates the determinant of a 4x4 matrice with Laplace replacement
.Notes
Returns a single Decimal value
.Outputs
System.Decimal
#>
function Get-Laplace4x4Det
{
    [CmdletBinding()]
    param([Matrice]$M)
    $Det = 0
    $SignValue = 1
    # Go through all four vectors
    for($VectorNr = 0; $VectorNr -le 3; $VectorNr++)
    {
        # create a 3x determinant
        # Initialize an array with vectors
        $DetVectors = @([Vector]::new(@(0,0,0)), [Vector]::new(@(0,0,0)), [Vector]::new(@(0,0,0)))
        # Skip first row
        for($Row = 1; $Row -le 3; $Row++)
        {
            $DetVectorNr = 0
            for($Column = 0; $Column -le 3; $Column++)
            {
                # Skip always the current row
                if ($Column -ne $VectorNr)
                {
                    $DetVectors[$DetVectorNr].Values[($Row-1)] = $M.Vectors[$Column].Values[$Row]
                    $DetVectorNr++
                }
            }
        }
        $DetMatrice = [Matrice]::new($DetVectors)
        $DetFactor = $M.Vectors[$VectorNr].Values[0]
        $Det += $SignValue * $DetFactor * (Get-Det3x3Matrice -M $DetMatrice)
        $SignValue *= -1
    }
    # the return value
    return $Det
}

<#
 .Synopsis
  Matrice multiplication with two matrices
 .Notes
  Requirements: Number of rows of the first matrice equals the number of columns of the second matrice
  returns the result matrice
  .Outputs
  Matrice
#>
function Mul-Matrice
{
    [CmdletBinding()]
    param([Matrice[]]$Matrices)
    [Matrice]$M1 = $Matrices[0]
    [Matrice]$M2 = $Matrices[1]
    # Are the requirements fullfilled?
    if ($M1.Vectors.Count -ne $M2.Vectors[0].Values.Count)
    {
        Write-Error $Msg.MatriceMultiplyRowsColumnsNotMatchingError
        return
    }
    # Create a new matrice for the result - it contains the row count of Matrice 1 and the column count of Matrice 2
    # 1. Create a vector that contains the number of values like the number of rows of Matrice 1
    $vValues = New-Object -TypeName "Decimal[]" -ArgumentList $M1.Rows.Count
    # Initialize vector with 0 values
    $v = v($vValues)
    # Create an array with Vectors
    $vArray = @()
    # Fill the array with the number of vectors like the column count of Matrice 2
    (0..($M2.Vectors.Count - 1)).ForEach{$vArray += $v}
    # 2. Create the result matrice
    $MProduct = m($vArray)
    # Go through all the rows of the result matrice
    for($i = 0; $i -lt $MProduct.Rows.Count; $i++)
    {
        # Go through all the columsn of the result matrice
        for($j = 0; $j -lt $MProduct.Vectors.Count; $j++)
        {
            # Multiply each column value with the current value of the first matrice
            # and add up the result
            $Value = 0
            for($k = 0; $k -lt $M1.Vectors.Count; $k++)
            {
                $MProduct.Values[$j, $i] += $M1.Rows[$i].Values[$k] * $M2.Vectors[$j].Values[$k]
                $Value += $M1.Rows[$i].Values[$k] * $M2.Vectors[$j].Values[$k]
            }
            # Set the value one more time so that the properties Vectors and Rows are set
            $MProduct.SetValue($i, $j, $Value)
        }
    }
    # return the resulting matrice
    return $MProduct
}


<#
.SYNOPSIS
Calculates the invert of a 3x3 matrice

.DESCRIPTION
Uses a combination of the adjunct and the determinant of a matrice
mInv = 1/det(m) * adjunct(m)

.PARAMETER MatriceValue
The values of the 3x3 matrice as a two dimensional array

.EXAMPLE
Matrix-Invert -MatriceValues $M

.NOTES
This function is not using the matrice class due to simplicity
#>
function Invert-Matrice
{
    [CmdletBinding()]
    param([Decimal[,]]$MOriginal)
    # Create extended Matrice 
    $MExt = New-Object -TypeName "Decimal[,]" -ArgumentList 5,5

    # Step 1: Copy all values from MOriginal to MExt
    for($Row=0;$Row -lt 3;$Row++)
    {
        for($Column=0;$Column -lt 3;$Column++)
        {
            $MExt[$Row, $Column] = $MOriginal[$Row, $Column]
        }
        # Append column 4 and 5
        $MExt[$Row, 3] = $MOriginal[$Row, 0]
        $MExt[$Row, 4] = $MOriginal[$Row, 1]
    }

    # Step 2: Append the first two rows at the bottom
    for($Row=3;$Row -lt 5;$Row++)
    {
        for($Column=0;$Column -lt 5;$Column++)
        {
           $MExt[$Row, $Column] = $MExt[($Row-3), $Column]
        }
    }

    # Step 3: Create another temporary matrice
    $MTemp = New-Object -TypeName "Decimal[,]" -ArgumentList 3,3

    for($Row=1; $Row -lt 4;$Row++)
    {
        for($Column=1; $Column -lt 4;$Column++)
        {
            # Matrixprodukt mit den vier Werten bilden
            $Value = $MExt[$Row, $Column] * $MExt[($Row + 1), ($Column + 1)]
            $Value -= $MExt[$Row, ($Column+1)] * $MExt[($Row + 1), $Column]
            $MTemp[($Row-1), ($Column-1)] = $Value
        }
    }

    # Step 4: Determinant following Sarrus rule
    $Det = Get-Det3x3 -M $MOriginal

    # Step 5: Apply the formula for each value of the adjunct matrice
    $MInvert = New-Object -TypeName "Decimal[,]" -ArgumentList 3,3
    for ($Row = 0; $Row -lt 3; $Row++)
    {
        for ($Column = 0;$Column -lt 3;$Column++)
        {
            $MInvert[$Row, $Column] = (1 / $Det) * $MTemp[$Row, $Column]  
        }
    }
    # Important: return a 2d array not all the values as a 1d array
    return ,$MInvert
}

# Export only certa0in functions
Export-ModuleMember -Function Get-Det3x3, Invert-Matrice, Mul-Matrice, Get-Det2x2Matrice, Get-Det3x3Matrice, Get-Laplace4x4Det, v, m
