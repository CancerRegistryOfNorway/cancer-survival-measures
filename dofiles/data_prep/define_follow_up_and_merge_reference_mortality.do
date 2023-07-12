
********************************************************************************

stset time , 				///
	fail(death) 			///
	origin(time diag_date) 	///
	enter(time $stsetEnter) /// 
	exit(time exittime) 	///
	scale(365.25) 			///
	id(SID_surv)                            

keep if ( _st == 1 )

//Defining variable needed to identify localised prostate cancer
//and lung cancer as lifetable is stratified by these groups

gen byte adjusted_lifetable = 					///
	cond(( site23 == 15 ) & ( stage == 1 ) , 1, /// 1 = Prostate
	cond(( site23 == 9 ), 2, 					/// 2 = Lung
	0))											// 	0 = Other cancer sites

//Merging on background rates for all cause mortality
//Limiting to 99 years of age

gen long _age = min(int(age + _t), 99)
gen long _year = year(DIAGNOSEDATO + _t*365.25)

merge m:1 _year sex _age adjusted_lifetable using "$adjusted_lifetable" , ///
	assert(match using) keepusing(prob) keep(match) nogen

gen double rate = -ln(prob)

********************************************************************************