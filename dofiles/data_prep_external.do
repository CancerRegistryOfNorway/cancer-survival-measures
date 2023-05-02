
********************************************************************************
//Prepping data to be ready for eastimating FP-models
********************************************************************************

stset time ,fail(death) origin(time diag_date) enter(time d(1jan2017)) exit(time exittime) scale(365.25) id(SID_surv)                            

keep if ( _st == 1 )

//Defining variable needed to identify localised prostate cancer
//and lung cancer as lifetable is stratified by these groups

gen loc_pca = site23 == 15 & stage == 1
replace loc_pca = 2 if site23 == 9 

//Merging on background rates for all cause mortality
//Limiting to 99 years of age

gen _age = min(int(age + _t), 99)
gen _year = year(DIAGNOSEDATO + _t*365.25)

merge m:1 _year sex _age loc_pca using "$lifetable", ///
	assert(match using) keepusing(prob) keep(match) nogen

gen double rate = -ln(prob)

********************************************************************************

//Loop over each strata and generate spline variables for age
egen strata = group(site)

levelsof strata, local(levels_strata)

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
			var(age) newvar(age_trunc) df(`df') p1($pc_low) p2($pc_high) splinename(rcs_temp)
			
		matrix Ryear_period_df`df'_strata`strata' = r(R)
		global knotslist_period_df`df'_strata`strata' `r(knots)'
		
		forvalues i = 1(1)`df' {
			
			replace rcs`df'_age`i' = rcs_temp`i' if ( strata == `strata' )
		}
	}
}

********************************************************************************

//Multiple imputation model to impute missing stage

gen period_temp = _t0 == 0 

forvalues i=1(1)23 {

	preserve

	keep if site23 == `i'
	sts gen na = na

	mi set mlong

	mi register imputed stage

	mi impute mlogit stage rcs4_age? na _d i.period_temp i.sex, rseed(76984) add($N_imputations) augment noisily

	tempfile f`i'
	save `f`i''

	restore

}

clear 

forvalues i=1(1)23 {
	append using `f`i''
}


//Dummy variables for stage

gen stage1 = stage if inlist(stage, 1, 2, 3)
gen stage2 = stage if inlist(stage, 4, 5, 6, 7)
gen stage3 = stage if inlist(stage, 9, 10)
gen stage4 = stage if inlist(stage,8) & inlist(site23,21,22,23)

lab val stage? stage

forvalues i = 1/4{
	
	tab stage`i', gen(stage`i'_)
}

********************************************************************************

//Interaction terms between stage and splines for age

forvalues i=1(1)4 {

	gen stage1_2_rcs4_age`i' = stage1_2*rcs4_age`i'
	gen stage1_3_rcs4_age`i' = stage1_3*rcs4_age`i'
	gen stage2_2_rcs4_age`i' = stage2_2*rcs4_age`i'
	gen stage2_3_rcs4_age`i' = stage2_3*rcs4_age`i'
	gen stage2_4_rcs4_age`i' = stage2_4*rcs4_age`i'
	gen stage3_2_rcs4_age`i' = stage3_2*rcs4_age`i'
}

save "$root\dta\analysisfile_imputed.dta", replace


//Keep matrices for later predictions

foreach strata of local levels_strata {

	foreach df of numlist 2/4 {
	
		clear
		svmat Ryear_period_df`df'_strata`strata', names(col)
		save "$root\matrices\Ryear_df`df'_strata`strata'.dta", replace
	}
}


********************************************************************************

//Make file to hold all global macros needed for later predictions

do "$root\dofiles\export_globals.do"

capt noisily erase "$root\dofiles\global_knotlists.do"

export_globals , pattern(knotslist*) newfilename("$root\dofiles\global_knotlists.do")
