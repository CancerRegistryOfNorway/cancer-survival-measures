args site i  // site23 i=imputation 1...$N_imputations

assert inrange(`site', 1, 23)
assert inrange(`i', 1, 10)

********************************************************************************

qui java : ///
	Macro.setLocal("ProcessId", Long.toString(ProcessHandle.current().pid()))
	
local EOL = char(13) + char(10)
local TS = string(now(),"%tcCCYY-NN-DD_HH:MM:SS.sss")

capture di filewrite("file.log", ///
	"site `site' `ProcessId' start: `TS' `EOL'" , 2)

capt mkdir log	
	
log using ./log/site_`site'_ProcessId_`ProcessId'_ra.log , ///
	text replace name(_`ProcessId')

********************************************************************************

//global root "H:\tamy\My Documents\cancer-survival-measures"
global root "H:/cancer-survival-measures/"
include "$root\dofiles\settings\global_definitions.do"
include "$root\dofiles\estimation\definitions\models\global_knotlists.do"

********************************************************************************

use "$root\results\estimation\models_converged", clear

split modelname, p("_") gen(m)
replace m2 = usubinstr(m2,"site","",.) 
replace m3 = usubinstr(m3,"variant","",.) 

destring m2 m3, replace
rename (m2 m3) (site variant)

tempfile sterfile
tempvar fh
gen `fh' = filewrite("`sterfile'", sterfilename) ///
	if site == `site'  & imputation == `i'
est use "`sterfile'"	
est replay

su variant if site == `site' & imputation == `i'
local variant `r(mean)'
	
use "$root\data\datafile.dta", clear 

keep if site23 == `site'

mi extract `i', clear

//Generate predictions using standsurv
include "$root\dofiles\prediction\standsurv_predictions.do" 

keep if !mi(temptime)

keep site23 temptime t80 netsurv*  crude* obslifeexp* explifeexp* 	
				
gen imputation = `i'

save "$root\results\prediction\tempfiles\predictions_site`site'_imputation`i'", replace		

********************************************************************************

local TS = string(now(),"%tcCCYY-NN-DD_HH:MM:SS.sss")

local site : di %02.0f `site'

capture di filewrite("file.log", ///
	"site `site' `ProcessId'   end: `TS' , 2)

log close _`ProcessId'
clear all
exit
