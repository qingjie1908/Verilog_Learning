//how to instantiate and connect the interface with a design. There are two ways in which the design can be written:

//By using an existing interface name to specifically use only that interface
//By using a generic interface handle to which any interface can be passed

//Obviously, the generic method works best when interface definitions are updated to newer versions with a different name, 
//and needs to support older designs that use it.

//Example using a named bundle
//In this case, the design references the actual interface name for access to its signals.
//both design modules myDesign and yourDesign declares a port in the port list called if0 of type myInterface to access signals.

/*
module myDesign  (  myInterface  if0,
                    input logic  clk);
	always @ (posedge clk)
		if (if0.ack)
			if0.gnt <= 1;

	...
endmodule

module yourDesign (  myInterface 	if0,
					 input logic 	clk);
	...

endmodule

module tb;
	logic clk = 0;

	myInterface 	_if;

	myDesign 	md0 	(_if, clk);
	yourDesign	yd0 	(_if, clk);

endmodule
*/

//Example using a generic bundle
//In this case, the design uses the interface keyword as a placeholder for the actual interface type.
//The actual interface is then passed during design module instantiation.
//This generic interface reference can only be declared using ANSI style of port declaration syntax and is illegal otherwise.
/*
module myDesign  ( interface  a,
                   input logic  clk);

	always @ (posedge clk)
		if (a.ack)
			a.gnt <= 1;

	...
endmodule

module yourDesign (  interface 		b,
					 input logic 	clk);
	...

endmodule

module tb;
	logic clk = 0;

	myInterface  _if;

	myDesign 	md0 ( .*, .a(_if));   // use partial implicit port connections
	yourDesign	yd0 ( .*, .b(_if));

endmodule
*/