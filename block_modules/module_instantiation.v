// port connections can be done via an ordered list or by name.
module mydesign ( input  x, y, z,     // x is at position 1, y at 2, x at 3 and
                  output o);          // o is at position 4

endmodule

module tb_top;
	wire [1:0]  a;
	wire        b, c;

	mydesign d0  (a[0], b, a[1], c);  // a[0] is at position 1 so it is automatically connected to x
	                                  // b is at position 2 so it is automatically connected to y
	                                  // a[1] is at position 3 so it is connected to z
	                                  // c is at position 4, and hence connection is with o
endmodule

// port connection by name
module design_top;
    wire [1:0] a;
    wire       b,c;
    mydesign d0 (   .x(a[0]),
                    .y(b),
                    .z(a[1]),
                    .o(c)); 
endmodule
//It is recommended to code each port connection in a separate line 
//so that any compilation error message will correctly point to the line number where the error occured. 

//Ports that are not connected to any wire in the instantiating module will have a value of high-impedance.
`include "/Users/qingjie/github/Verilog_Learning/Introduction/example_dff.v"
module shift_reg(   input d,
                    input clk,
                    input rstn,
                    output q);
    wire [2:0] q_net;
    dff u0(.d(d),   .clk(clk),  .rstn(rstn), .q(q_net[0]));
    dff u1(.d(q_net[0]),   .clk(clk),  .rstn(rstn), .q());
    dff u2(.d(q_net[1]),   .clk(clk),  .rstn(rstn), .q());
    dff u3(.d(q_net[2]),   .clk(clk),  .rstn(rstn), .q(q));
endmodule

//Note that outputs from instances u1 and u2 are left unconnected 
//in the RTL schematic obtained after synthesis. 
//Since the input d to instances u2 and u3 are now connected to nets that are not being driven by anything 
//it is grounded.

//In simulations, such unconnected ports will be denoted as high impedance ('hZ) typically shown in waveforms as an orange line 

//All port declarations are implicitly declared as wire 
//and hence the port direction is sufficient in that case. 
//However output ports that need to store values should be declared as reg data type and can be used in a procedural block like always and initial only.

//Ports of type input or inout cannot be declared as reg 
//because they are being driven from outside continuously and should not store values, rather reflect the changes in the external signals as soon as possible


//It is perfectly legal to connect two ports with varying vector sizes,
//the one with lower vector size will prevail and the remaining bits of the other port with a higher width will be ignored.

/*
// Case #1 : Inputs are by default implicitly declared as type "wire"
module des0_1	(input wire clk ...); 		// wire need not be specified here
module des0_2 	(input clk, ...); 			// By default clk is of type wire

// Case #2 : Inputs cannot be of type reg
module des1 (input reg clk, ...); 		// Illegal: inputs cannot be of type reg

// Case #3: Take two modules here with varying port widths
module des2 (output [3:0] data, ...);	// A module declaration with 4-bit vector as output
module des3 (input [7:0] data, ...); 	// A module declaration with 8-bit vector as input

module top ( ... );
	wire [7:0] net;
	des2  u0 ( .data(net) ... ); 		// Upper 4-bits of net are undriven
	des3  u1 ( .data(net) ... );
endmodule

// Case #4 : Outputs cannot be connected to reg in parent module
module top_0 ( ... );
	reg [3:0] data_reg;

	des2 ( .data(data) ...); 	// Illegal: data output port is connected to a reg type signal "data_reg"
endmodule
*/