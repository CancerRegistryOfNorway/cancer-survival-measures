
********************************************************************************

args levels_strata

********************************************************************************

gen period_temp = ( _t0 == 0 ) 

forvalues i=1(1)23 {

	preserve

		keep if ( site23 == `i' )
		sts gen cum_haz = na // Nelson-Aalen estimate, H(t)

		mi set mlong
		mi register imputed stage

		mi impute mlogit stage rcs4_age? cum_haz _d i.period_temp i.sex , ///
			rseed(76984) /// MACRO??
			add($N_imputations) augment noisily

		tempfile f`i'
		save `f`i''

	restore

}

********************************************************************************

clear 

forvalues i=1(1)23 {
	
	append using `f`i''
}

********************************************************************************

//Dummy variables for stage

gen byte stage1 = stage if inlist(stage, 1, 2, 3)
gen byte stage2 = stage if inlist(stage, 4, 5, 6, 7)
gen byte stage3 = stage if inlist(stage, 9, 10)
gen byte stage4 = stage if inlist(stage, 8) & inlist(site23, 21, 22, 23)

lab val stage? stage

forvalues i = 1/4{
	
	tab stage`i', gen(stage`i'_)
}

********************************************************************************

//Interaction terms between stage and splines for age

forvalues i=1(1)4{

	gen stage1_2_rcs4_age`i' = stage1_2*rcs4_age`i'
	gen stage1_3_rcs4_age`i' = stage1_3*rcs4_age`i'
	gen stage2_2_rcs4_age`i' = stage2_2*rcs4_age`i'
	gen stage2_3_rcs4_age`i' = stage2_3*rcs4_age`i'
	gen stage2_4_rcs4_age`i' = stage2_4*rcs4_age`i'
	gen stage3_2_rcs4_age`i' = stage3_2*rcs4_age`i'
}

********************************************************************************
