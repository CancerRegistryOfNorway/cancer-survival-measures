
********************************************************************************
* Masterfile for estimating flexible parametric relative survival models
* and predicting a range of different survival measures
* See www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin_report-special-issue.pdf
* for results
********************************************************************************

version 17
clear

********************************************************************************

global root "H:/cancer-survival-measures/"
				
//global root "H:\tamy\My Documents\cancer-survival-measures"
do "$root/dofiles/settings/dependencies.do"				
				
include "$root/dofiles/settings/global_definitions.do"

********************************************************************************

// Data-management

//do "$root/dofiles/data_prep/data_prep_internal.do" 
do "$root/dofiles/data_prep/data_prep.do" 

// Run model-selection algorithm to estimate FP-models
do "$root/dofiles/estimation/estimation.do"  

// Predict net survival, crude probabilities and lifeyears lost by subgroups
// Code starts multiple parallell Stata-sessions to reduce computation time
do "$root/dofiles/prediction/parallell_sessions.do"

// Predict conditional crude probabilities using undocumented command stpm2cmcond 
do "$root/dofiles/prediction/predictions_cmcond_stratified_site_imputation.do" 

// Combine estimates using Rubin's rules and collect them in separate files
do "$root/dofiles/data_prep/combine_imputed_estimates.do" 

********************************************************************************
