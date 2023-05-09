
********************************************************************************

args levels_strata

********************************************************************************

foreach strata of local levels_strata {

	foreach df of numlist 2/4 {
	
		clear
		svmat Ryear_period_df`df'_strata`strata', names(col)
		save "$root/data/Ryear_df`df'_strata`strata'.dta", replace
	}
}

********************************************************************************