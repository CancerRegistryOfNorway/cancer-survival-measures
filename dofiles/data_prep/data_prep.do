
use "P:\Registeravdelingen\CIN-2021-SI\data\cin\CIN_surv_2021_prepped", clear
********************************************************************************

local data_prep "$root\dofiles\data_prep"

********************************************************************************

//Prepping data to be ready for estimating FP-models

do "`data_prep'/define_follow_up_and_merge_reference_mortality.do"


********************************************************************************

//Loop over each strata and generate spline variables for age

do "`data_prep'/define_age_splines_per_site.do" /* Returns levels_strata */

********************************************************************************

//Perform multiple imputation on stage

isid PERSONLOEPENR site23
sort PERSONLOEPENR site23 

do "`data_prep'/multiple_imputation_stage.do" `levels_strata'

********************************************************************************

//Save analysisfile

label data "Data prepared for analysis, including data imputed on stage"
save "$root\data\datafile.dta", replace

********************************************************************************

//Save matrices for different Stata sessions
do "`data_prep'/save_matrices.do" `levels_strata'

********************************************************************************

//Save global macros needed in parallell Stata sessions 

export_globals , 		///
	pattern(knotslist*) ///
	newfilename("$root/dofiles/estimation/definitions/models/global_knotlists.do")

********************************************************************************
