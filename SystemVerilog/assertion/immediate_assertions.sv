//Immediate assertions are executed based on simulation event semantics and are required to be specified in a procedural block.
//It is treated the same way as the expression in a if statement during simulation.

//The immediate assertion will pass if the expression holds true at the time when the statement is executed
//and will fail if the expression evaluates to be false (X, Z or 0). 

//These assertions are intended for use in simulation and is not suitable for formal verification
//It can be used in both RTL code and testbench to flag errors in simulations.

//Syntax

// Simple assert statement
assert(<expression>);

// Assert statement with statements to be executed for pass/fail conditions
assert(<expression>) begin
	// If condition is true, execute these statements
end else begin
	// If condition is false, execute these statements
end

// Optionally give name for the assertion
[assert_name] : assert(<expression>);

//====Immediate Assertion in Design
module my_des (my_if _if);

  always @ (posedge _if.clk) begin
    if (_if.push) begin
    	// Immediate assertion and ensures that
    	// fifo is not full when push is 1
    	a_push: assert (!_if.full) begin
      		$display("[PASS] push when fifo not full");
    	end else begin
      		$display("[FAIL] push when fifo full !");
    	end
  	end

    if (_if.pop) begin
    	// Immediate assertion to ensure that fifo is not
    	// empty when pop is 1
    	a_pop: assert (!_if.empty) begin
      		$display ("[PASS] pop when fifo not empty");
    	end else begin
      		$display ("[FAIL] pop when fifo empty !");
    	end
    end
  end
endmodule

interface my_if(input bit clk);
  logic pop;
  logic push;
  logic empty;
  logic full;
endinterface

module tb;
  bit clk;
  always #10 clk <= ~clk;

  my_if _if (clk);
  my_des u0 (.*);

  initial begin
    for (int i = 0; i < 5; i++) begin
      _if.push  <= $random;
      _if.pop   <= $random;
      _if.empty <= $random;
      _if.full  <= $random;
      $strobe("[%0t] push=%0b full=%0b pop=%0b empty=%0b",
              $time, _if.push, _if.full, _if.pop, _if.empty);
      @(posedge clk);
    end
    #10 $finish;
  end
endmodule
//output
/*
# KERNEL: [0] push=0 full=1 pop=1 empty=1
# KERNEL: [FAIL] pop when fifo empty !
# KERNEL: [10] push=1 full=0 pop=1 empty=1
# KERNEL: [PASS] push when fifo not full
# KERNEL: [FAIL] pop when fifo empty !
# KERNEL: [30] push=1 full=1 pop=1 empty=0
# KERNEL: [FAIL] push when fifo full !
# KERNEL: [PASS] pop when fifo not empty
# KERNEL: [50] push=1 full=0 pop=0 empty=1
# KERNEL: [PASS] push when fifo not full
# KERNEL: [70] push=1 full=1 pop=0 empty=1
# KERNEL: [FAIL] push when fifo full !
# RUNTIME: Info: RUNTIME_0068 testbench.sv (50): $finish called.
# KERNEL: Time: 100 ns,  Iteration: 0,  Instance: /tb,  Process: @INITIAL#40_2@.
# KERNEL: stopped at time: 100 ns
*/

//====Immediate Assertion in Testbench
//this example has a constraint error and randomization will fail.
//But, the failure will be displayed as a warning message and if the user is not careful enough the test may display incorrect behavior and may even appear to pass.
class Packet;
  rand bit [7:0] addr;

  constraint c_addr { addr > 5; addr < 3; }
endclass

module tb;
  initial begin
    Packet m_pkt = new();

    m_pkt.randomize();
  end
endmodule

//immediate assertion can be placed on the randomization method call to ensure that the return value is always 1,
//indicating the randomization is successful
//If the assertion fails, it prompts the user to first look at the failure thereby reducing debug efforts.

class Packet;
  rand bit [7:0] addr;

  constraint c_addr { addr > 5; addr < 3; }
endclass

module tb;
  initial begin
    Packet m_pkt = new();

    assert(m_pkt.randomize());
  end
endmodule
//Simulator assigns a generated name for the assertion if the user has not specified one.
//output
//here we can see if without assertion, we only the warning, may ignore this
//assert will give us error
/*
# RCKERNEL: Warning: RC_0024 testbench.sv(11): Randomization failed. The condition of randomize call cannot be satisfied.
# RCKERNEL: Info: RC_0109 testbench.sv(11): ... after reduction m_pkt.addr to 2'(m_pkt.addr)
# RCKERNEL: Info: RC_0103 testbench.sv(11): ... the following condition cannot be met: (5<m_pkt.addr)
# RCKERNEL: Info: RC_1007 testbench.sv(1): ... see class 'Packet' declaration.
# ASSERT: Error: ASRT_0301 testbench.sv(11): Immediate assert condition (m_pkt.randomize()) FAILED at time: 0ns, scope: tb
*/