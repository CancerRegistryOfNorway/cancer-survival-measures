
********************************************************************************

version 17

which sysresources
findfile sysresources.jar  

cd "$root/results/log"

local dofile "$root/dofiles/prediction/predict.do"

confirm file $StataExe
confirm file "`dofile'"

assert $N_imputations > 0

local args \`site' \`i' 

qui foreach site of numlist $siteList {

	forvalues i=1(1)$N_imputations {
		
		sleep `=10*1000'
	
		while 1 {
			
			sysresources 

			//Start new session if enough resources
			
			if ( r(pctfreemem) < 25 | r(cpuload) > 0.75 ) {
				
				sleep `=30*1000' 			
				continue 
			}
			
			else {
					
				winexec $StataExe /e do `dofile' `args' 
				
				noi di "started site `site' and imputation `i': " c(current_time)
				
				continue, break
			}
		}
	}
}

********************************************************************************
