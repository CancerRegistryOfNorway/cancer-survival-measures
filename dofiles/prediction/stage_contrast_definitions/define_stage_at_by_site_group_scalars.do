
********************************************************************************

#delim;

	mat def stages_site_group_1 = 0, 0 \ 
								  1, 0 \ 
								  0, 1 
	;
								  
	scalar at_site_group_1 =
	trim(itrim(	  
	"
		sex \`sex' \`at' 										
		stage1_2 \`=stages_site_group_1[\`level', 1]' 			
		stage1_3 \`=stages_site_group_1[\`level', 2]' 						
		\`at\`level''
	"
	))
	;

	mat def stages_site_group_2 = 0, 0, 0 \ 
								  1, 0, 0 \ 
								  0, 1, 0 \ 
								  0, 0, 1
	;

	scalar at_site_group_2 =
	trim(itrim(
	"
		sex \`sex' \`at' 										
		stage2_2 \`=stages_site_group_2[\`level', 1]' 			
		stage2_3 \`=stages_site_group_2[\`level', 2]' 			
		stage2_4 \`=stages_site_group_2[\`level', 3]' 			
		\`at\`level''
	"
	))
	;				  

	mat def stages_site_group_3 = 0 \ 1 ;			  
															  
	scalar at_site_group_3 = 
	trim(itrim(			  
	"
		sex \`sex' \`at'
		stage3_2 \`=stages_site_group_3[\`level', 1]' 
		\`at\`level''
	"
	))						  	
	;

	scalar at_site_group_4 = trim(itrim("sex \`sex' \`at'")) ;

#delim cr

********************************************************************************
