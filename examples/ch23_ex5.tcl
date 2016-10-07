proc RandomNumber { min max } {
set maxFactor [expr [expr $max + 1] - $min]
set value [expr int([expr rand() * 300000])]
set value [expr [expr $value % $maxFactor] + $min]
return $value
}
