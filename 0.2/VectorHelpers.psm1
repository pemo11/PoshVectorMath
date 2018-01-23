<#
 .Synopsis
 A few helper functions for dealing with vectors
#>

# really helpful otherwise this module won't be able to use the class definitions
using module .\VectorMatricesClasses.psm1
using module .\MatricesHelpers.psm1

# Length of a vector with 2 components
function Vector2Len
{
    param([Vector]$Vector)
    # use decimal to avoid rounding errors that makes comparison difficult
    [Decimal]([Math]::Sqrt([Math]::Pow($Vector.Values[0],2)+
     [Math]::pow($Vector.Values[1],2)))
}

# Scalarprocukt of two Vectors with 2 components
function Vector2Prod
{
    param([Vector[]]$Vectors)
    # use decimal to avoid rounding errors that makes comparison difficult
    [Decimal]($Vectors[0].Values[0] * $Vectors[1].Values[0] + $Vectors[0].Values[1] * $Vectors[1].Values[1])
}

# Calculates the angle between two vectors
function Vector2Angle
{
    param([Vector[]]$Vectors)
    # Separates Klammerpaar erforrderlich, damit mit dem Rückgabewert einer Function auch
    # gerechnet werden kann - lästig, aber nicht anders machbar
    $v = (vector2prod($Vectors)) / ((vector2len($Vectors[0])) * (vector2len($Vectors[1]))) 
    [Math]::Acos($v) * 180 / [Math]::PI
}

# Calculates the norm vector
function NormVector2
{   
    param([Vector]$Vector)
    $vLen = Vector2Len($Vector)
    v($vlen * $Vector[0], $vlen * $Vector[1])
}

# Distance of a point to a line
function Point2LineDistance
{
    param([Vector[]]$Vectors)
    $vA = $Vectors[0]
    $vB = $Vectors[1]
    $vP = $Vectors[2]
    $vAB = v(($vB.Values[0]-$vA.Values[0]),($vB.Values[1]-$vA.Values[1]))
    $vAP = v(($vP.Values[0]-$vA.Values[0]),($vP.Values[1]-$vA.Values[1]))
    # $vLenAB = Vector2Len($vAB)
    # $vLenAP = Vector2Len($vAP)
    # Can't believe I have to use all these parantheses!
    (Get-Det2x2Matrice(m($vAB, $vAP))) / (Vector2Len($vAB))
}

# Distance of a point to a line
function Point2LineDistance2
{
    param([Vector]$PVector, [Double]$Angle)
    $cosValue = [Math]::Cos($Angle / 180 * [Math]::PI)
    $aValue = 1
    $vValue = 1 / $cosValue
    $bValue = [Math]::sqrt([Math]::Pow($vValue, 2) - 1)
    $v = v($aValue, $bValue)
    $m = m($v, $PVector)
    (detv2($m)) / (Vector2len($v))
}

# Tests if a given point is inside a triangle
function PointInTriangle
{
    param([Vector[]]$Vectors)
    [Vector]$vA = $Vectors[0]
    [Vector]$vB = $Vectors[1]
    [Vector]$vC = $Vectors[2]
    [Vector]$vP = $Vectors[3]
    $vAB = v(($vB.Values[0]-$vA.Values[0]), ($vB.Values[1]-$vA.Values[1]))
    $vBC = v(($vC.Values[0]-$vB.Values[0]), ($vC.Values[1]-$vB.Values[1]))
    $vCA = v(($vA.Values[0]-$vC.Values[0]), ($vA.Values[1]-$vC.Values[1]))
    $vAP = v(($vP.Values[0]-$vA.Values[0]), ($vP.Values[1]-$vA.Values[1]))
    $vBP = v(($vP.Values[0]-$vB.Values[0]), ($vP.Values[1]-$vB.Values[1]))
    $vCP = v(($vP.Values[0]-$vC.Values[0]), ($vP.Values[1]-$vC.Values[0]))
    $detABAP = Get-Det2x2Matrice(m($vAB, $vAP))
    $detBCBP = Get-Det2x2Matrice(m($vBC, $vBP))
    $detCACP = Get-Det2x2Matrice(m($vCA, $vCP))
    if ($detABAP -gt 0 -and $detBCBP -gt 0 -and $detCACP -gt 0)
    {
        return $true
    }
    return $false
}

# Calculates the area of a triangle
function AreaTriangle
{
    param([Vector[]]$Vectors)
    $vA = $Vectors[0]
    $vB = $Vectors[1]
    $vC = $Vectors[2]
    $vAB = v(($vB.Values[0]-$vA.Values[0]),($vB.Values[1]-$vA.Values[1]))
    $vAC = v(($vC.Values[0]-$vA.Values[0]),($vC.Values[1]-$vA.Values[1]))
    (Get-Det2x2Matrice(m($vAB, $vAC))) / 2
}

# Calculates the junction between two lines
function LineJunction
{
    param([Matrice[]]$LineMatrices)
    $M1 = $LineMatrices[0]
    $M2 = $LineMatrices[1]
    $v1A = $M1.Vectors[0]
    $v1B = $M1.Vectors[1]
    $v2A = $M2.Vectors[0]
    $v2B = $M2.Vectors[1]
    # Set up two equations
    # SolveEquation


}