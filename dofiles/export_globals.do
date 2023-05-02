capt prog drop export_globals 
prog def export_globals

syntax , pattern(string) newfilename(string) 

capture confirm file "`newfilename'"

if ( _rc == 0 ) {
      
  error 602        
} 

local endmata end // trick

mata :

outputname = st_local("newfilename")

globals = st_dir("global", "macro", "`pattern'") 
 
cmds = ""

fh_out = fopen(outputname, "w")

for ( i=1; i <= length(globals); i++ ) {
    
    glname = globals[i]
    
    glval = st_global(glname)
    
    cmd = "global" + char(32) + glname + char(32) + glval 
    
    fwrite(fh_out, ( cmd + char(13) + char(10) ))
}

fclose(fh_out)

`endmata'

end 

exit // example follow

