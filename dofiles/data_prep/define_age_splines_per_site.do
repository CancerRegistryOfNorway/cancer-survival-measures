
********************************************************************************

egen strata = group(site23)

levelsof strata, local(levels_strata)

c_local levels_strata `levels_strata' // Export local to caller

forvalues i = 1(1)4 {
	
	gen rcs4_age`i' = .
	
	if `i' <= 3 {
		gen rcs3_age`i' = . 
	}
	
	if `i' <= 2 {
		gen rcs2_age`i' = . 
	}
}

foreach df of numlist 2/4 {
	
	foreach strata of local levels_strata {
		
		capt drop age_trunc* rcs_temp* 
		
		rcsgen_wrap if ( strata == `strata' ) , ///
			var(age) newvar(age_trunc) df(`df') ///
			p1($pc_low) p2($pc_high) splinename(rcs_temp)
			
		matrix Ryear_period_df`df'_strata`strata' = r(R)
		global knotslist_period_df`df'_strata`strata' `r(knots)'
		
		forvalues i = 1(1)`df' {
			
			replace rcs`df'_age`i' = rcs_temp`i' if ( strata == `strata' )
		}
	}
}

********************************************************************************