capt prog drop rcsgen_wrap
prog def rcsgen_wrap
syntax [if], [var(varname numeric)] [newvar(string)] df(int) [p1(real 2)] [p2(real 98)] [splinename(string)]

	_pctile `var' `if', percentiles(`p1' `p2')
	local age_cutoff_low = r(r1)
	local age_cutoff_high = r(r2)

	gen `newvar' = `var'
	replace `newvar' = `age_cutoff_low' if `var' < `age_cutoff_low'
	replace `newvar' = `age_cutoff_high' if `var' > `age_cutoff_high'
	
	rcsgen `newvar' `if', df(`df') gen(`splinename') orthog

	
end

