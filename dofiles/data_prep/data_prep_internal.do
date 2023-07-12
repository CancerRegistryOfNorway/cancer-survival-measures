clear all

********************************************************************************
use "P:\Registeravdelingen\CIN-2021-SI\data\cin\CIN_surv_$lastYear.dta", clear

drop if ( site23 == 99 ) // NB: need site23 == 99 if analysing "All sites"

replace stage = 8 if stage!= 8 & inrange(site23,21,23)

replace stage = . if stage == 8 & !inrange(site23,21,23)

//Removing ovary cancer for men
drop if ( sex == 1 ) & inlist(site23, 11, 14) 

//Removing NEN for pancreas
gen Morfologi = real(substr(MORFOLOGI_ICDO3,1,5))
merge m:1 Morfologi using "P:\Registeravdelingen\CIN-2021-SI\data\nen\NEN_codes", keep(match master) keepusing(Aggresivitet)

gen nen = _merge == 3 & site23 == 8
replace nen = 0 if inlist(Morfologi,80103, 81401,81403,85103,80203,80213) & site23 == 8

drop if nen == 1

capt drop _merge

//Removing patients aged 90+ at diagnosis
drop if age >= 90

gen site = site23

capt gen SID_surv = SYKDOMSTILFELLENR

//Adding follow-up time and event indicator

replace STATUS = "B" if ( STATUSDATO > $censoring_date )  
replace STATUSDATO = $censoring_date if ( STATUSDATO > $censoring_date )

clonevar diag_date = DIAGNOSEDATO  
clonevar time = STATUSDATO 

gen byte death = ( STATUS == "D" ) 

gen exittime = diag_date + $max_followup*365.25

//Add age group variable 
gen agr_temp1 = irecode(age,49,59,69,79,200) + 1
gen agr_temp2 = irecode(age,34,44,54,69,200) + 1
gen agr_temp3 = irecode(age,24,34,44,54,200) + 1
gen agr_temp4 = irecode(age,19,39,59,79,200) + 1
gen agr_temp5 = irecode(age,29,44,59,74,200) + 1

gen agr = agr_temp5 if inlist(site23,20,23)
replace agr = agr_temp4 if inlist(site23,19,21,22)
replace agr = agr_temp3 if inlist(site23,16)
replace agr = agr_temp2 if inlist(site23,12)
replace agr = agr_temp1 if mi(agr)

drop agr_temp?