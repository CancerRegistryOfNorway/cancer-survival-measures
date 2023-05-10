
clear

set obs 10
gen site = _n 

egen strata = group(site)

levelsof strata, local(levels_strata)

c_local levels_strata `levels_strata' // Export local to caller