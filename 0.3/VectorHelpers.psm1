<#
 .Synopsis
 A few helper functions for dealing with vectors
#>

# really helpful otherwise this module won't be able to use the class definitions
using module .\VectorMatricesClasses.psm1
using module .\MatriceHelpers.psm1

Import-LocalizedData -BindingVariable Msg -FileName PoshVectorMathMessages.psd1

<#
 .Synopsis
 Length of a vector with 2 components
 .Outputs
 System.Decimal
#>
function Vector2Len
{
    param([Vector]$Vector)
    # use decimal to avoid rounding errors that makes comparison difficult
    [Decimal]([Math]::Sqrt([Math]::Pow($Vector.Values[0],2)+
     [Math]::pow($Vector.Values[1],2)))
}

<#
 .Synopsis
 Length of a vector with any number of components
 .Outputs
 System.Decimal
#>
function Get-VectorLen
{
    param([Vector]$Vector)
    $SumValue = 0
    $Vector.Values.ForEach{$SumValue += [Math]::pow($_, 2)}
    return [Decimal][Math]::Sqrt($SumValue)
}

Set-Alias -Name VectorLen -Value Get-VectorLen

<#
 .Synopsis
 Gets the norm vector of a vector
 .Inputs
 Vector
 .Outputs
 Vector
#>
function Get-NormVector
{
    param([ValidateNotNull()][Parameter(Mandatory=$true)][Vector]$Vector)
    $SumValue = 0
    $VectorNeu = [Vector]::new($Vector.Values)
    for($i=0; $i -lt $Vector.Values.Count;$i++)
    {
        $SumValue += [Math]::Pow($Vector.Values[$i], 2)
    }
    $SumValue
    $NormValue = 1 / [Math]::Sqrt($SumValue)

    for($i=0;$i -lt $Vector.Values.Count;$i++)
    {
        $VectorNeu.Values[$i] = $Vector.Values[$i] * $NormValue
    }
    return $VectorNeu
}

<#
 .Synopsis
 Scalarproduct of two vectors with 2 components
 .Outputs
 System.Decimal
#>
function Get-Vector2ScalarProd
{
    param([Vector[]]$Vectors)
    # use decimal to avoid rounding errors that makes comparison difficult
    [Decimal]($Vectors[0].Values[0] * $Vectors[1].Values[0] + $Vectors[0].Values[1] * $Vectors[1].Values[1])
}

Set-Alias -Name Vector2ScalarProd -Value Get-Vector2ScalarProd

<#
 .Synopsis
 Scalarprocukt of two Vectors with any number of components
 .Outputs
 System.Decimal
#>
function Get-VectorScalarProd
{
    param([Vector[]]$Vectors)
    $ProdValue = 0
    # Check for two vectors with the same length
    if ($Vectors.Count -ne 2)
    {
        Write-Error  $Msg.VectorCountNotEqualErrorMsg
    }
    if ($Vectors[0].Values.Count -ne $Vectors[1].Values.Count)
    {
        Write-Error  $Msg.VectorValuesNotEqualErrorMsg
    }
    for($i = 0;$i -lt $Vectors[0].Values.Count;$i++)
    {
        $ProdValue += $Vectors[0].Values[$i] * $Vectors[1].Values[$i]
    }
    return $ProdValue
}

Set-Alias -Name VectorScalarProd -Value Get-VectorScalarProd

<#
<#
 .Synopsis
 Calculates the angle between two vectors with two components
 .Outputs
 System.Double
#>
function Get-Vector2Angle
{
    param([Vector[]]$Vectors)
    # An extra pair of parantheses is necessary for being able to use the return value of a function
    # inside an expression (why, o why, Bruce;)
    $v = (Vector2ScalarProd($Vectors)) / ((Vector2Len($Vectors[0])) * (Vector2Len($Vectors[1]))) 
    [Math]::Acos($v) * 180 / [Math]::PI
}
#>

<#
 .Synopsis
  Calculates the angle between two vectors with 2 components
  .Inputs
  [Vector[]]
  .Outputs
  Decimal
#>
function Get-Vector2Angle
{
    [CmdletBinding()]
    param([Vector[]]$Vectors)
    [Vector]$v1 = $Vectors[0]
    [Vector]$v2 = $Vectors[1]
    $VectProd = $v1.Values[0] * $v2.Values[0] + $v1.Values[1] * $v2.Values[1]
    $v1Len = Vector2Len($v1)
    $v2Len = Vector2Len($v2)
    $AngleValue = $VectProd / ($v1Len * $v2Len)
    [Decimal]$Angle = [Math]::Acos($AngleValue) * 180 / [Math]::PI 
    return $Angle
}

Set-Alias -Name Vector2Angle -Value Get-Vector2Angle

<#
 .Synopsis
  Calculates the angle between two vectors with 3 components or more (?)
  .Inputs
  [Vector[]]
  .Outputs
  Decimal
#>
function Get-VectorAngle
{
    [CmdletBinding()]
    param([Vector[]]$Vectors)
    [Vector]$v1 = $Vectors[0]
    [Vector]$v2 = $Vectors[1]
    $VectProd = VectorScalarProd($Vectors)
    $v1Len = VectorLen($v1)
    $v2Len = VectorLen($v2)
    $AngleValue = $VectProd / ($v1Len * $v2Len)
    [Decimal]$Angle = [Math]::Acos($AngleValue) * 180 / [Math]::PI 
    return $Angle
}

Set-Alias -Name VectorAngle -Value Get-VectorAngle

Export-ModuleMember -Function * -Alias *