<#
 .Synopsis
 Helper functions for dealing with vectors
#>

# really helpful otherwise this module won't be able to use the class definitions
using module .\VectorMatricesClasses.psm1
using module .\MatriceHelpers.psm1

Import-LocalizedData -BindingVariable Msg -FileName PoshVectorMathMessages.psd1

<#
 .Synopsis
Distance of a point to a line
.Notes
Returns a single value
.Outputs
System.Decimal
#>
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
    return ((Get-Det2x2Matrice(m($vAB, $vAP))) / (Vector2Len($vAB)))
}

<#
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
#>

<#
.Synopsis
  Tests if a given point is inside a triangle
.Outputs
System.Bool
#>
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

<#
 .Synopsis
Calculates the area of a triangle
.Outputs
Double
#>
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

