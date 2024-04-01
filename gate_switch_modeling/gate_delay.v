//Delays	Description
//Rise delay	The time taken for the output of a gate to change from some value to 1 from either 0, X or Z
//Fall delay	The time taken for the output of a gate to change fomr some value to 0 from either 1, X or Z
//Turn-off delay	The time taken for the output of a gate to change to Z, high impedance from either 0, 1, or X

//There are three ways to represent gate delays 
//and the two delay format can be applied to most primitives whose outputs do not transition to high impedance. 
//Like a three delay format cannot be applied to an AND gate because the output will not go to Z for any input combination.

// Single delay specified - used for all three types of transition delays
/*
or #(<delay>) o1 (out, a, b);

// Two delays specified - used for Rise and Fall transitions
or #(<rise>, <fall>) o1 (out, a, b);

// Three delays specified - used for Rise, Fall and Turn-off transitions
or #(<rise>, <fall>, <turn_off>) o1 (out, a, b);
*/


module des (	input 	a, b,
            	output out1, out2);

	// AND gate has 2 time unit gate delay
  and 		#(2) o1 (out1, a, b);

  // BUFIF0 gate has 3 time unit gate delay
  bufif0 	#(3) b1 (out2, a, b);

endmodule

module tb;
  reg a, b;
  wire out1, out2;

  des d0 (.out1(out1), .out2(out2), .a(a), .b(b));

  initial begin
    {a, b} <= 0;

    $monitor ("T=%0t a=%0b b=%0b and=%0b bufif0=%0b", $time, a, b, out1, out2);

    #10 a <= 1;
    #10 b <= 1;
    #10 a <= 0;
    #10 b <= 0;
  end
endmodule

//output
/*
T=0 a=0 b=0 and=x bufif0=x
T=2 a=0 b=0 and=0 bufif0=x
T=3 a=0 b=0 and=0 bufif0=0
T=10 a=1 b=0 and=0 bufif0=0
T=13 a=1 b=0 and=0 bufif0=1
T=20 a=1 b=1 and=0 bufif0=1
T=22 a=1 b=1 and=1 bufif0=1
T=23 a=1 b=1 and=1 bufif0=z
T=30 a=0 b=1 and=1 bufif0=z
T=32 a=0 b=1 and=0 bufif0=z
T=40 a=0 b=0 and=0 bufif0=z
T=43 a=0 b=0 and=0 bufif0=0
*/

//Min/Typ/Max Delays

//Delays are not the same in different parts of the fabricated chip nor is it same for different temperatures and other variations.
//Every digital gate and transistor cell has a minimum, typical and maximum delay specified based on process node and is typically provided by libraries from fabrication foundry.
//For each type of delay - rise, fall, and turn-off - three values min, typ and max can be specified and stand for minimum, typical and maximum delays.

/*
module des1 (	input 	a, b,
            	output out1, out2);

  and #(2:3:4, 3:4:5) o1 (out1, a, b);
  bufif0 #(5:6:7, 6:7:8, 7:8:9) b1 (out2, a, b);

endmodule
*/