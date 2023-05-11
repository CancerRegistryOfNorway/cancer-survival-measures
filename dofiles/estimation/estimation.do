
********************************************************************************
// Model estimation algorithm
********************************************************************************

//Defining frame to store information from model estimation
capt frame drop modelres
frame create modelres ///
	str100 modelname str1000 cmdline convergence strL sterfilename imputation

//Specifying stage-groups
include "$root/dofiles/estimation/definitions/models/stagegroup_def.do" 

//Specifying different interaction terms
include "$root/dofiles/estimation/definitions/models/interaction_variants.do" 

local n_cat : word count \`stageVariant\`group''
local last_stage : word `n_cat' of \`stageVariant\`group''

//Specify model variants
include "$root/dofiles/estimation/definitions/models/model_variants.do" 

mata: st_local("N_variant", ///
	strofreal(rows(st_dir("local", "macro", "variant*" ))))
	
global N_variants = `N_variant'

if ( "$siteList" != "1(1)23" ) local N_stageGroup = 1	

foreach group of numlist 1(1)`N_stageGroup' { 
	
	if ( "$siteList" != "1(1)23" ) {
	
		local temp = 0
		
		foreach tempGroup of numlist 1 2 3 4 {
			
			foreach tempSite of numlist `stageGroup`tempGroup'' {
				
				if ( `tempSite' == $siteList ) {
					
					local temp = `tempSite'
					local group = `tempGroup'
					local stageGroup`group' `temp'
				} 
			}
		}
	}
	
	foreach site of numlist `stageGroup`group'' {
						
		if inrange(`site',11,16) {	
			local sex "" 
		}
		else {
			local sex sex
		}
		
		forvalues i=1(1)$N_imputations {
			
			use "$root/data/datafile.dta", clear 

			keep if site23 == `site'

			mi extract `i', clear
									
			foreach n of numlist 1(1)`N_variant' {
				
				eret clear
				est clear
				
				local modelname m_site`site'_variant`n'
				
				mata: mata clear 
				
				capt noisily `variant`n''
		
				if ( _rc == 0 ) & e(converged) == 1 {
					
					tempfile ster
					est save `ster'
									
					frame post modelres ("`modelname'") ("`e(cmdline)'") 	///
						(`e(converged)') (fileread("`ster'")) (`i')			
				}
				
				else { 

					frame post modelres ("`modelname'") ("No convergence") 	///
						(0) (" ") (`i')					
				}
			}
		}
	}
}

frame modelres: save "$root/results/estimation/models_all.dta", replace 

use "$root/results/estimation/models_all.dta", clear

split modelname, p("_") gen(m)
replace m2 = usubinstr(m2,"site","",.) 
replace m3 = usubinstr(m3,"variant","",.) 

destring m2 m3, replace
rename (m2 m3) (site variant)

keep if convergence == 1

//Chosen model must converge on all imputed datasets
bysort site variant (imputation): egen totvariant = total(convergence)

keep if totvariant == $N_imputations

bysort site imputation (variant): keep if _n == 1

drop m? site variant totvariant

save "$root/results/estimation/models_converged.dta", replace  

********************************************************************************
