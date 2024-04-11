//Concurrent assertions describe behavior that spans over simulation time and are evaluated only at the occurence of a clock tick.
//concurrent assertion statements can be specified in a module, interface or program block running concurrently with other statements. 
//Following are the properties of a concurrent assertion:
/*
Test expression is evaluated at clock edges based on values in sampled variables
Sampling of variables is done in the preponed region and evaluation of the expression is done in the observed region of the simulation scheduler.
It can be placed in a procedural, module, interface, or program block
It can be used in both dynamic and formal verification techniques
*/

//====example 1
// both signals a and b are expected to be high at the positive edge of clock for the entire simulation. 
//The assertion is expected to fail for all instances where either a or b is found to be zero.

module tb;
    bit a, b;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            a <= $random;
            b <= $random;
            $display("[%0t] a=%0b b=%0b", $time, a, b);
        end
        #10 $finish;
    end

  // This assertion runs for entire duration of simulation
  // Ensure that both signals are high at posedge clk
  assert property (@(posedge clk) a & b);

endmodule

//The assertion is executed on every positive edge of clk
//and evaluates the expression using values of variables in the preponed region,
//which is a delta cycle before given edge of clock
//means for example, assertion execured at 10ns (right at pos edge)
//the value of a and b will be taken at 9.9 ns (like 1# step before input, here is 1# step before assertion sampling)

//output
/*
[10000] a=0 b=0
ERROR: Assertion failed. 
Time: 10 ns Started: 10 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
[30000] a=0 b=1
ERROR: Assertion failed. 
Time: 30 ns Started: 30 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
[50000] a=1 b=1
[70000] a=1 b=1
[90000] a=1 b=0
ERROR: Assertion failed. 
Time: 90 ns Started: 90 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
[110000] a=1 b=1
[130000] a=0 b=1
ERROR: Assertion failed. 
Time: 130 ns Started: 130 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
[150000] a=1 b=0
ERROR: Assertion failed. 
Time: 150 ns Started: 150 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
[170000] a=1 b=0
ERROR: Assertion failed. 
Time: 170 ns Started: 170 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
[190000] a=1 b=0
ERROR: Assertion failed. 
Time: 190 ns Started: 190 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
$finish called at time : 200 ns : File "/home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv" Line 14
*/

//====example 2

module tb;
    bit a, b;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            a <= $random;
            b <= $random;
            $display("[%0t] a=%0b b=%0b", $time, a, b);
        end
        #10 $finish;
    end

  // This assertion runs for entire duration of simulation
  // Ensure that atleast 1 of the two signals is high on every clk
  assert property (@(posedge clk) a | b);

endmodule
//output
/*
Time resolution is 1 ps
[10000] a=0 b=0
ERROR: Assertion failed. 
Time: 10 ns Started: 10 ns Scope: /tb File: /home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv Line:19
[30000] a=0 b=1
[50000] a=1 b=1
[70000] a=1 b=1
[90000] a=1 b=0
[110000] a=1 b=1
[130000] a=0 b=1
[150000] a=1 b=0
[170000] a=1 b=0
[190000] a=1 b=0
$finish called at time : 200 ns : File "/home/user/verilog_learning/verilog_learning.srcs/sim_1/new/cov1.sv" Line 14
*/