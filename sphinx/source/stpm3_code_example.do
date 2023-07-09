clear all

use "https://pclambert.net/data/colon.dta", clear

//Drop missing stage
drop if stage == 0

//stset with maximum follow-up time of 15 years
stset surv_mm, failure(status = 1,2) scale(12) id(id) exit(time 180)

//Generate variables for attained age and year and merge to population
//mortality rates
gen _age = floor( min(age + _t, 99) )
gen _year = floor( yydx + _t )

merge m:1 _age _year sex using ///
    "https://pclambert.net/data/popmort.dta", keep(match master) nogen

//Fit flexible parametric model using stpm3
stpm3 i.sex i.stage @rcs(age, df(4) winsor(2 98) ), ///
    scale(lncumhazard) bhazard(rate) df(5) eform

************************************************************************
//Calculate survival measures by predicting marginal estimates from
//fitted model using standsurv.
************************************************************************

//Generate time variable used for making predictions
gen t = 1 in 1
replace t = 5 in 2
replace t = 10 in 3

gen t80 = 80 in 1

//Predict net-survival at 1, 5 and 10 years after diagnosis separately
// for all stages and both sexes
standsurv, over(sex stage) timevar(t) verbose ci frame(NS, replace)  ///
    atvar(NSm_s1 NSm_s2 NSm_s3 NSf_s1 NSf_s2 NSf_s3)

frame NS: list t NSf_s? NSm_s?

//Predict crude probabilities at 1, 5 and 10 years after diagnosis
/// separately for all stages and both sexes
standsurv , ///
    over(sex stage) crudeprob timevar(t) verbose ci                  ///
    frame(CP, replace)                                               ///
    atvar(CPm_st1 CPm_st2 CPm_st3 CPf_st1 CPf_st2 CPf_st3)           ///
    expsurv(using("https://pclambert.net/data/popmort.dta")          ///
    agediag(age) datediag(dx) pmage(_age) pmyear(_year)              ///
    pmother(sex) pmrate(rate) pmmaxage(99) pmmaxyear(2000))          ///
    stub(cancer other)

frame CP: list CP?_st?_cancer

//Predict expected remaining lifetime at 1, 5 and 10 years after
// diagnosis separately for all stages and both sexes
standsurv , ///
    over(sex stage) rmst timevar(t80) verbose ci                     ///
    frame(LE, replace)                                               ///
    atvar(LEm_st1 LEm_st2 LEm_st3 LEf_st1 LEf_st2 LEf_st3)           ///
    expsurv(using("https://pclambert.net/data/popmort.dta")          ///
    agediag(age) datediag(dx) pmage(_age) pmyear(_year)              ///
    pmother(sex) pmrate(rate) pmmaxage(99) pmmaxyear(2000)           ///
    expsurvvars(EXPm_st1 EXPm_st2 EXPm_st3 EXPf_st1 EXPf_st2 EXPf_st3))

frame LE: list LE?_st?
frame LE: list EXP?_st?

//Predict expected remaining lifetime for a median aged patient,
// sconditional on surviving 5 years
su age, detail
local medage = r(p50)
predict LEm_st1 LEm_st2 LEm_st3 LEf_st1 LEf_st2 LEf_st3,             ///
    rmst timevar(t80) verbose ci frame(LE5,replace)                  ///
    at1(sex 1 stage 1 age `medage')                                  ///
    at2(sex 1 stage 2 age `medage')                                  ///
    at3(sex 1 stage 3 age `medage')                                  ///
    at4(sex 2 stage 1 age `medage')                                  ///
    at5(sex 2 stage 2 age `medage')                                  ///
    at6(sex 2 stage 3 age `medage')                                  ///
    expsurv(using("https://pclambert.net/data/popmort.dta")          ///
    agediag(`medage') datediag(2000-01-01) pmage(_age) pmyear(_year) ///
    pmother(sex) pmrate(rate) pmmaxage(99) pmmaxyear(2000)           ///
    expvars(EXPm_st1 EXPm_st2 EXPm_st3 EXPf_st1 EXPf_st2 EXPf_st3))  ///
    odeoptions(reltol(1e-8) tstart(5))

frame LE5: list LE?_st?