//All UDPs have exactly one output that can be either 0, 1 or X and never Z (not supported). 
//Any input that has the value Z will be treated as X.

//defined primitives can be written at the same level as module definitions, 
//but never between module and endmodule.

//can have many input ports but always one output port, 
//and bi-directional ports are not valid.

//All port signals have to be scalar which means they have to be 1-bit wide

//Hardware behavior is described as a primitive state table which lists out different possible combination of inputs and their corresponding output within 'table' and 'endtable'. Values of input and output signals are indicated using the following symbols.

/*
Symbol	Comments
0	Logic 0
1	Logic 1
x	Unknown, can be either logic 0 or 1. Can be used as input/output or current state of sequential UDPs
?	Logic 0, 1 or x. Cannot be output of any UDP
-	No change, only allowed in output of a UDP
ab	Change in value from a to b where a or b is either 0, 1, or x
*	Same as ??, indicates any change in input value
r	Same as 01 -> rising edge on input
f	Same as 10 -> falling edge on input
p	Potential positive edge on input; either 0->1, 0->x, or x->1
n	Potential falling edge on input; either 1->0, x->0, 1->x
*/

//=========== Combinational UDP Example
// Output should always be the first signal in port list
primitive mux (out, sel, a, b);
	output 	out;
	input 	sel, a, b;

	table
		// sel 	a 	b 		out
			0 	1 	? 	: 	1;
			0 	0 	? 	: 	0;
			1 	? 	0 	: 	0;
			1 	? 	1 	: 	1;
			x 	0 	0 	: 	0;
			x 	1 	1 	: 	1;
	endtable
endprimitive

//A ? indicates that the signal can be either 0, 1 or x and does not matter in deciding the final output.

module tb;
  reg 	sel, a, b;
  reg [2:0] dly;
  wire 	out;
  integer i;

  // Instantiate the UDP - note that UDPs cannot
  // be instantiated with port name connection
  mux u_mux ( out, sel, a, b);

  initial begin
    a <= 0;
    b <= 0;

    $monitor("[T=%0t] a=%0b b=%0b sel=%0b out=%0b", $time, a, b, sel, out);

    // Drive a, b, and sel after different random delays
    for (i = 0; i < 10; i = i + 1) begin
      	dly = $random;
      #(dly) a <= $random;
      	dly = $random;
      #(dly) b <= $random;
      	dly = $random;
      #(dly) sel <= $random;
    end
  end
endmodule

//output
/*
[T=0] a=0 b=0 sel=x out=0
[T=4] a=1 b=0 sel=x out=x
[T=5] a=1 b=1 sel=x out=1
[T=10] a=1 b=1 sel=1 out=1
[T=15] a=0 b=1 sel=1 out=1
[T=28] a=0 b=0 sel=1 out=0
[T=33] a=0 b=0 sel=0 out=0
[T=38] a=1 b=0 sel=0 out=1
[T=40] a=1 b=1 sel=0 out=1
[T=51] a=1 b=1 sel=1 out=1
[T=54] a=0 b=0 sel=1 out=0
[T=62] a=1 b=0 sel=1 out=0
[T=67] a=1 b=1 sel=1 out=1
[T=72] a=0 b=1 sel=1 out=1
[T=80] a=0 b=1 sel=0 out=0
[T=84] a=0 b=0 sel=0 out=0
[T=85] a=1 b=0 sel=0 out=1
*/


//=========== Sequential UDP Example
//Sequential logic can be either level-sensitive or edge-sensitive 
//and hence there are two kinds of sequential UDPs.

//Output port should also be declared as reg type within the UDP definition 
//and can be optionally initialized within an initial statement.

//Sequential UDPs have an additional field in between the input and output field 
//which is delimited by a : which represents the current state.

//Level-Sensitive UDPs:
//a hyphen - on the last row of the table indicates no change in value for q+

primitive d_latch (q, clk, d);
	output 	q;
	input 	clk, d;
	reg  	q;

	table
		// clk 	d 		q 	q+
			1 	1 	:	? :	1;
			1 	0 	: 	? : 0;
			0 	? 	: 	? : -; // - means no change for q+
	endtable
endprimitive

module tb;
  reg clk, d;
  reg [1:0] dly;
  wire q;
  integer i;

  d_latch u_latch (q, clk, d);

  always #10 clk = ~clk;

  initial begin
    clk = 0;

    $monitor ("[T=%0t] clk=%0b d=%0b q=%0b", $time, clk, d, q);

    #10;  // To see the effect of X

    for (i = 0; i < 50; i = i+1) begin
      dly = $random;
      #(dly) d <= $random;
    end

    #20 $finish;
  end
endmodule

