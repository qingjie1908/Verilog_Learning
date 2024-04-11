//A sequence is a simple building block in SystemVerilog assertions that can represent certain expressions to aid in creating more complex properties.

//====Simple Sequence

module tb;
  	bit a;
  	bit clk;

	// This sequence states that a should be high on every posedge clk
  	sequence s_a;
      @(posedge clk) a;
    endsequence

  	// When the above sequence is asserted, the assertion fails if 'a'
  	// is found to be not high on any posedge clk
  	assert property(s_a);


	always #10 clk = ~clk;

	initial begin
      for (int i = 0; i < 10; i++) begin
        a = $random; //assume a = 0 at 0 ns
        @(posedge clk); // advance 10ns

        // Assertion is evaluated in the preponed region and
        // use $display to see the value of 'a' in that region
        // so display are display a at 9.9ns, a=0 at this time
        $display("[%0t] a=%0d", $time, a);
        // strobe are display at 10ns, which could be 10.9ns, and a is 1 at this time
      end
      #20 $finish;
    end
endmodule
//output
/*
Time resolution is 1 ps
ERROR: Assertion failed. 
Time: 10 ns Started: 10 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[10000] a=0
[30000] a=1
[50000] a=1
[70000] a=1
[90000] a=1
[110000] a=1
[130000] a=1
ERROR: Assertion failed. 
Time: 150 ns Started: 150 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[150000] a=0
[170000] a=1
[190000] a=1
$finish called at time : 210 ns : File "/home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv" Line 26
*/

//====$rose
//The system task $rose is used to detect a positive edge of the given signal.
//In this case $rose of a indicates that a posedge of a is expected to be seen on every posedge of clk 
//Because SystemVerilog assertions evaluate in the preponed region, it can only detect value of the given signal in the preponed region
// When value of the signal is 0 in the first edge and then 1 on the next edge
//a positive edge is assumed to have happened
//So, this requires 2 clocks to be identified.
module tb;
  	bit a;
  	bit clk;

	// This sequence states that 'a' should rise on every posedge clk
  	sequence s_a;
      @(posedge clk) $rose(a);
    endsequence

  	// When the above sequence is asserted, the assertion fails if
  	// posedge 'a' is not found on every posedge clk
  	assert property(s_a);


	// Rest of the testbench stimulus
    always #10 clk = ~clk;

	initial begin
      for (int i = 0; i < 10; i++) begin
        a = $random;
        @(posedge clk);

        // Assertion is evaluated in the preponed region and
        // use $display to see the value of 'a' in that region
        $display("[%0t] a=%0d", $time, a);
      end
      #20 $finish;
    end
endmodule
//output
//different simulator has different output
//below is result from vivado
//as we can see vivado did not compare a at consecutive 2 posedge
//it will detect a rise of a at single posedge
/*
Time resolution is 1 ps
ERROR: Assertion failed. 
Time: 10 ns Started: 10 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[10000] a=0
[30000] a=1
ERROR: Assertion failed. 
Time: 50 ns Started: 50 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[50000] a=1
ERROR: Assertion failed. 
Time: 70 ns Started: 70 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[70000] a=1
ERROR: Assertion failed. 
Time: 90 ns Started: 90 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[90000] a=1
ERROR: Assertion failed. 
Time: 110 ns Started: 110 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[110000] a=1
ERROR: Assertion failed. 
Time: 130 ns Started: 130 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[130000] a=1
ERROR: Assertion failed. 
Time: 150 ns Started: 150 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[150000] a=0
[170000] a=1
ERROR: Assertion failed. 
Time: 190 ns Started: 190 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[190000] a=1
$finish called at time : 210 ns : File "/home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv" Line 27
*/

//====$fell

//The system task $fell is used to detect negative edge of the given signal. 

module tb;
  	bit a;
  	bit clk;

	// This sequence states that 'a' should rise on every posedge clk
  	sequence s_a;
      @(posedge clk) $fell(a);
    endsequence

  	// When the above sequence is asserted, the assertion fails if
  	// posedge 'a' is not found on every posedge clk
  	assert property(s_a);


	// Rest of the testbench stimulus
    always #10 clk = ~clk;

	initial begin
      for (int i = 0; i < 10; i++) begin
        a = $random;
        @(posedge clk);

        // Assertion is evaluated in the preponed region and
        // use $display to see the value of 'a' in that region
        $display("[%0t] a=%0d", $time, a);
      end
      #20 $finish;
    end
endmodule
//output vivado
/*
Time resolution is 1 ps
ERROR: Assertion failed. 
Time: 10 ns Started: 10 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[10000] a=0
ERROR: Assertion failed. 
Time: 30 ns Started: 30 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[30000] a=1
ERROR: Assertion failed. 
Time: 50 ns Started: 50 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[50000] a=1
ERROR: Assertion failed. 
Time: 70 ns Started: 70 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[70000] a=1
ERROR: Assertion failed. 
Time: 90 ns Started: 90 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[90000] a=1
ERROR: Assertion failed. 
Time: 110 ns Started: 110 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[110000] a=1
ERROR: Assertion failed. 
Time: 130 ns Started: 130 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[130000] a=1
[150000] a=0
ERROR: Assertion failed. 
Time: 170 ns Started: 170 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[170000] a=1
ERROR: Assertion failed. 
Time: 190 ns Started: 190 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:12
[190000] a=1
$finish called at time : 210 ns : File "/home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv" Line 27
*/

//====$stable

module tb;
  	bit a;
  	bit clk;

	// This sequence states that 'a' should be stable on every clock
	// and should not have posedge/negedge at any posedge clk
  	sequence s_a;
      @(posedge clk) $stable(a);
    endsequence

  	// When the above sequence is asserted, the assertion fails if
  	// 'a' toggles at any posedge clk
  	assert property(s_a);


	// Rest of the testbench stimulus
    always #10 clk = ~clk;

	initial begin
      for (int i = 0; i < 10; i++) begin
        a = $random;
        @(posedge clk);

        // Assertion is evaluated in the preponed region and
        // use $display to see the value of 'a' in that region
        $display("[%0t] a=%0d", $time, a);
      end
      #20 $finish;
    end
endmodule
//output
/*
Time resolution is 1 ps
[10000] a=0
ERROR: Assertion failed. 
Time: 30 ns Started: 30 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:13
[30000] a=1
[50000] a=1
[70000] a=1
[90000] a=1
[110000] a=1
[130000] a=1
ERROR: Assertion failed. 
Time: 150 ns Started: 150 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:13
[150000] a=0
ERROR: Assertion failed. 
Time: 170 ns Started: 170 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:13
[170000] a=1
[190000] a=1
$finish called at time : 210 ns : File "/home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv" Line 28
*/