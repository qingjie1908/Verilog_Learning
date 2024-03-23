// Ports are [by default] considered as nets of type wire.
/*
Input:	The design module can only receive values from outside using its input ports
Output:	The design module can only send values to the outside using its output ports
Inout:	The design module can either send or receive values using its inout ports
*/

/* Syntax
input  [net_type] [range] list_of_names; 	// Input port
inout  [net_type] [range] list_of_names; 	// Input & Output port
output [net_type] [range] list_of_names; 	// Output port driven by a wire
output [var_type] [range] list_of_names; 	// Output port driven by a variable
*/

/*
module xx( input signed a, b,
         output c); //If you declare the directional of the port in the portlist, you must also declare the type. This is referred to as an ANSI style header.
         // which means at this time ,a b c already declared as wire type by default
	reg signed a, b;          // a, b are signed from port declaration, change from net(wire), error, redeclaration
	reg signed c;       // c is signed from reg declaration, error , redeclaration
endmodule
*/

module test (a, b, c);
// If you are fallowing IEEE1364-1995 convention 
// then you must use non-ANSI style and you cannot declare the type (e.g. output reg test_output2; is illegal, 
// while output test_output2; reg test_output2; is legal). 
	input  [7:0] a, b;
	output [7:0] c;           // By default c is of type wire

	// port "c" is changed to a reg type
	reg    [7:0] c;
endmodule

//Verilog 2001 onwards
//ANSI-C style port naming was introduced in 2001 and allowed the type to be specified inside the port list.
module test1 ( input [7:0]	a,
                            b, 		// "b" is considered an 8-bit input
              output [7:0]  c);

	// Design content
endmodule

module test2 ( input wire [7:0]	a,
              input wire [7:0]  b,
              output reg [7:0]  c);

	// Design content
endmodule

//If a port declaration includes a net or variable type, then that port is considered to be completely declared. 
//It is illegal to redeclare the same port in a net or variable type declaration.
/*
module test ( input      [7:0] a,       // a, e are implicitly declared of type wire
	          output reg [7:0] e );

   wire signed [7:0] a;     // illegal - declaration of a is already complete -> simulator dependent
   wire        [7:0] e;     // illegal - declaration of e is already complete

   // Rest of the design code
endmodule
*/

//If the port declaration does not include a net or variable type, 
//then the port can be declared in a net or variable type declaration again.
/*
module test3 ( input      [7:0] a, // a is implicitly declared of type wire
              output     [7:0] e);

     reg [7:0] e;              // error - net_type was implicitly declared before

     // Rest of the design code
endmodule
*/