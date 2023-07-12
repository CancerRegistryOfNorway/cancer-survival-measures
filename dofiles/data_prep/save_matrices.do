
********************************************************************************

local levels_strata = "`0'"

********************************************************************************

foreach strata of local levels_strata {

	foreach df of numlist 2/4 {
		
		clear
		svmat Ryear_period_df`df'_strata`strata', names(col)
		save "$root/results/prediction/tempfiles/Ryear_df`df'_strata`strata'.dta", replace
	}
}

********************************************************************************