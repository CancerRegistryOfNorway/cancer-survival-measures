
args site

local lifetable_vars _year sex _age adjusted_lifetable

if( `site' == 9 ){ 
	
	use if ( adjusted_lifetable == 2 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root/data/lifetables/lifetable_cm_lung.dta", replace	
	
	global lifetable_cm_stage1 "$root/data/lifetables/lifetable_cm_lung.dta"
	global lifetable_cm_stage2 "$root/data/lifetables/lifetable_cm_lung.dta"
	global lifetable_cm_stage3 "$root/data/lifetables/lifetable_cm_lung.dta"	
}

else if( `site' == 15 ){
	
	use if ( adjusted_lifetable == 1 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root/data/lifetables/lifetable_cm_loc_pca.dta", replace
	
	use if ( adjusted_lifetable == 0 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root/data/lifetables/lifetable_cm.dta", replace
	
	global lifetable_cm_stage1 "$root/data/lifetables/lifetable_cm_loc_pca.dta"
	global lifetable_cm_stage2 "$root/data/lifetables/lifetable_cm.dta"
	global lifetable_cm_stage3 "$root/data/lifetables/lifetable_cm.dta"	
}

else{
	
	use if ( adjusted_lifetable == 0 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root/data/lifetables/lifetable_cm.dta", replace
	
	global lifetable_cm_stage1 "$root/data/lifetables/lifetable_cm.dta"
	global lifetable_cm_stage2 "$root/data/lifetables/lifetable_cm.dta"
	global lifetable_cm_stage3 "$root/data/lifetables/lifetable_cm.dta"	
}	