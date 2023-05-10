
args site_group

scalar at_site_groups = at_site_group_`site_group'

local defdir "$root/dofiles/prediction/stage_contrast_definitions"

********************************************************************************

if(`site_group' == 1) {
	
	local stage_group "1 2 3"
	
	include "`defdir'/define_at_site_group`site_group'.do" 
	
}

********************************************************************************

else if(`site_group' == 2) {
	
	local stage_group "4 5 6 7"

	include "`defdir'/define_at_site_group`site_group'.do" 
	
	ma list 
}

********************************************************************************

else if(`site_group' == 3) {
	
	local stage_group "9 10"

	include "`defdir'/define_at_site_group`site_group'.do" 
}

********************************************************************************

else if(`site_group' == 4) {
	
	local stage_group "8"

	include "`defdir'/define_at_site_group`site_group'.do" 
}

********************************************************************************

foreach sex of numlist 0/1 {
				
	local level = 0
	
	foreach stage of local stage_group {
		
		local ++level
		
		if(`stage_group' == 1){
			
			local lifetable "${lifetable_cm_stage}`level'"
		}
		
		else{
			
			local lifetable "$lifetable_cm_stage1"
		}
		
		forvalues k=0(1)5 {
			
			local j = `k'+5
	
			capt drop t cm* mark

			#delim;
			
			stpm2cmcond using "`lifetable'" , 
				at(`=scalar(at_site_groups)')
				mergeby(_year sex _age) 
				diagage(`age') 
				diagyear($stpm2cmcondDiagyear)
				sex(`sex') 
				tcond(`k') 
				stub(cm) 
				maxt(`j') 
				tgen(t)						
			;
			#delim cr
			
			gen crc5yr_sex`sex'_stage`stage'_cond`k' = cm_d if t == `j'
			gen cro5yr_sex`sex'_stage`stage'_cond`k' = cm_o if t == `j'
			
			gen mark = 1 if t == `j'
			sort mark
			replace crc5yr_sex`sex'_stage`stage'_cond`k' = crc5yr_sex`sex'_stage`stage'_cond`k'[1]	
			replace cro5yr_sex`sex'_stage`stage'_cond`k' = cro5yr_sex`sex'_stage`stage'_cond`k'[1]	
	}	
}

********************************************************************************
