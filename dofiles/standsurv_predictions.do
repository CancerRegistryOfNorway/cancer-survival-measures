capt drop temptime
capt drop t80

keep if _t0 == 0

range temptime 0 15 151
gen t80 = 80 in 1

range tt 0 80 801

su age, detail
local age `r(p50)'

su strata
local strata `r(mean)'

forvalues y = 0(1)10 {
	gen t`y' = `y' in 1
}

if inlist(`variant',1,2,3,4,5,12,13,18) {
	local df = 4
}
else if inlist(`variant',6,7,8,9,10,11,14,15,16,17,19,20,21) {
	local df = 3
}
else if `variant' == 22 {
	local df = 2
}

preserve
use "$root\matrices\Ryear_period_df`df'_strata`strata'", clear				
mkmat c?, matrix(Ryear)
restore
rcsgen, scalar(`age') gen(c) knots(${knotslist_period_df`df'_strata`strata'}) rmatrix(Ryear)

if `df' == 4 {
	local at rcs4_age1 \`=c1' rcs4_age2 \`=c2' rcs4_age3 \`=c3' rcs4_age4 \`=c4'
}
if `df' == 3 {
	local at rcs3_age1 \`=c1' rcs3_age2 \`=c2' rcs3_age3 \`=c3' 
}
if `df' == 2 {
	local at rcs2_age1 \`=c1' rcs2_age2 \`=c2'  
}

gen age_median = `age'

gen merk = 1 if !mi(PERSONLOEPENR)

//Net survival for all patients combined
standsurv if merk == 1, at1(.) timevar(temptime) verbose	atvars(netsurv_all) /*se*/

//Crude probabilities for all patients combined
capt noisily standsurv if merk == 1, at1(.) crudeprob timevar(temptime) verbose atvars(crude_all) /*se*/ expsurv(using(${lifetable}) agediag(age) datediag(diag_date) pmage(_age) pmyear(_year) pmother(sex loc_pca) pmrate(rate_lt) pmmaxage(99) ///
pmmaxyear(${endyear}) )

//Expected remaining lifetime for all patients combined
standsurv if merk == 1, at1(.) rmst timevar(t80) atvar(obslifeexp_all) /*se*/ expsurv(using(${lifetable}) agediag(age) datediag(diag_date) pmage(_age) pmyear(_year) pmother(sex loc_pca) pmrate(rate_lt) pmmaxage(99) ///
pmmaxyear(${endyear}) expsurvvars(explifeexp_all))

levelsof sex, local(levels_sex)
levelsof stage, local(levels_stage)
levelsof agr, local(levels_agr)

foreach sex of local levels_sex {
		
		//Net survival stratified by sex
		standsurv if sex == `sex', at1(.) timevar(temptime) verbose atvars(netsurv_sex`sex') /*se*/		
}


//Net survival, crude probabilities and expected remaining lifetime by sex, age group and stage

foreach sex of local levels_sex {
	
	foreach stage of local levels_stage {
		
			foreach agr of local levels_agr {
				
		
				standsurv if sex == `sex' & stage == `stage' & agr == `agr', at1(.) timevar(temptime) verbose atvars(netsurv_sex`sex'_stage`stage'_agr`agr') /*se*/
				
				capt noisily standsurv if sex == `sex' & stage == `stage' & agr == `agr', at1(.) crudeprob timevar(temptime) verbose atvars(crude_sex`sex'_stage`stage'_agr`agr') /*se*/ ///
				expsurv(using(${lifetable}) agediag(age) datediag(diag_date) pmage(_age) pmyear(_year) pmother(sex loc_pca) pmrate(rate_lt) pmmaxage(99) pmmaxyear(${endyear}) )
				
				capt noisily standsurv if sex == `sex' & stage == `stage' & agr == `agr', at1(.) rmst timevar(t80) atvar(obslifeexp_sex`sex'_stage`stage'_agr`agr') /*se*/ ///
				expsurv(using(${lifetable}) agediag(age) datediag(diag_date) pmage(_age) pmyear(_year) pmother(sex loc_pca) pmrate(rate_lt) pmmaxage(99) pmmaxyear(${endyear}) expsurvvars(explifeexp_sex`sex'_stage`stage'_agr`agr')) 
		
			}
	}
}



//Conditional expected remaining lifetime by sex ang stage and number of
//years survived since diagnosis (0-5)

foreach sex of local levels_sex {
	
	foreach stage of local levels_stage {
		
		capt drop s80
		capt drop s80exp
		
		capt standsurv if sex == `sex' & stage == `stage' & inrange(age,`=`age'-2',`=`age'+2'), surv at1(.) timevar(tt) atvar(s80) /*ci*/ ///
		expsurv(using(${lifetable}) agediag(age_median) datediag(diag_date) pmage(_age) pmyear(_year) pmother(sex loc_pca) pmrate(rate_lt) pmmaxage(99) pmmaxyear(${endyear}) expsurvvars(s80exp) ) 
		
		forvalues k = 0(1)5 {
			
			capt drop s80c
			capt drop s80expc

			capt integ s80 tt
			capt summ s80 if tt == `k'
			capt gen s80c = s80/`r(mean)'
			capt integ s80c tt if tt>= `k'
			capt gen obslifeexp_sex`sex'_stage`stage'_cond`k' = r(integral) in 1

			capt integ s80exp tt
			capt summ s80exp if tt == `k'
			capt gen s80expc = s80exp/`r(mean)'
			capt integ s80expc tt if tt>= `k'
			capt gen explifeexp_sex`sex'_stage`stage'_cond`k' = r(integral) in 1
			
		}

	}
	
}



