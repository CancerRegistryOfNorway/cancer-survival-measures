
********************************************************************************
* Global definitions
********************************************************************************

set type double
set varabbrev off
set matastrict on 

adopath + "$root/ado/" /*stpm2cmcond*/

********************************************************************************

global adjusted_lifetable "$root\lifetables\CRN_lifetable_Norway_2021_national_general_population_calibrated"

global est_results "$root\est_results"
global matrices "$root\matrices"
global tempfiles "$root\tempfiles"

********************************************************************************

global lastYear = 2021
global censoring_date = d(31dec$lastYear)
global max_followup = 15
global firstYear = $lastYear - $max_followup - 1

********************************************************************************

global pc_low = 5 			//Lowest percentile for winsorizing age
global pc_high = 95 		//Highest percentile for winsorizing age
global N_imputations = 10 	//Number of imputed datasets
global N_variants = 20 		//Number of different FP survival models -  MER BESKRIVELSE. Hva betyr? N>20? 

********************************************************************************
