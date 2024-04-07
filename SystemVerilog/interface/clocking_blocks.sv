//Module ports and interfaces by default do not specify any timing requirements or synchronization schemes between signals.
//A clocking block defined between clocking and endcocking does exactly that.
//It is a collection of signals synchronous with a particular clock and helps to specify the timing requirements between the clock and the signals.

//This would allow test writers to focus more on transactions rather than worry about when a signal will interact with respect to a clock. A testbench can have many clocking blocks, 
//but only one block per clock.

//Syntax
/*
[default] clocking [identifier_name] @ [event_or_identifier]
	default input #[delay_or_edge] output #[delay_or_edge]
	[list of signals]
endclocking
*/

//Signal directions inside a clocking block are with respect to the testbench and not the DUT.
//The delay_value represents a skew of how many time units away from the clock event a signal is to be sampled or driven. 
//If a default skew is not specified, then all input signals will be sampled #1step and output signlas driven 0ns after the specified event.
/*
clocking ckb @ (posedge clk);
	default input #1step output negedge;
	input ...;
	output ...;
endclocking

clocking ck1 @ (posedge clk);
	default input #5ns output #2ns;
	input data, valid, ready = top.ele.ready;
	output negedge grant;
	input #1step addr;
endclocking
*/

//ck1 explaination:
//A clocking block called ck1 is created which will be active on the positive edge of clk
//By default, all input signals within the clocking block will be sampled 5ns before posedge of clk and all output signals within the clocking block will be driven 2ns after the positive edge of the clock clk
//data, valid and ready are declared as inputs to the block and hence will be sampled 5ns before the posedge of clk
//grant is an output signal to the block with its own time requirement. Here grant will be driven at the negedge of clk instead of the default posedge.


//====Use within an interface

//Simply put, a clocking block encapsulates a bunch of signals that share a common clock. 
//Hence declaring a clocking block inside an interface can help save the amount of code required to connect to the testbench and may help save time during development.

//====Important
//Signal directions inside a clocking block are with respect to the testbench and not the DUT.

//====What are input and output skews ?

//A skew is specified as a constant expression or as a parameter. 
//If only a number is used, then the skew is interpreted to follow the active timescale in the given scope.
/*
clocking cb @(clk);
    input  #1ps req;
    output #2 	gnt;
    input  #1 output #3 sig;
endclocking
*/

//1. Signal req is specified to have a skew of 1ps and will be sampled 1 ps before the clock edge clk.
//2. output signal gnt has an output skew of 2 time units and hence will follow the timescale followed in the current scope
//   If we have a timescale of 1ns/1ps then #2 represents 2 ns and hence will be driven 2 ns after the clock edge. 
//3. The last signal sig is of inout type 
//      and will be sampled 1 ns before the clock edge and driven 3 ns after the clock edge.

//An input skew of 1step indicates that the signal should be sampled at the end of the previous time step, or in other words, immediately before the positive clock edge.
/*
clocking cb @(posedge clk);
	input #1step req; //sampled immediately before the positive clock edge
endclocking
*/

//Inputs with explicit #0 skew will be sampled at the same time as their corresponding clocking event, 
//  but in the Observed region to avoid race conditions. 
//Similarly, outputs with no skew or explicit #0 will be driven at the same time as the clocking event, 
//  in the Re-NBA region.

//====Example

//Consider a simple design with inputs clk and req and drives an output signal gnt. 
//To keep things simple, lets just provide grant as soon as a request is received.

module des (input req, clk, output reg gnt);
  always @ (posedge clk)
    if (req)
      gnt <= 1;
  	else
      gnt <= 0;
endmodule

//To deal with the design port signals, let's create a simple interface called _if.

interface _if (input bit clk);
  logic gnt;
  logic req;

//Signal directions inside a clocking block are with respect to the testbench and not the DUT.
  clocking cb @(posedge clk);
    input #1ns gnt;
    output #5  req;
  endclocking
endinterface

//The next step is to drive inputs to the design so that it gives back the grant signal.

module tb;
  bit clk;

  // Create a clock and initialize input signal with respect to design
  always #10 clk = ~clk;
  initial begin
    clk <= 0;
    if0.cb.req <= 0;
  end

  // Instantiate the interface
  _if if0 (.clk (clk));

  // Instantiate the design
  des d0 ( .clk (clk),
           .req (if0.req),
           .gnt (if0.gnt));

  // Drive stimulus
  initial begin
    for (int i = 0; i < 10; i++) begin
      bit[3:0] delay = $random;
      repeat (delay) @(posedge if0.clk);
      if0.cb.req <= ~ if0.cb.req; //req is driven #5ns after the clock edge.
      // and design output gnt value will be sampled in the input of testbench side 1ns before the clock edge
    end
    #20 $finish;
  end
endmodule

//====Output skew (respect to tb, which is input to the design)

