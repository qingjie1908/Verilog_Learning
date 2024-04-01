//There are two types of timing controls in Verilog - delay and event expressions.


//delay expression:
//If the delay expression evaluates to an unknown or high-impedance value it will be interpreted as zero delay. 
//If it evaluates to a negative value, it will be interpreted as a 2's complement unsigned integer of the same size as a time variable.

//Note that the precision of timescale is in 1ps 
//and hence $realtime is required to display the precision value for the statement with a delay expression (a+b)*10ps.

`timescale 1ns/1ps // `timescale time_unit/time_precision

module tb;
  reg [3:0] a, b;

  initial begin
    {a, b} <= 0;
    $display ("T=%0t a=%0d b=%0d", $realtime, a, b);

    #10;
    a <= $random;
    $display ("T=%0t a=%0d b=%0d", $realtime, a, b);

    #10 b <= $random;
    $display ("T=%0t a=%0d b=%0d", $realtime, a, b);

    #(a) $display ("T=%0t After a delay of a=%0d units", $realtime, a);
    #(a+b) $display ("T=%0t After a delay of a=%0d + b=%0d = %0d units", $realtime, a, b, a+b);
    #((a+b)*10ps) $display ("T=%0t After a delay of %0d * 10ps", $realtime, a+b);

    #(b-a) $display ("T=%0t Expr evaluates to a negative delay", $realtime);
    #('h10) $display ("T=%0t Delay in hex", $realtime);

    a = 'hX;
    #(a) $display ("T=%0t Delay is unknown, taken as zero a=%h", $realtime, a);

    a = 'hZ;
    #(a) $display ("T=%0t Delay is in high impedance, taken as zero a=%h", $realtime, a);

    #1ps $display ("T=%0t Delay of 1ps", $realtime);
  end

endmodule

//event control
//Value changes on nets and variables can be used as a synchronization event to trigger execution other procedural statements 
//and is an implicit event.

//The event can also be based on the direction of change like towards 0 which makes it a negedge and a change towards 1 makes it a posedge.

//A negedge is when there is a transition from 1 to X, Z or 0 and from X or Z to 0
//A posedge is when there is a transition from 0 to X, Z or 1 and from X or Z to 1

//A transition from the same state to the same state is not considered as an edge.
//edge event like posedge or negedge can be detected only on the LSB of a vector signal or variable.


module tb1;
  reg a, b;

  initial begin
    a <= 0;

    #10 a <= 1;
    #10 b <= 1;

    #10 a <= 0;
    #15 a <= 1;
  end

  // Start another procedural block that waits for an update to
  // signals made in the above procedural block

  initial begin
    @(posedge a); // this is single statement, so only detect once
    $display ("T=%0t Posedge of a detected for 0->1", $time);
    @(posedge b);
    $display ("T=%0t Posedge of b detected for X->1", $time);
  end

  initial begin
    @(posedge (a + b)) $display ("T=%0t Posedge of a+b", $time);

    @(a) $display ("T=%0t Change in a found", $time); // this is single statement, after previous dectect change (a+b), time has alread advanced to 30, at 30, a = 0;
  end
endmodule

//output
/*
T=10 Posedge of a detected for 0->1
T=20 Posedge of b detected for X->1
T=30 Posedge of a+b
T=45 Change in a found
*/

//Name event
//The keyword event can be used to declare a named event which can be triggered explicitly
//An event cannot hold any data, has no time duration and can be made to occur at any particular time.
//A named event is triggered by the -> operator by prefixing it before the named event handle. 
//A named event can be waited upon by using the @ operator described above.

module tb2;
  event a_event;
  //event b_event[5]; event arrays only supported in system verilog
  event b_event;

  initial begin
    #20 -> a_event;

    #30;
    ->a_event;

    #50 ->a_event;
    #10 ->b_event;
  end

  always @ (a_event) $display ("T=%0t [always] a_event is triggered", $time);

  initial begin
    #25;
    @(a_event) $display ("T=%0t [initial] a_event is triggered", $time); // first a_event happens already happen at 20, need to wait next a_event

    #10 @(b_event) $display ("T=%0t [initial] b_event is triggered", $time); // after preivous statemnet, time is 50, advance 10, wait for b_event from time 60
  end
endmodule

//output
/*
T=20 [always] a_event is triggered
T=50 [initial] a_event is triggered
T=50 [always] a_event is triggered
T=100 [always] a_event is triggered
T=110 [initial] b_event is triggered
*/

//Event or operator
//The or operator can be used to wait on until any one of the listed events is triggered in an expression. 
//The comma , can also be used instead of the or operator.

module tb3;
  reg a, b;

  initial begin
    $monitor ("T=%0t a=%0d b=%0d", $time, a, b);
    {a, b} <= 0;

    #10 a <= 1;
    #5  b <= 1;
	#5  b <= 0;
  end

  // Use "or" between events
  always @ (posedge a or posedge b)
    $display ("T=%0t posedge of a or b found", $time);

  // Use a comma between
  always @ (posedge a, negedge b)
    $display ("T=%0t posedge of a or negedge of b found", $time);

  always @ (a, b)
    $display ("T=%0t Any change on a or b", $time);
endmodule

//output
/*
T=0 posedge of a or negedge of b found
T=0 Any change on a or b
T=0 a=0 b=0
T=10 posedge of a or b found
T=10 posedge of a or negedge of b found
T=10 Any change on a or b
T=10 a=1 b=0
T=15 posedge of a or b found
T=15 Any change on a or b
T=15 a=1 b=1
T=20 posedge of a or negedge of b found
T=20 Any change on a or b
T=20 a=1 b=0
*/

//If the user decides to add new signal e and capture the inverse into z , special care must be taken to add e also into the sensitivity list
//Verilog now allows the sensitivity list to be replaced by * which is a convenient shorthand that eliminates these problems 
//by adding all nets and variables that are read by the statemnt like shown below.
module tb4;
	reg a, b, c, d, e;
	reg x, y, z;

  // Add "e" also into sensitivity list
  always @ (a, b, c, d, e) begin // always @ * begin
		x = a | b;
		y = c ^ d;
    z = ~e;
	end

	initial begin
      $monitor ("T=%0t a=%0b b=%0b c=%0b d=%0b e=%0b x=%0b y=%0b z=%0b",
                				$time, a, b, c, d, e, x, y, z);
      {a, b, c, d, e} <= 0;

      #10 {a, b, c, d, e} <= $random;
      #10 {a, b, c, d, e} <= $random;
      #10 {a, b, c, d, e} <= $random;
	end
endmodule

// level sensitive event control
//Execution of a procedural statement can also be delayed until a condition becomes true and can be accomplished with the wait keyword 
//and is a level-sensitive control.

module tb5;
  reg [3:0] ctr;
  reg clk;

  initial begin
    {ctr, clk} <= 0;

    wait (ctr);
    $display ("T=%0t Counter reached non-zero value 0x%0h", $time, ctr);

    wait (ctr == 4) $display ("T=%0t Counter reached 0x%0h", $time, ctr);

    $finish;
  end

  always #10 clk = ~clk;

  always @ (posedge clk)
    ctr <= ctr + 1;

endmodule

//output
/*
T=10 Counter reached non-zero value 0x1
T=70 Counter reached 0x4
jdoodle.v:13: $finish called at 70 (1s)
*/