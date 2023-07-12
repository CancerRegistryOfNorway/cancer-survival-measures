
********************************************************************************

local temp "$root/results/estimation/tempfiles"
local pred "$root/results/prediction/tempfiles"

********************************************************************************
//Combine all datasets with results
********************************************************************************

clear 

foreach site of numlist $siteList {
	
	forvalues i=1(1)$N_imputations {
		
		capt noisily append ///
			using "`pred'/predictions_site`site'_imputation`i'.dta"
	}
}

save "`pred'/predictions_stratified_site_imputation.dta", replace

********************************************************************************
//Conditional crude probabilities
********************************************************************************

use "`pred'/predictions_stpm2cmcond.dta", clear

foreach v of varlist crc* cro* {
	
	bysort site23 (imputation): egen `v'_i = mean(`v')
}

bysort site23: keep if _n == 1
keep site23 *_i

rename *_i *

tempfile crudecond
save `crudecond'

********************************************************************************
//Net survival and crude probabilities
********************************************************************************

clear all

use "`pred'/predictions_stratified_site_imputation.dta", clear

capt drop *_se 
capt drop *_lci *_uci
keep site23 temptime netsurv* crude* imputation
capt drop *cond*

capt rename crude_sex?_stage?_agr?_disease crude_sex?_stage?_agr?_dis
capt rename crude_sex?_stage??_agr?_disease crude_sex?_stage??_agr?_dis

foreach v of varlist netsurv* crude* {
	
	bysort site23 temptime (imputation): egen `v'_i = mean(`v')
}

bysort site23 temptime: keep if _n == 1
keep site23 temptime *_i

rename *_i *

save "`pred'/predicted_netsurv_crudeprobs_stratified_site_imputation.dta", replace

********************************************************************************
//Expected remaining lifetime and lifeyears lost
********************************************************************************

use "`pred'/predictions_stratified_site_imputation.dta", clear

keep if t80 == 80

capt drop *_se *_lci *_uci 
capt drop *cond*

foreach v of varlist obs* {
	
	bysort site23 (imputation): egen `v'_imp = mean(`v')
}

bysort site23: keep if _n == 1
keep site23 *_imp exp*

foreach sex of numlist 0/1 {
	
	foreach stage of numlist 1/10 {
		
		foreach agr of numlist 1/5 {
			
			capt gen lel_years_sex`sex'_stage`stage'_agr`agr' 	///
				= explifeexp_sex`sex'_stage`stage'_agr`agr'  	///
				- obslifeexp_sex`sex'_stage`stage'_agr`agr'_imp
				
			capt gen lel_prop_sex`sex'_stage`stage'_agr`agr' 	///
			= (explifeexp_sex`sex'_stage`stage'_agr`agr' 		///
			- obslifeexp_sex`sex'_stage`stage'_agr`agr'_imp) 	///
			/ (explifeexp_sex`sex'_stage`stage'_agr`agr')
		}
	}
}

rename *_imp *

save "`pred'/predicted_lel_stratified_site_imputation.dta", replace

********************************************************************************
// Conditional estimates - expected remaining lifetime and 
// lifeyears lost
********************************************************************************

use "`pred'/predictions_stratified_site_imputation.dta", clear 

capt drop *_se *_lci *_uci
keep if temptime == 0
keep site23 imputation *cond*

foreach v of varlist obslifeexp* explifeexp* {
	
	bysort site23 (imputation): egen `v'_i = mean(`v')
}

bysort site23: keep if _n == 1
keep site23 *_i

rename *_i *

foreach sex of numlist 0/1 {
	
	foreach time of numlist 0/5 {
		
		forvalues i=1(1)10 {
		
			capt gen lel_sex`sex'_stage`i'_cond`time' 		///
				= explifeexp_sex`sex'_stage`i'_cond`time' 	///
				- obslifeexp_sex`sex'_stage`i'_cond`time'
				
			capt gen lel_prop_sex`sex'_stage`i'_cond`time' 	///
				= lel_sex`sex'_stage`i'_cond`time' 			///
				/ explifeexp_sex`sex'_stage`i'_cond`time'
		}
	}
}

merge 1:1 site23 using `crudecond', assert(match) nogen

save "`pred'/predicted_conditional_estimates_stratified_site_imputation.dta", replace

********************************************************************************
