<#
 .Synopsis
 A few helper functions for dealing with vectors and matrices
#>

# really helpful otherwise this module won't be able to use the class definitions
using module .\VectorMatricesClasses.psm1

<#
 .Synopsis
 Creates a vector
#>
function v([Double[]]$Values)
{
    # , operator is necessary otherwise each value of the array will be used
    New-Object -TypeName Vector -ArgumentList (,$Values)
}

<#
 .Synopsis
 Creates a matrice with Vectors
#>
function m([Vector[]]$Vectors)
{
    # , operator is necessary otherwise each value of the array will be used
    New-Object -TypeName Matrice -ArgumentList (,$Vectors)
}


# Length of a vector with 2 components
function Vector2Len
{
    param([Vector]$Vector)
    # use decimal to avoid rounding errors that makes comparison difficult
    [Decimal]([Math]::Sqrt([Math]::Pow($Vector.Values[0],2)+[Math]::pow($Vector.Values[1],2)))
}

# Scalarprocukt of two Vectors with 2 components
function Vector2Prod
{
    param([Vector[]]$Vectors)
    # use decimal to avoid rounding errors that makes comparison difficult
    [Decimal]($Vectors[0].Values[0] * $Vectors[1].Values[0] + $Vectors[0].Values[1] * $Vectors[1].Values[1])
}

# Calculates the angle between two vectors
function VectorAngle
{
    param([Vector[]]$Vectors)
    # Separates Klammerpaar erforrderlich, damit mit dem Rückgabewert einer Function auch
    # gerechnet werden kann - lästig, aber nicht anders machbar
    $v = (vector2prod($Vectors)) / ((vector2len($Vectors[0])) * (vector2len($Vectors[1]))) 
    [Math]::Acos($v) * 180 / [Math]::PI
}

# Distance of a point to a line
function Point2LineDistance
{
    param([Vector]$PVector, [Double]$Angle)
    $cosValue = [Math]::Cos($Angle / 180*[Math]::PI)
    $aValue = 1
    $vValue = 1 / $cosValue
    $bValue = [Math]::sqrt([Math]::Pow($vValue, 2) - 1)
    $v = v($aValue, $bValue)
    $m = m($v, $PVector)
    (detv2($m)) / (Vector2len($v))
}

# Caculcate the determinant of a 2x2 matrice
function DetV2
{
    param([Matrice]$M)
    $M.Vectors[0].Values[0] * $M.Vectors[1].Values[1] -
     $M.Vectors[1].Values[0] * $M.Vectors[0].Values[1]
}

# Calculates the determinant of a 3x3 matrice following famous Sarrus'rule
function Get-Det3x3Matrice
{
    [CmdletBinding()]
    param([Matrice]$M)
    # Create a matrice with 5 columns
    $SarrusMatrice = New-Object -TypeName "Double[,]" -ArgumentList 3,5
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
    $Det = 0
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
    # the return value
    $Det
}

# Calculates the determinant of a 4x4 matrice with Laplace
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
    $Det
}

# Matrice multiplication
# Requirements: Number of rows of the first matrice equals the number of columns of the second matrice
function MatriceMul
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
    $vValues = New-Object -TypeName "Double[]" -ArgumentList $M1.Rows.Count
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
    $MProduct
}
