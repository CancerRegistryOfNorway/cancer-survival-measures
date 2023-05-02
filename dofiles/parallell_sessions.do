version 17

adopath + "E:\users\BAA\CIN2021-SI\" // sysresources 
which sysresources
findfile sysresources.jar  

global root "H:\CIN-SI"
include "$root\dofiles\global_definitions.do"


cd "$root\log"

local dofiles "$root\dofiles\"
 
local exefile R:\Stata17\StataMP-64.exe 
local dofile `dofiles'\predict.do

confirm file `exefile'
confirm file `dofile'

assert $N_imputations > 0

local args \`site' \`i' 

qui foreach site of numlist 1/23 {
	
	forvalues i=1(1)$N_imputations {
		
		sleep `=10*1000'
		
	
		while 1 {
			
			sysresources 

			if ( r(pctfreemem) < 25 | r(cpuload) > 0.75 ) {
				
				sleep `=30*1000' 			
				continue 
			}
			
			else {
					
				winexec `exefile' /e do `dofile' `args' 
				
				noi di "started site `site' and imputation `i': " c(current_time)
				
				continue, break
			}
		}
	}
}

