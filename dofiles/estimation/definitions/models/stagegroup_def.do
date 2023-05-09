local IF if site23 == \`site', scale(hazard) bhazard(rate) iterate(50) 

if "`fupdef'" == "cohort" {
	local time_period time_period
	}

else if "`fupdef'" == "period" {
	local time_period 
}

local stageGroup1 1/10 13/18 20
local stageGroup2 11 12
local stageGroup3 19
local stageGroup4 21/23

mata: st_local("N_stageGroup", ///
	strofreal(rows(st_dir("local", "macro", "stageGroup?" ))))

local stageVariant1 stage1_2 stage1_3
local stageVariant2 stage2_2 stage2_3 stage2_4
local stageVariant3 stage3_2
local stageVariant4 "" // Model without stage