//output
/*
[T=0] clk=0 d=x q=x
[T=10] clk=1 d=1 q=1
[T=13] clk=1 d=0 q=0
[T=14] clk=1 d=1 q=1
[T=17] clk=1 d=0 q=0
[T=20] clk=0 d=1 q=0
[T=24] clk=0 d=1 q=0
[T=28] clk=0 d=0 q=0
[T=30] clk=1 d=1 q=1
[T=38] clk=1 d=0 q=0
[T=39] clk=1 d=1 q=1
[T=40] clk=0 d=1 q=1
[T=42] clk=0 d=0 q=1
[T=47] clk=0 d=1 q=1
[T=50] clk=1 d=0 q=0
[T=55] clk=1 d=1 q=1
[T=59] clk=1 d=0 q=0
[T=60] clk=0 d=0 q=0
[T=61] clk=0 d=1 q=0
[T=64] clk=0 d=0 q=0
[T=67] clk=0 d=1 q=0
[T=70] clk=1 d=0 q=0
[T=73] clk=1 d=1 q=1
[T=74] clk=1 d=0 q=0
[T=77] clk=1 d=1 q=1
[T=79] clk=1 d=0 q=0
[T=80] clk=0 d=0 q=0
[T=84] clk=0 d=1 q=0
[T=86] clk=0 d=0 q=0
[T=87] clk=0 d=1 q=0
[T=90] clk=1 d=1 q=1
[T=91] clk=1 d=0 q=0
[T=100] clk=0 d=0 q=0
[T=110] clk=1 d=0 q=0
main.v:36: $finish called at 111 (1s)
*/

//Edge-Sensitive UDPs:

//A D flip-flop is modeled as a Verilog user-defined primitive in the example shown below. 
//Note that rising edge of the clock is specified by 01 or 0?

primitive d_flop (q, clk, d);
	output  q;
	input 	clk, d;
	reg 	q;

	table
		// clk 		d 	 	q 		q+
			// obtain output on rising edge of clk
			(01)	0 	: 	? 	: 	0;
			(01) 	1 	: 	? 	: 	1;
			(0?) 	1 	: 	1 	: 	1;
			(0?) 	0 	: 	0 	: 	0;

			// ignore negative edge of clk
			(?0) 	? 	: 	? 	: 	-;

			// ignore data changes on steady clk
			? 		(??): 	? 	: 	-;
	endtable
endprimitive

module tb;
  reg clk, d;
  reg [1:0] dly;
  wire q;
  integer i;

  d_flop u_flop (q, clk, d);

  always #10 clk = ~clk;

  initial begin
    clk = 0;

    $monitor ("[T=%0t] clk=%0b d=%0b q=%0b", $time, clk, d, q);

    #10;  // To see the effect of X

    for (i = 0; i < 20; i = i+1) begin
      dly = $random;
      repeat(dly) @(posedge clk);
      d <= $random;
    end

    #20 $finish;
  end
endmodule

//output
//output q follows the input d after 1 clock delay, why????
/*
[T=0] clk=0 d=x q=x
[T=10] clk=1 d=1 q=x
[T=20] clk=0 d=1 q=x
[T=30] clk=1 d=1 q=1
[T=40] clk=0 d=1 q=1
[T=50] clk=1 d=1 q=1
[T=60] clk=0 d=1 q=1
[T=70] clk=1 d=0 q=1
[T=80] clk=0 d=0 q=1
[T=90] clk=1 d=1 q=0
[T=100] clk=0 d=1 q=0
[T=110] clk=1 d=1 q=1
[T=120] clk=0 d=1 q=1
[T=130] clk=1 d=1 q=1
[T=140] clk=0 d=1 q=1
[T=150] clk=1 d=0 q=1
[T=160] clk=0 d=0 q=1
[T=170] clk=1 d=0 q=0
[T=180] clk=0 d=0 q=0
[T=190] clk=1 d=0 q=0
[T=200] clk=0 d=0 q=0
[T=210] clk=1 d=1 q=0
[T=220] clk=0 d=1 q=0
[T=230] clk=1 d=1 q=1
[T=240] clk=0 d=1 q=1
[T=250] clk=1 d=1 q=1
[T=260] clk=0 d=1 q=1
[T=270] clk=1 d=1 q=1
[T=280] clk=0 d=1 q=1
[T=290] clk=1 d=1 q=1
[T=300] clk=0 d=1 q=1
[T=310] clk=1 d=1 q=1
[T=320] clk=0 d=1 q=1
[T=330] clk=1 d=1 q=1
[T=340] clk=0 d=1 q=1
[T=350] clk=1 d=1 q=1
[T=360] clk=0 d=1 q=1
[T=370] clk=1 d=0 q=1
[T=380] clk=0 d=0 q=1
[T=390] clk=1 d=0 q=0
[T=400] clk=0 d=0 q=0
[T=410] clk=1 d=1 q=0
[T=420] clk=0 d=1 q=0
[T=430] clk=1 d=1 q=1
[T=440] clk=0 d=1 q=1
[T=450] clk=1 d=1 q=1
[T=460] clk=0 d=1 q=1
[T=470] clk=1 d=1 q=1
[T=480] clk=0 d=1 q=1
main.v:45: $finish called at 490 (1s)
[T=490] clk=1 d=1 q=1
*/