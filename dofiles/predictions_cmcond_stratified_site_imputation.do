clear all

foreach site of numlist 1/23 {
	
	if `site' == 9 { 
		
		use "$lifetable", clear
		keep if loc_pca == 2
		drop loc_pca
		sort _year sex _age
		
		save "${lt_path}\lifetable_cm_lung", replace
		
		global lifetable_cm_stage1 "${lt_path}\lifetable_cm_lung"
		global lifetable_cm_stage2 "${lt_path}\lifetable_cm_lung"
		global lifetable_cm_stage3 "${lt_path}\lifetable_cm_lung"
	}
	
	else if `site' == 15 {
		
		use "$lifetable", clear
		keep if loc_pca == 1
		drop loc_pca
		sort _year sex _age
		save "${lt_path}\lifetable_cm_loc_pca", replace
		
		use "$lifetable", clear
		keep if loc_pca == 0
		drop loc_pca
		sort _year sex _age
		save "${lt_path}\lifetable_cm", replace
		
		global lifetable_cm_stage1 "${lt_path}\lifetable_cm_loc_pca"
		global lifetable_cm_stage2 "${lt_path}\lifetable_cm"
		global lifetable_cm_stage3 "${lt_path}\lifetable_cm"
	}
	
	else if !inlist(`site',9,15) {
		
		use "$lifetable", clear
		keep if loc_pca == 0
		drop loc_pca
		sort _year sex _age
		save "${lt_path}\lifetable_cm", replace

		global lifetable_cm_stage1 "${lt_path}\lifetable_cm"
		global lifetable_cm_stage2 "${lt_path}\lifetable_cm"
		global lifetable_cm_stage3 "${lt_path}\lifetable_cm"
	}	
		
	forvalues i=1(1)$N_imputations {

		use "$root\est_results\models_converged", clear

		split modelname, p("_") gen(m)
		replace m2 = usubinstr(m2,"site","",.) 
		replace m3 = usubinstr(m3,"variant","",.) 

		destring m2 m3, replace
		rename (m2 m3) (site variant)

		keep if imputation == `i'

		bysort site (variant): keep if _n == 1

		keep if site == `site'

		tempfile sterfile
		tempvar fh
		gen `fh' = filewrite("`sterfile'", sterfilename) 
		est use "`sterfile'"	
		est replay

		use "$root\dta\analysisfile_imputed.dta", clear 

		mi extract `i', clear

		keep if site23 == `site'
		
		su strata
		
		local strata = `r(min)'

		keep if _st == 1

		keep if _t0 == 0

		su age, detail
		local age = `r(p50)'
		di `age'


		adopath ++ "$root\programs" //Path to stpm2cmcond ado-file

		include "$root\dofiles\global_knotlists.do"

		forvalues df = 2(1)4 {
			preserve
			use "$root\matrices\Ryear_period_df`df'_strata`strata'", clear				
			mkmat c?, matrix(Ryear`df')
			restore
		}

		rcsgen, scalar(`age') gen(c) knots(${knotslist_period_df4_strata`strata'}) rmatrix(Ryear4)
		rcsgen, scalar(`age') gen(d) knots(${knotslist_period_df3_strata`strata'}) rmatrix(Ryear3)
		rcsgen, scalar(`age') gen(e) knots(${knotslist_period_df2_strata`strata'}) rmatrix(Ryear2)


		if inlist(`site',1,2,3,4,5,6,7,8,9,10,13,14,15,16,17,18,20) {

				local at rcs4_age1 \`=c1' rcs4_age2 \`=c2' rcs4_age3 \`=c3' rcs4_age4 \`=c4' rcs3_age1 \`=d1' rcs3_age2 \`=d2' rcs3_age3 \`=d3' rcs2_age1 \`=e1' rcs2_age2 \`=e2'
				
				local at1 stage1_2_rcs4_age1 0 stage1_2_rcs4_age2 0 stage1_2_rcs4_age3 0 stage1_2_rcs4_age4 0 stage1_3_rcs4_age1 0 stage1_3_rcs4_age2 0 stage1_3_rcs4_age3 0 stage1_3_rcs4_age4 0 ///
				stage1_2_rcs3_age1 0 stage1_2_rcs3_age2 0 stage1_2_rcs3_age3 0 stage1_3_rcs3_age1 0 stage1_3_rcs3_age2 0 stage1_3_rcs3_age3 0 stage1_2_rcs2_age1 0 stage1_2_rcs2_age2 0 stage1_3_rcs2_age1 0 stage1_3_rcs2_age2 0
				
				local at2 stage1_2_rcs4_age1 \`=c1' stage1_2_rcs4_age2 \`=c2' stage1_2_rcs4_age3 \`=c3' stage1_2_rcs4_age4 \`=c4' stage1_3_rcs4_age1 0 stage1_3_rcs4_age2 0 stage1_3_rcs4_age3 0 stage1_3_rcs4_age4 0 ///
				stage1_2_rcs3_age1 \`=d1' stage1_2_rcs3_age2 \`=d2' stage1_2_rcs3_age3 \`=d3' stage1_3_rcs3_age1 0 stage1_3_rcs3_age2 0 stage1_3_rcs3_age3 0 stage1_2_rcs2_age1 \`=e1' stage1_2_rcs2_age2 \`=e2' stage1_3_rcs2_age1 0 stage1_3_rcs2_age2 0
				
				local at3 stage1_2_rcs4_age1 0 stage1_2_rcs4_age2 0 stage1_2_rcs4_age3 0 stage1_2_rcs4_age4 0 stage1_3_rcs4_age1 \`=c1' stage1_3_rcs4_age2 \`=c2' stage1_3_rcs4_age3 \`=c3' stage1_3_rcs4_age4 \`=c4' ///
				stage1_2_rcs3_age1 0 stage1_2_rcs3_age2 0 stage1_2_rcs3_age3 0 stage1_3_rcs3_age1 \`=d1' stage1_3_rcs3_age2 \`=d2' stage1_3_rcs3_age3 \`=d3' stage1_2_rcs2_age1 0 stage1_2_rcs2_age2 0 stage1_3_rcs2_age1 \`=e1' stage1_3_rcs2_age2 \`=e2'

			foreach sex of numlist 0/1 {
				
				foreach stage of numlist 1/3 {
					
					forvalues k=0(1)5 {
						
						local j = `k'+5
				
						if `stage' == 1 {
							capt drop t
							capt drop cm*
							capt drop merk
						
							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at' stage1_2 0 stage1_3 0 `at1') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]
						}
						
						else if `stage' == 2 {
							capt drop t
							capt drop cm*
							capt drop merk
							
							stpm2cmcond using "$lifetable_cm_stage2", at(sex `sex' `at' stage1_2 1 stage1_3 0 `at2') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]

						}
						
						else if `stage' == 3 {
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage3", at(sex `sex' `at' stage1_2 0 stage1_3 1 `at3') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]


						}
					}
				}
			}

		}

		else if inlist(`site',11,12) {

			local at rcs4_age1 \`=c1' rcs4_age2 \`=c2' rcs4_age3 \`=c3' rcs4_age4 \`=c4' rcs3_age1 \`=d1' rcs3_age2 \`=d2' rcs3_age3 \`=d3' rcs2_age1 \`=e1' rcs2_age2 \`=e2' 
			
			local at1 stage2_2_rcs4_age1 0 stage2_2_rcs4_age2 0 stage2_2_rcs4_age3 0 stage2_2_rcs4_age4 0 stage2_3_rcs4_age1 0 stage2_3_rcs4_age2 0 stage2_3_rcs4_age3 0 stage2_3_rcs4_age4 0 ///
			stage2_4_rcs4_age1 0 stage2_4_rcs4_age2 0 stage2_4_rcs4_age3 0 stage2_4_rcs4_age4 0 stage2_2_rcs3_age1 0 stage2_2_rcs3_age2 0 stage2_2_rcs3_age3 0 stage2_3_rcs3_age1 0 stage2_3_rcs3_age2 0 ///
			stage2_3_rcs3_age3 0 stage2_4_rcs3_age1 0 stage2_4_rcs3_age2 0 stage2_4_rcs3_age3 0 stage2_2_rcs2_age1 0 stage2_2_rcs2_age2 0 stage2_3_rcs2_age1 0 stage2_3_rcs2_age2 0 stage2_4_rcs2_age1 0 stage2_4_rcs2_age2 0
			
			local at2 stage2_2_rcs4_age1 \`=c1' stage2_2_rcs4_age2 \`=c2' stage2_2_rcs4_age3 \`=c3' stage2_2_rcs4_age4 \`=c4' stage2_3_rcs4_age1 0 stage2_3_rcs4_age2 0 stage2_3_rcs4_age3 0 stage2_3_rcs4_age4 0 ///
			stage2_4_rcs4_age1 0 stage2_4_rcs4_age2 0 stage2_4_rcs4_age3 0 stage2_4_rcs4_age4 0 stage2_2_rcs3_age1 \`=d1' stage2_2_rcs3_age2 \`=d2' stage2_2_rcs3_age3 \`=d3' stage2_3_rcs3_age1 0 ///
			stage2_3_rcs3_age2 0 stage2_3_rcs3_age3 0 stage2_4_rcs3_age1 0 stage2_4_rcs3_age2 0 stage2_4_rcs3_age3 0 stage2_2_rcs2_age1 \`=e1' stage2_2_rcs2_age2 \`=e2' stage2_3_rcs2_age1 0 stage2_3_rcs2_age2 0 stage2_4_rcs2_age1 0 ///
			stage2_4_rcs2_age2 0 
			
			
			local at3 stage2_2_rcs4_age1 0 stage2_2_rcs4_age2 0 stage2_2_rcs4_age3 0 stage2_2_rcs4_age4 0 stage2_3_rcs4_age1 \`=c1' stage2_3_rcs4_age2 \`=c2' stage2_3_rcs4_age3 \`=c3' stage2_3_rcs4_age4 \`=c4' ///
			stage2_4_rcs4_age1 0 stage2_4_rcs4_age2 0 stage2_4_rcs4_age3 0 stage2_4_rcs4_age4 0 stage2_2_rcs3_age1 0 stage2_2_rcs3_age2 0 stage2_2_rcs3_age3 0 stage2_3_rcs3_age1 \`=d1' stage2_3_rcs3_age2 \`=d2' stage2_3_rcs3_age3 \`=d3' ///
			stage2_4_rcs3_age1 0 stage2_4_rcs3_age2 0 stage2_4_rcs3_age3 0 stage2_2_rcs2_age1 0 stage2_2_rcs2_age2 0 stage2_3_rcs2_age1 \`=e1' stage2_3_rcs2_age2 \`=e2'  stage2_4_rcs2_age1 0 stage2_4_rcs2_age2 0
			
			
			local at4 stage2_2_rcs4_age1 0 stage2_2_rcs4_age2 0 stage2_2_rcs4_age3 0 stage2_2_rcs4_age4 0 stage2_3_rcs4_age1 0 stage2_3_rcs4_age2 0 stage2_3_rcs4_age3 0 stage2_3_rcs4_age4 0 ///
			stage2_4_rcs4_age1 \`=c1' stage2_4_rcs4_age2 \`=c2' stage2_4_rcs4_age3 \`=c3' stage2_4_rcs4_age4 \`=c4' stage2_2_rcs3_age1 0 stage2_2_rcs3_age2 0 stage2_2_rcs3_age3 0 stage2_3_rcs3_age1 0 stage2_3_rcs3_age2 0 ///
			stage2_3_rcs3_age3 0 stage2_4_rcs3_age1 \`=d1' stage2_4_rcs3_age2 \`=d2' stage2_4_rcs3_age3 \`=d3' stage2_2_rcs2_age1 0 stage2_2_rcs2_age2 0 stage2_3_rcs2_age1 0 stage2_3_rcs2_age2 0  stage2_4_rcs2_age1 \`=e1' stage2_4_rcs2_age2 \`=e2'
				
			foreach sex of numlist 0 {
				
				foreach stage of numlist 4/7 {
					
					forvalues k=0(1)5 {
						
						local j = `k'+5
				
						if `stage' == 4 {
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at' stage2_2 0 stage2_3 0 stage2_4 0 `at1') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]

						}

						else if `stage' == 5 {
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at' stage2_2 1 stage2_3 0 stage2_4 0 `at2') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]


						}
						
						else if `stage' == 6 {
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at' stage2_2 0 stage2_3 1 stage2_4 0 `at3') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]


						}
						
						else if `stage' == 7 {
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at' stage2_2 0 stage2_3 0 stage2_4 1 `at4') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]


						}
					}
				}
			}

		}

		else if inlist(`site',19) {

			local at rcs4_age1 \`=c1' rcs4_age2 \`=c2' rcs4_age3 \`=c3' rcs4_age4 \`=c4' rcs3_age1 \`=d1' rcs3_age2 \`=d2' rcs3_age3 \`=d3' rcs2_age1 \`=e1' rcs2_age2 \`=e2'
			local at1 stage3_2_rcs4_age1 0 stage3_2_rcs4_age2 0 stage3_2_rcs4_age3 0 stage3_2_rcs4_age4 0 stage3_2_rcs3_age1 0 stage3_2_rcs3_age2 0 stage3_2_rcs3_age3 0 stage3_2_rcs2_age1 0 stage3_2_rcs2_age2 0
			local at2 stage3_2_rcs4_age1 \`=c1' stage3_2_rcs4_age2 \`=c2' stage3_2_rcs4_age3 \`=c3' stage3_2_rcs4_age4 \`=c4' stage3_2_rcs3_age1 \`=d1' stage3_2_rcs3_age2 \`=d2' stage3_2_rcs3_age3 \`=d3' stage3_2_rcs2_age1 \`=e1' ///
			stage3_2_rcs2_age2 \`=e2'

			foreach sex of numlist 0/1 {
				
				foreach stage of numlist 9/10 {
					
					forvalues k=0(1)5 {
						
						local j = `k'+5
				
						if `stage' == 9 {
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at' stage3_2 0  `at1') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]

						}

						else if `stage' == 10 {
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at' stage3_2 1 `at2') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]

						}
						
					}
				}
			}

		}

		else if inlist(`site',21,22,23) {

			local at rcs4_age1 \`=c1' rcs4_age2 \`=c2' rcs4_age3 \`=c3' rcs4_age4 \`=c4' rcs3_age1 \`=d1' rcs3_age2 \`=d2' rcs3_age3 \`=d3' rcs2_age1 \`=e1' rcs2_age2 \`=e2'

			foreach sex of numlist 0/1 {
				
				foreach stage of numlist 8 {
					
					forvalues k=0(1)5 {
						
						local j = `k'+5
				
							capt drop t
							capt drop cm*
							capt drop merk

							stpm2cmcond using "$lifetable_cm_stage1", at(sex `sex' `at') mergeby(_year sex _age) diagage(`age') diagyear(2011) sex(`sex') ///
							tcond(`k') stub(cm) maxt(`j') tgen(t)
							
							gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
							gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
							gen merk = 1 if t == `j'
							sort merk
							replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]
							replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]
			
					}
				}
			}

		}

		keep if _n == 1
		keep crc* cro*
		gen site23 = `site'
		gen imputation = `i'
		order site23 imputation, first

		tempfile f`site'`i'
		save `f`site'`i''
	}	
} 

clear

foreach site of numlist 1/23 {

	forvalues i=1(1)$N_imputations {

		append using `f`site'`i''
	}
}

save "$root\tempfiles\predictions_stpm2cmcond", replace		
