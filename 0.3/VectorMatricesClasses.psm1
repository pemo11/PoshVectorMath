<#
 .Synopsis
 Classes for defining vectors and matrices
#>

# Don't use it otherwise a function like v cannot be called like v(1,2) 
# Set-StrictMode -Version Latest

Import-LocalizedData -BindingVariable Msg -FileName PoshVectorMathMessages.psd1

# Defines a vector with n values
class Vector
{
    [Decimal[]]$Values

    # Constructor
    Vector([Decimal[]]$Values)
    {
        $this.Values = $Values
    }

    # Compares two vectors based on integers
    static [bool]Compare([Vector]$v1, [Vector]$v2)
    {
        # compare with 0 digits after the decimal point
        return [Vector]::Compare($v1, $v2, 0)
    }

    # Compares two vectors based on double values with rounding
    static [bool]Compare([Vector]$v1, [Vector]$v2, [Int]$Precision)
    {
        [bool]$result = $true
        for($i = 0;$i -lt $v1.Values.Count;$i++)
        {
            if ([Math]::Round($v1.Values[$i], $Precision) -ne [Math]::Round($v2.Values[$i], $Precision))
            {
                $result = $false
            }
        }
        return $result
    }

    # Adds another vector to this vector
    [Vector]Add([Vector] $v)
    {
        $vValues = @()
        for($i=0; $i -lt $v.Values.Count; $i++)
        {
            $vValues += $this.Values[$i] + $v.Values[$i]
        }
        return v($vValues)
    }

    # Substract another vector from this vector
    [Vector]Subtract([Vector] $v)
    {
        $vValues = @()
        for($i=0; $i -lt $v.Values.Count; $i++)
        {
            $vValues += $this.Values[$i] - $v.Values[$i]
        }
        return v($vValues)
    }
    
    # Outputs the vector values without formating
    [string]ToString()
    {
        $OutVal = ""
        $this.Values.ForEach{$OutVal += ("{0,8}" -f $_)}
        return  $OutVal
    }

    # Outputs the vector values with formating
    [string]ToString($format)
    {
        $OutVal = ""
        $this.Values.ForEach{$OutVal += ("{0,8:n2}" -f $_)}
        return  $OutVal
    }
}

# Defines a matrice with n vectors that defines the columns of the matrice
class Matrice
{
    [Vector[]]$Vectors
    # 2D-Index, erster Index = Spalte, zweiter Index = Zeile
    [Decimal[,]]$Values
    [Vector[]]$Rows

    # Compare two Matrices
    static [bool]MatriceCompare([Matrice]$M1, [Matrice]$M2)
    {
        # Check if two Matrices have the name number of vectors and rows
        if ($M1.Vectors.Count -ne $M2.Vectors.Count)
        {
            throw $Global:Msg.DifferentVectorCountErrorMsg
        }
        if ($M1.Rows.Count -ne $M2.Rows.Count)
        {
            throw $Global:Msg.DifferentRowCountErrorMsg
        }
        for($i=0; $i -lt $M1.Vectors.Count; $i++)
        {
            for($j=0; $j -lt $M1.Vectors[$i].Values.Count; $j++)
            {
                if ($M1.Values[$i,$j] -ne $M2.Values[$i, $j])
                {
                    return $false
                }
            }
        }
        return $true
    }

    # Compares two matrices
    static [Bool] Compare([Matrice]$M1, [Matrice]$M2)
    {
        return [Matrice]::MatriceCompare($M1, $M2)
    }

    # Compares a matrice with the current matrice
    [Bool] Compare([Matrice]$M)
    {
        return MatriceCompare($this, $M)
    }

    # Constrcktor - initialize the matrice with an array of vectors
    Matrice([Vector[]]$Vectors)
    {
        $this.Vectors = $Vectors
        # TODO: Hier tritt ein Fehler auf!
        $this.Values = New-Object -TypeName "Decimal[,]" -ArgumentList $Vectors.Count, $Vectors[0].Values.Count
        for($i=0;$i -lt $Vectors.Count;$i++)
        {
            for($j=0;$j -lt $Vectors[$i].Values.Count;$j++)
            {
                $this.Values[$i, $j] = $Vectors[$i].Values[$j]
            }
        }
        $this.Rows = New-Object -TypeName "Vector[]" -ArgumentList $Vectors[0].Values.Count
        for($i=0;$i -lt $Vectors[0].Values.Count; $i++)
        {
            # Create a new vector for the rows
            $this.Rows[$i] = v(0..($Vectors.Count -1))
            for($j=0; $j -lt $Vectors.Count;$j++)
            {
                $this.Rows[$i].Values[$j] = $Vectors[$j].Values[$i]
            }
        }
    }

    [void]SetValue([int]$Row, [int]$Column, [double]$Value)
    {
        $this.Vectors[$Column].Values[$Row] = $Value
        $this.Rows[$Row].Values[$Column] = $Value
    }

    # Outputs the matrice with rows and columns
    [string]ToString()
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
}

Export-ModuleMember -Function * -Alias *