clear all

********************************************************************************

// Define indicators for stage and at-arguments for models

include "$root\dofiles\define_stage_at_by_site_group_scalars.do" 

run "$root\dofiles\global_knotlists.do"
		
********************************************************************************							  

foreach site of numlist 1/23 {
	
	do "$root\dofiles\data_prep\define_lifetables.do" `site'
		
	if( inlist(`site', 11, 12) ){
		
		local site_group == 2
	}
	
	else if( inlist(`site', 19) ){ 
	
		local site_group == 3
	}
	
	else if( inlist(`site', 21, 22, 23) ){
		
		local site_group == 4
	}
	
	else{
		
		local site_group == 1
	}
			
	forvalues i=1(1)$N_imputations {

		use "$root\est_results\models_converged", clear

		split modelname, p("_") gen(m)
		replace m2 = usubinstr(m2,"site","",.) 
		replace m3 = usubinstr(m3,"variant","",.) 

		destring m2 m3, replace
		rename (m2 m3) (site variant)

		keep if imputation == `i'

		bysort site (variant): keep if _n == 1

		keep if site == `site'

		tempfile sterfile
		tempvar fh
		gen `fh' = filewrite("`sterfile'", sterfilename) 
		est use "`sterfile'"	
		est replay

		use "$root\dta\analysisfile_imputed.dta", clear 

		mi extract `i', clear

		keep if site23 == `site'
		su strata, meanonly		
		local strata = `r(min)'
		keep if ( _st == 1 ) & ( _t0 == 0 )		
		su age, detail
		local age = `r(p50)'

		// adopath ++ "$root\programs" //Path to stpm2cmcond ado-file

		forvalues df = 2(1)4 {
			
			preserve
			
				use "$root\matrices\Ryear_period_df`df'_strata`strata'.dta", clear				
				mkmat c?, matrix(Ryear`df')
				
			restore
		}

		rcsgen, scalar(`age') gen(c) ///
			knots(${knotslist_period_df4_strata`strata'}) rmatrix(Ryear4)

		rcsgen, scalar(`age') gen(d) ///
			knots(${knotslist_period_df3_strata`strata'}) rmatrix(Ryear3)
		
		rcsgen, scalar(`age') gen(e) ///
			knots(${knotslist_period_df2_strata`strata'}) rmatrix(Ryear2)
	
		do "$root\dofiles\stpm2cmcond.do" `site_group'

		keep if _n == 1
		keep crc* cro*
		gen site23 = `site'
		gen imputation = `i'
		order site23 imputation, first

		tempfile f`site'`i'
		save `f`site'`i''
	}	
} 

clear

foreach site of numlist 1/23 {

	forvalues i=1(1)$N_imputations {

		append using `f`site'`i''
	}
}

compress
save "$root\tempfiles\predictions_stpm2cmcond.dta", replace	

********************************************************************************	
