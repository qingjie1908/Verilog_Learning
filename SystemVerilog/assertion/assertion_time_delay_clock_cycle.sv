//simple boolean expressions were checked on every clock edge
//But sequential checks take several clock cycles to complete and the time delay is specified by ## sign.

//====## Operator
//If a is not high on any given clock cycle, the sequence starts and fails on the same cycle.
//However, if a is high on any clock, the assertion starts and succeeds if b is high 2 clocks later. It fails if b is low 2 clocks later.

module tb;
  bit a, b;
  bit clk;

  // This is a sequence that says 'b' should be high 2 clocks after
  // 'a' is found high. The sequence is checked on every positive
  // edge of the clock which ultimately ends up having multiple
  // assertions running in parallel since they all span for more
  // than a single clock cycle.
  sequence s_ab;
    @(posedge clk) a ##2 b;
  endsequence

  // Print a display statement if the assertion passed
  assert property(s_ab)
  	$display ("[%0t] Assertion passed !", $time);

  always #10 clk = ~clk;

  initial begin
    for (int i = 0; i < 10; i++) begin
      @(posedge clk);
      a <= $random;
      b <= $random;

      $display("[%0t] a=%b b=%b", $time, a, b);
    end

    #20 $finish;
  end
endmodule

//output from Aldec Rivera
/*
# KERNEL: [10] a=0 b=0
# ASSERT: Error: ASRT_0005 testbench.sv(15): Assertion FAILED at time: 10ns, scope: tb, start-time: 10ns
# KERNEL: [30] a=0 b=1
# ASSERT: Error: ASRT_0005 testbench.sv(15): Assertion FAILED at time: 30ns, scope: tb, start-time: 30ns
# KERNEL: [50] a=1 b=1
# KERNEL: [70] a=1 b=1
# KERNEL: [90] a=1 b=0
# ASSERT: Error: ASRT_0005 testbench.sv(15): Assertion FAILED at time: 90ns, scope: tb, start-time: 50ns
# KERNEL: [110] a=1 b=1
# KERNEL: [110] Assertion passed !
# KERNEL: [130] a=0 b=1
# ASSERT: Error: ASRT_0005 testbench.sv(15): Assertion FAILED at time: 130ns, scope: tb, start-time: 130ns
# KERNEL: [130] Assertion passed !
# KERNEL: [150] a=1 b=0
# ASSERT: Error: ASRT_0005 testbench.sv(15): Assertion FAILED at time: 150ns, scope: tb, start-time: 110ns
# KERNEL: [170] a=1 b=0
# KERNEL: [190] a=1 b=0
# ASSERT: Error: ASRT_0005 testbench.sv(15): Assertion FAILED at time: 190ns, scope: tb, start-time: 150ns
# RUNTIME: Info: RUNTIME_0068 testbench.sv (29): $finish called.
# KERNEL: Time: 210 ns,  Iteration: 0,  Instance: /tb,  Process: @INITIAL#20_1@.
# KERNEL: stopped at time: 210 ns
*/

//output from vivado, same, just error occurred first before display value
/*
Time resolution is 1 ps
ERROR: Assertion failed. 
Time: 10 ns Started: 10 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[10000] a=0 b=0
ERROR: Assertion failed. 
Time: 30 ns Started: 30 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[30000] a=0 b=1
[50000] a=1 b=1
[70000] a=1 b=1
ERROR: Assertion failed. 
Time: 90 ns Started: 50 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[90000] a=1 b=0

Time: 110 ns Started: 70 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[110000] Assertion passed !
[110000] a=1 b=1

Time: 130 ns Started: 90 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[130000] Assertion passed !
ERROR: Assertion failed. 
Time: 130 ns Started: 130 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[130000] a=0 b=1
ERROR: Assertion failed. 
Time: 150 ns Started: 110 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[150000] a=1 b=0
[170000] a=1 b=0
ERROR: Assertion failed. 
Time: 190 ns Started: 150 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:15
[190000] a=1 b=0
$finish called at time : 210 ns : File "/home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv" Line 29
*/