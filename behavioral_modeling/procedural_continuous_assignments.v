//Procedural assignments 
//occur within procedures such as always, initial, task and functions and are used to place values onto variables.
//The variable will hold the value until the next assignment to the same variable.

//If the variable is initialized during declaration and at time 0 in an initial block as shown below, the order of evaluation is not guaranteed, and hence can have either 8'h05 or 8'hee.
module my_block;
	reg [7:0]  addr = 8'h05;

	initial
		addr = 8'hee; // addr will have either h05 or hee since they both happen at time 0
endmodule

// Note that variable declaration assignments to an array are not allowed.

module m1;
    //reg [3:0] array [3:0] = 0;           // illegal
    integer i = 0, j;                    // declares two integers i,j and i is assigned 0
    real r2 = 4.5, r3 = 8;               // declares two real numbers r2,r3 and are assigned 4.5, 8 resp.
    time startTime = 40;                 // declares time variable with initial value 40
endmodule

//Continuous Assignment
//This is used to assign values onto scalar and vector nets and happens whenever there is a change in the RHS.

//Net declaration assignment
//place a continuous assignment on the same statement that declares the net
//because a net can be declared only once, only one declaration assignment is possible for a net.
//wire penable = 1;

//Procedural Continuous Assignment
//procedural statements that allow expressions to be continuously assigned to nets or variables and are of two types.
//assign ... deassign
//force ... release

//assign deassign
//This will override all procedural assignments to a variable and is deactivated by using the same signal with deassign
//The LHS of an assign statement cannot be a bit-select, part-select or an array reference but can be a variable or a concatenation of variables.
/*
reg q;

initial begin
	assign q = 0;
	#10 deassign q;
end
*/

//force release
//These are similar to the assign - deassign
//but can also be applied to nets and variables
//The LHS can be a bit-select of a net, part-select of a net, variable or a net but cannot be the reference to an array and bit/part select of a variable.
//The force statment will override all other assignments made to the variable until it is released using the release keyword.
/*
reg o, a, b;

initial begin
	force o = a & b;
	...
	release o;
end
*/


