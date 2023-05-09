
********************************************************************************
* Global definitions
********************************************************************************

set type double
set varabbrev off
set matastrict on 

adopath + "$root/ado/" /*stpm2cmcond , sysresources */

********************************************************************************

global StataExe R:\Stata17\StataMP-64.exe

global adjusted_lifetable "$root\lifetables\CRN_lifetable_Norway_2021_national_general_population_calibrated"

********************************************************************************

global seed 76984

global siteList "1(1)23"
global lastYear = 2021
global censoring_date = d(31dec$lastYear)
global stsetEnter = "d(1jan2017)"
global max_followup = 15
global firstYear = $lastYear - $max_followup - 1
global stpm2cmcondDiagyear = $lastYear - 10

********************************************************************************

global pc_low = 5 			//Lowest percentile for winsorizing age
global pc_high = 95 		//Highest percentile for winsorizing age
global N_imputations = 10 	//Number of imputed datasets
global N_variants = 20 		//Number of different FP survival models

/*

Short description of N_variants...

Defined in : $root\dofiles\estimation\definitions\models\model_variants.do

*/

********************************************************************************
