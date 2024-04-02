//Verilog simulation depends on how time is defined because the simulator needs to know what a #1 means in terms of time. The `timescale compiler directive specifies the time unit and precision for the modules that follow it.

/*
Syntax:

`timescale <time_unit>/<time_precision>

// Example
`timescale 1ns/1ps
`timescale 10us/100ns
`timescale 10ns/1ns

*/

//The time_unit is the measurement of delays and simulation time 
//while the time_precision specifies how delay values are rounded before being used in simulation.

//`timescale for base unit of measurement and precision of time
//$printtimescale system task to display time unit and precision
//$time and $realtime system functions return the current time and the default reporting format can be changed with another system task $timeformat.

//Example #1: 1ns/1ns

// Declare the timescale where time_unit is 1ns
// and time_precision is also 1ns
`timescale 1ns/1ns

module tb;
	// To understand the effect of timescale, let us
	// drive a signal with some values after some delay
  reg val;

  initial begin
  	// Initialize the signal to 0 at time 0 units
    val <= 0;

    // Advance by 1 time unit, display a message and toggle val
    #1 		$display ("T=%0t At time #1", $realtime);
    val <= 1;
    //0.49 which is less than half a time unit. 
    //However the time precision is specified to be 1ns 
    //and hence the simulator cannot go smaller than 1 ns which makes it to round the given delay statement and yields 0ns.

    // Advance by 0.49 time unit and toggle val
    #0.49 	$display ("T=%0t At time #0.49", $realtime); //
    val <= 0;

    // Advance by 0.50 time unit and toggle val
    #0.50 	$display ("T=%0t At time #0.50", $realtime);
    val <= 1;

    // Advance by 0.51 time unit and toggle val
    #0.51 	$display ("T=%0t At time #0.51", $realtime);
    val <= 0;

		// Let simulation run for another 5 time units and exit
    #5 $display ("T=%0t End of simulation", $realtime);
  end
endmodule

//output
/*
T=1 At time #1
T=1 At time #0.49
T=2 At time #0.50
T=3 At time #0.51
T=8 End of simulation
*/

//Example #2: 10ns/1ns

// Declare the timescale where time_unit is 10ns
// and time_precision is 1ns
`timescale 10ns/1ns

// NOTE: Testbench is the same as in previous example
module tb;
	// To understand the effect of timescale, let us
	// drive a signal with some values after some delay
  reg val;

  initial begin
  	// Initialize the signal to 0 at time 0 units
    val <= 0;

    // Advance by 1 time unit, display a message and toggle val
    #1 		$display ("T=%0t At time #1", $realtime);
    val <= 1;

    // Advance by 0.49 time unit and toggle val
    #0.49 	$display ("T=%0t At time #0.49", $realtime);
    val <= 0;

    // Advance by 0.50 time unit and toggle val
    #0.50 	$display ("T=%0t At time #0.50", $realtime);
    val <= 1;

    // Advance by 0.51 time unit and toggle val
    #0.51 	$display ("T=%0t At time #0.51", $realtime);
    val <= 0;

		// Let simulation run for another 5 time units and exit
    #5 $display ("T=%0t End of simulation", $realtime);
  end
endmodule

//output
/*
T=10 At time #1
T=15 At time #0.49
T=20 At time #0.50
T=25 At time #0.51
T=75 End of simulation
*/

//Example #3: 1ns/1ps

// Declare the timescale where time_unit is 1ns
// and time_precision is 1ps
`timescale 1ns/1ps

// NOTE: Testbench is the same as in previous example
module tb;
	// To understand the effect of timescale, let us
	// drive a signal with some values after some delay
  reg val;

  initial begin
  	// Initialize the signal to 0 at time 0 units
    val <= 0;

    // Advance by 1 time unit, display a message and toggle val
    #1 		$display ("T=%0t At time #1", $realtime);
    val <= 1;

    // Advance by 0.49 time unit and toggle val
    #0.49 	$display ("T=%0t At time #0.49", $realtime);
    val <= 0;

    // Advance by 0.50 time unit and toggle val
    #0.50 	$display ("T=%0t At time #0.50", $realtime);
    val <= 1;

    // Advance by 0.51 time unit and toggle val
    #0.51 	$display ("T=%0t At time #0.51", $realtime);
    val <= 0;

		// Let simulation run for another 5 time units and exit
    #5 $display ("T=%0t End of simulation", $realtime);
  end
endmodule

//output
/*
T=1000 At time #1
T=1490 At time #0.49
T=1990 At time #0.50
T=2500 At time #0.51
T=7500 End of simulation
*/