
args site

local lifetable_vars _year sex _age adjusted_lifetable

if( `site' == 9 ){ 
	
	use if ( adjusted_lifetable == 2 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root\lifetables\lifetable_cm_lung", replace	
	
	global lifetable_cm_stage1 "$root\lifetables\lifetable_cm_lung"
	global lifetable_cm_stage2 "$root\lifetables\lifetable_cm_lung"
	global lifetable_cm_stage3 "$root\lifetables\lifetable_cm_lung"	
}

else if( `site' == 15 ){
	
	use if ( adjusted_lifetable == 1 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root\lifetables\lifetable_cm_loc_pca", replace
	
	use if ( adjusted_lifetable == 0 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root\lifetables\lifetable_cm", replace
	
	global lifetable_cm_stage1 "$root\lifetables\lifetable_cm_loc_pca"
	global lifetable_cm_stage2 "$root\lifetables\lifetable_cm"
	global lifetable_cm_stage3 "$root\lifetables\lifetable_cm"	
}

else{
	
	use if ( adjusted_lifetable == 0 ) using "$adjusted_lifetable", clear
	sort `lifetable_vars'
	drop adjusted_lifetable
	save "$root\lifetables\lifetable_cm", replace
	
	global lifetable_cm_stage1 "$root\lifetables\lifetable_cm"
	global lifetable_cm_stage2 "$root\lifetables\lifetable_cm"
	global lifetable_cm_stage3 "$root\lifetables\lifetable_cm"	
}	