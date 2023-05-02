
********************************************************************************
* Global definitions
********************************************************************************

set type double
set varabbrev off
set matastrict on // may break stpm2 etc

adopath + "P:\Registeravdelingen\CIN-2021-SI\prod\programs"

********************************************************************************

global CINyear 2021
global cindata "P:\Registeravdelingen\CIN-2021-SI\data\cin"
global lifetable_standard "P:\Registeravdelingen\CIN-2021-SI\data\lt\CRN_lifetable_Norway_2021_national_general_population"
global lifetable "P:\Registeravdelingen\CIN-2021-SI\data\lt\CRN_lifetable_Norway_2021_national_general_population_calibrated"
global lt_path "P:\Registeravdelingen\CIN-2021-SI\data\lt"
global nen "P:\Registeravdelingen\CIN-2021-SI\data\nen"

global est_results "$root\est_results"
global matrices "$root\matrices"
global tempfiles "$root\tempfiles"

********************************************************************************

global censoring_date = d(31dec2021)
global max_followup = 15

global endyear = 2021
global firstyear = $endyear - 14

********************************************************************************

global pc_low = 5 //Lowest percentile for winsorizing age
global pc_high = 95 //Highest percentile for winsorizing age

global N_variants = 20 //Number of different FP survival models

global N_imputations = 10 // Number of imputed datasets
