//Types that can have unknown (X) and high-impedance (Z) value in addition to zero (0) and one (1) are called 4-state types.
//reg can only be driven in procedural blocks like always and initial
//while wire data types can only be driven in assign statements

//logic that can be driven in both procedural blocks and continuous assign statements

//a signal with more than one driver needs to be declared a net-type such as wire so that SystemVerilog can resolve the final value.

//logic

module tb;
	logic [3:0]  my_data; 		// Declare a 4-bit logic type variable
	logic        en; 			// Declare a 1-bit logic type variable

	initial begin
    	$display ("my_data=0x%0h en=%0b", my_data, en);    	// Default value of logic type is X
		my_data = 4'hB; 									// logic datatype can be driven in initial/always blocks
      	$display ("my_data=0x%0h en=%0b", my_data, en);
      	#1;
      	$display ("my_data=0x%0h en=%0b", my_data, en);
	end

  	assign en = my_data[0]; 								// logic datatype can also be driven via assign statements
endmodule

//output
/*
my_data=0xx en=x
my_data=0xb en=x
my_data=0xb en=1
*/

//2-state data types

//In a typical verification testbench, there are many cases where we don't really need all the four values (0, 1, x, z) 
//like for example when modeling a network packet with a header that specifies the length of the packet.
//Length is usually a number, but not X and Z. 
//SystemVerilog adds many new 2-state data types that can only store and have a value of either 0 or 1. 
//This will aid in faster simulation, take less memory and are preferred in some design styles.

//bit
//The most important 2-state data type is bit 
//which is used most often in testbenches. 
//A variable of type bit can be either 0 or 1 which represents a single bit. 
//A range from MSB to LSB should be provided to make it represent and store multiple bits

module tb2;
  bit       var_a;       // Declare a 1 bit variable of type "bit"
  bit [3:0] var_b;       // Declare a 4 bit variable of type "bit"

  logic [3:0] x_val;     // Declare a 4 bit variable of type "logic"

  initial begin

    // Initial value of "bit" data type is 0
    $display ("Initial value var_a=%0b var_b=0x%0h", var_a, var_b);

    // Assign new values and display the variable to see that it gets the new values
    var_a = 1;
    var_b = 4'hF;
    $display ("New values    var_a=%0b var_b=0x%0h", var_a, var_b);

    // If a "bit" type variable is assigned with a value greater than it can hold
    // the left most bits are truncated. In this case, var_b can hold only 4 bits
    // and hence 'h481 gets truncated leaving var_b with only 'ha;
    var_b = 16'h481a;
    $display ("Truncated value: var_b=0x%0h", var_b);

    // If a logic type or any 4-state variable assigns its value to a "bit" type
    // variable, then X and Z get converted to zero
    var_b = 4'b01zx;
    $display ("var_b = %b", var_b);
  end
endmodule

//output
/*
Initial value var_a=0 var_b=0x0
New values    var_a=1 var_b=0xf
Truncated value: var_b=0xa
var_b = 0100
*/