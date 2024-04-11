//The behavior of a system can be written as an assertion that should be true at all times.
//Hence assertions are used to validate the behavior of a system defined as properties, 
//and can also be used in functional coverage.

//====What are properties of a design ?

//If a property of the design that is being checked for by an assertion does not behave in the expected way, the assertion fails.
//For example, assume the design requests for grant and expects to receive an ack within the next four cycles. 
//But if the design gets an ack on the fifth cycle, the property that an ack should be returned within 4 clocks is violated and the assertion fails.

//If a property of the design that is being checked for by an assertion is forbidden from happening, the assertion fails. 
//For example, assume a small processor decodes instructions read from memory,
//encounters an unknown instruction and results in a fatal error.
//If such a scenario is never expected from the design, 
//the property of the design that only valid instructions can be read from memory is violated and the assertion fails.

//As evident from the two examples above, properties of a given design is checked for by writing SystemVerilog assertions.

//====Why do we need assertions ?

//An assertion is nothing but a more concise representation of a functional checker. 
//The functionality represented by an assertion can also be written as a SystemVerilog task or checker that involves more line of code.
//Some disadvantages of doing so are listed below:
/*
SystemVerilog is verbose and difficult to maintain and scale code with the number of properties
Being a procedural language, it is difficult to write checkers that involve many parallel events in the same period of time
*/
// A property written in Verilog/SystemVerilog
always @ (posedge clk) begin
	if (!(a && b))
		$display ("Assertion failed");
end

//SystemVerilog Assertions is a declarative language used to specify temporal conditions, and is very concise and easier to maintain.
// The property above written in SystemVerilog Assertions syntax
assert property(@(posedge clk) a && b);

//====Types of Assertion Statements

//An assertion statement can be of the following types:
/*
Type	Description
assert	To specify that the given property of the design is true in simulation
assume	To specify that the given property is an assumption and used by formal tools to generate input stimulus
cover	To evaluate the property for functional coverage
restrict	To specify the property as a constraint on formal verification computations and is ignored by simulators
*/

//====Building Blocks of Assertions

//====Sequence

//A sequence of multiple logical events typically form the functionality of any design. 
//These events may span across multiple clocks or exist for just a single clock cycle.
//To keep things simple, smaller events can be depicted using simple assertions which can then be used to build more complex behavior patterns.

// Sequence syntax
sequence <name_of_sequence>
  <test expression>
endsequence

// Assert the sequence
assert property (<name_of_sequence>);

//====Property


//These events can be represented as a sequence 
    //and a number of sequences can be combined to create more complex sequences or properties.

//It is necessary to include a clocking event inside a sequence or property in order to assert it.

// Property syntax
property <name_of_property>
  <test expression> or
  <sequence expressions>
endproperty

// Assert the property
assert property (<name_of_property>);

//====There are two kinds of assertions - Immediate and Concurrent.

//====Immediate Assertion

//Immediate assertions are executed like a statement in a procedural block and follow simulation event semantics. 
//These are used to verify an immediate property during simulation.
always @ (<some_event>) begin
	...
	// This is an immediate assertion executed only
	// at this point in the execution flow
	$assert(!fifo_empty);      // Assert that fifo is not empty at this point
	...
end

//====Concurrent Assertions

//====Concurrent assertions are based on clock semantics and use sampled values of their expressions. 
//Circuit behavior is described using SystemVerilog properties that gets evaluated everytime on the given clock 
//and a failure in simulation indicates that the described functional behavior got violated.

// Define a property to specify that an ack should be
// returned for every grant within 1:4 clocks
property p_ack;
	@(posedge clk) gnt ##[1:4] ack;
endproperty

assert property(p_ack);    // Assert the given property is true always

//====Steps to create assertions

//Following are the steps to create assertions:
/*
Step 1: Create boolean expressions
Step 2: Create sequence expressions
Step 3: Create property
Step 4: Assert property
*/

module tb;
  bit a, b, c, d;
  bit clk;

  always #10 clk = ~clk;

  initial begin
    for (int i = 0; i < 20; i++) begin
      {a, b, c, d} = $random;
      $display("%0t a=%0d b=%0d c=%0d d=%0d", $time, a, b, c, d);
      @(posedge clk);
    end
    #10 $finish;
  end

  //sequence s_ab validates that b is high the next clock when a is high,
  //The signal b will be active after 1 clock cycle delay, once a is active.
  sequence s_ab;
    a ##1 b;
  endsequence

  //sequence s_cd validates that d is high 2 clocks after c is found high.
  sequence s_cd;
    c ##2 d;
  endsequence

  property p_expr;
    @(posedge clk) s_ab ##1 s_cd;
  endproperty

  assert property (p_expr);
endmodule
//output
/*
# KERNEL: 0 a=0 b=1 c=0 d=0
# KERNEL: 10 a=0 b=0 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 10ns, scope: tb, start-time: 10ns
# KERNEL: 30 a=1 b=0 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 30ns, scope: tb, start-time: 30ns
# KERNEL: 50 a=0 b=0 c=1 d=1
# KERNEL: 70 a=1 b=1 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 70ns, scope: tb, start-time: 70ns
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 70ns, scope: tb, start-time: 50ns
# KERNEL: 90 a=1 b=1 c=0 d=1
# KERNEL: 110 a=0 b=1 c=0 d=1
# KERNEL: 130 a=0 b=0 c=1 d=0
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 130ns, scope: tb, start-time: 130ns
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 130ns, scope: tb, start-time: 90ns
# KERNEL: 150 a=0 b=0 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 150ns, scope: tb, start-time: 150ns
# KERNEL: 170 a=1 b=1 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 170ns, scope: tb, start-time: 170ns
# KERNEL: 190 a=0 b=1 c=1 d=0
# KERNEL: 210 a=1 b=1 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 210ns, scope: tb, start-time: 210ns
# KERNEL: 230 a=1 b=1 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 230ns, scope: tb, start-time: 190ns
# KERNEL: 250 a=1 b=1 c=0 d=0
# KERNEL: 270 a=1 b=0 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 270ns, scope: tb, start-time: 230ns
# KERNEL: 290 a=0 b=1 c=1 d=0
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 290ns, scope: tb, start-time: 270ns
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 290ns, scope: tb, start-time: 250ns
# KERNEL: 310 a=0 b=1 c=0 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 310ns, scope: tb, start-time: 310ns
# KERNEL: 330 a=1 b=0 c=1 d=0
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 330ns, scope: tb, start-time: 330ns
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 330ns, scope: tb, start-time: 290ns
# KERNEL: 350 a=0 b=1 c=0 d=1
# KERNEL: 370 a=0 b=1 c=1 d=1
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 370ns, scope: tb, start-time: 370ns
# ASSERT: Error: ASRT_0005 testbench.sv(30): Assertion FAILED at time: 390ns, scope: tb, start-time: 390ns
# RUNTIME: Info: RUNTIME_0068 testbench.sv (13): $finish called.
# KERNEL: Time: 400 ns,  Iteration: 0,  Instance: /tb,  Process: @INITIAL#7_1@.
# KERNEL: stopped at time: 400 ns
*/