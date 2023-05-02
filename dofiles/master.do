
********************************************************************************
* Masterfile for estimating flexible parametric relative survival models
* and predicting a range of different survival measures
* See www.kreftregisteret.no/globalassets/cancer-in-norway/2021/cin_report-special-issue.pdf
* for results
********************************************************************************

version 17
clear

********************************************************************************

global root "H:\CIN-SI"
				
include "$root\dofiles\global_definitions.do"

********************************************************************************

// Data-management
do "$root\prod\modelling\dofiles\data_prep_internal.do" 
do "$root\prod\modelling\dofiles\data_prep_external.do" 

// Run model-selection algorithm to estimate FP-models
do "$root\prod\modelling\dofiles\\estimation.do"  

// Predict net survival, crude probabilities and lifeyears lost by subgroups
// Code starts multiple parallell Stata-sessions to reduce computation time
do "$root\prod\modelling\dofiles\\parallell_sessions.do"

// Predict conditional crude probabilities using undocumented command stpm2cmcond 
do "$root\prod\modelling\dofiles\\predictions_cmcond_stratified_site_imputation.do" 

// Combine estimates using Rubin's rules and collect them in separate files
do "$root\prod\modelling\dofiles\\combine_imputed_estimates.do" 














