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
    [Double[]]$Values

    # Constructor
    Vector([Double[]]$Values)
    {
        $this.Values = $Values
    }

}

# Defines a matrice with n vectors that defines the columns of the matrice
class Matrice
{
    [Vector[]]$Vectors
    # 2D-Index, erster Index = Spalte, zweiter Index = Zeile
    [Double[,]]$Values
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
        return MatriceCompare($M1, $M2)
    }

    # Compares a matrice with the current matrice
    [Bool] Compare([Matrice]$M)
    {
        return MatriceCompare($this, $M)
    }

    # Construktor - initialize the matrice with an array of vectors
    Matrice([Vector[]]$Vectors)
    {
        $this.Vectors = $Vectors
        $this.Values = New-Object -TypeName "Double[,]" -ArgumentList $Vectors.Count, $Vectors[0].Values.Count
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
}