//lets tweak the interface to have three different clocking blocks each with a different output skew (with respect to tb, which is req,).
//Then let us drive req with each of the clocking blocks to see the difference.
interface _if (input bit clk);
  logic gnt;
  logic req;

  clocking cb_0 @(posedge clk);
    output #0  req;
    //If a default skew is not specified, then all input signals will be sampled #1step and output signlas driven 0ns after the specified event.
    // here input skew not specified, sampled at #1step, which is immediately before the positive clock edge, here is not right at pos edge, but a little previous at the pos edge
  endclocking

  clocking cb_1 @(posedge clk);
    output #2 req;
  endclocking

  clocking cb_2 @(posedge clk);
    output #5 req;
  endclocking
endinterface

module tb;
  // ... part of code same as before

  // Drive stimulus
  initial begin
    for (int i = 0; i < 3; i++) begin
      repeat (2) @(if0.cb_0); // repeat 2 posedge, happens right at the second posedge, which is 20ns for example
      case (i)
      	0 : if0.cb_0.req <= 1;
        // when req = 1 happens immediately at posdegde, for example at 20ns
        // gnt is sampled #1step, which is immediately before the pos edge,
        // so for design, although output change to 1 immediately at 20ns
        // but for gnt sampled at input of tb, gnt is sampled right beofre 20ns, let's say 19.9 ns
        // so gnt sampled at tb input is still 0
        // for tb, sampled gnt will become to 1 right before next pos edge, like 39.9 ns (right before 40) 
        1 : if0.cb_1.req <= 1;
        2 : if0.cb_2.req <= 1;
      endcase
      repeat (2) @ (if0.cb_0);
      // for case0, after immediately = 1 at 20ns, (posedge)
      // repeat 2 posedge
      // so the first posedge is 20 + 20 ns = 40ns
      // second is 40 + 20 ns = 60 ns
      // so req will become to 0 at 60 ns
      // so repeat (2) here is repeat another 2 posedge, not including posedge at 20ns
      if0.req <= 0;
    end
    #20 $finish;
  end

endmodule
//1st loop: req is driven #0ns from clock edge
//2nd loop: req is driven #2ns from clock edge
//3rd loop: req is driven #5ns from clock edge



//====Input skew (respect to tb, which is output of the design)
//To understand input skew, we'll change the DUT to simply provide a random value every #1ns just for our purpose.

module desnew (output reg[3:0] gnt);
    always #1 begin
        gnt <= $random;
        $display("[%0t] gnt=0x%0h", $time, gnt);
    end
endmodule

//The interface block will have different clocking block declarations like before each with a different input skew.

interface _ifnew (input bit clk);
  logic [3:0] gnt;

  clocking cb_0 @(posedge clk);
    input #0  gnt; //tb sample gnt right at pos edge, right at 5ns
  endclocking

  clocking cb_1 @(posedge clk);
    input #1step gnt; // tb sample gnt right before pos edge, likt 4.99ns
  endclocking

  clocking cb_2 @(posedge clk);
    input #1 gnt; //tb sample gnt before 1ns of pos edge, at 4ns
  endclocking

  clocking cb_3 @(posedge clk);
    input #2 gnt; // tb sample gnt at 3ns
  endclocking
endinterface

module tb1;
  bit clk;

  always #5 clk = ~clk; //period is 10ns now
  initial   clk <= 0;

  _ifnew if0 (.clk (clk));
  desnew d0  (.gnt (if0.gnt));

  initial begin
    fork
      begin
        @(if0.cb_0);
        $display ("cb_0.gnt = 0x%0h", if0.cb_0.gnt);
      end
      begin
        @(if0.cb_1);
        $display ("cb_1.gnt = 0x%0h", if0.cb_1.gnt);
      end
      begin
        @(if0.cb_2);
        $display ("cb_2.gnt = 0x%0h", if0.cb_2.gnt);
      end
      begin
        @(if0.cb_3);
        $display ("cb_3.gnt = 0x%0h", if0.cb_3.gnt);
      end
    join
    #10 $finish;
  end

endmodule

//output
// accoridng to code
// input #2, cb3 sample at first, at 3ns,
// input #1, cb2 sample next, at 4ns,
// input #1step, cb1 sample at like 4.99ns, right before pos edge
// input #0, cb0 sample at right 5ns, posedge
// display [4] are display value at end of 4ns, so from 3ns to 3.99ns, gnt are 0x9
// from 4ns to 4.99ns, gnt = 3
// at 4.99ns, gnt = display[5] = 3
// at 5ns, gnt = display[6] = 0xd
/*
# KERNEL: [1] gnt=0xx
# KERNEL: [2] gnt=0x4
# KERNEL: [3] gnt=0x1
# KERNEL: [4] gnt=0x9
# KERNEL: [5] gnt=0x3
# KERNEL: cb_0.gnt = 0xd
# KERNEL: cb_1.gnt = 0x3
# KERNEL: cb_2.gnt = 0x3
# KERNEL: cb_3.gnt = 0x9
# KERNEL: [6] gnt=0xd
# KERNEL: [7] gnt=0xd
# KERNEL: [8] gnt=0x5
# KERNEL: [9] gnt=0x2
# KERNEL: [10] gnt=0x1
# KERNEL: [11] gnt=0xd
# KERNEL: [12] gnt=0x6
# KERNEL: [13] gnt=0xd
# KERNEL: [14] gnt=0xd
*/