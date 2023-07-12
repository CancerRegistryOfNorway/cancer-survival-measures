
*! sysresources
*! v 0.0.1
*! 11feb2016

// Drop program from memory if it exists
cap prog drop sysresources

// Define the program with r-class properties
prog def sysresources, rclass

    // Program requires Stata 13 to execute
    version 13

    // Defines the syntax for the program
    syntax [, Display ]

	// Call the java method
	javacall org.paces.Stata.SysResources compResources, args(`display')

	// Clear existing returned results
	ret clear

	// Set the returned scalar values
	ret sca commitmem = commitmem
	ret sca freeswap = freeswap
	ret sca totalswap = totalswap
	ret sca proctime = proctime
	ret sca freemem = freemem
	ret sca totmem = totmem
	ret sca cpuload = cpuload
	ret sca procload = procload
	ret sca pctfreemem = pctfreemem

// End of program
end

