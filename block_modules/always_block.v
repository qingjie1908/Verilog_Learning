// An always block is one of the procedural blocks in Verilog. Statements inside an always block are executed sequentially.
/*
always @ (event)
	[statement]

always @ (event) begin
	[multiple statements]
end
*/

// The always block is executed at some particular event. The event is defined by a sensitivity list.
// A sensitivity list is the expression that defines when the always block should be executed and is specified after the @ operator within parentheses ( ). 
// This list may contain either one or a group of signals whose value change will execute the always block.

// Execute always block whenever value of "a" or "b" change
/*
always @ (a or b) begin
	[statements]
end
*/

// always block is started at time 0 units
// But when is it supposed to be repeated ?
// There is no time control, and hence it will stay and
// be repeated at 0 time units only. This continues
// in a loop and simulation will hang !
// always clk = ~clk;

// Even if the sensitivity list is empty, there should be some other form of time delay. 
// Simulation time is advanced by a delay statement within the always construct as shown below. 
//Now, the clock inversion is done after every 10 time units.
// always #10 clk = ~clk;

module tff (input  		d,
						clk,
						rstn,
			output reg 	q);

	always @ (posedge clk or negedge rstn) begin
		if (!rstn)
			q <= 0;
		else
			if (d)
				q <= ~q;
			else
				q <= q;
	end
endmodule

// First if block checks value of active-low reset rstn. 
// At negative edge of the signal, its value is 0.
// If value of rstn is 0, then it means reset is applied and output should be reset to default value of 0
// The case where value of rstn is 1 is not considered because the current event is negative edge of the rstn

// An always block can also be used in the design of combinational blocks.
// Output signal is declared as type reg in the module port list because it is used in a procedural block. 
// All signals used in a procedural block should be declared as type reg.

module combo (	input 	a,
      			input	b,
              	input	c,
              	input	d,
  	            output reg o);

  always @ (a or b or c or d) begin
    o <= ~((a & b) | (c^d));
  end

endmodule


// Template #1: Use for combinational logic, all inputs mentioned in
// sensitivity list ensures that it infers a combo block
/*
always @ (all_inputs) begin
	// Combinational logic
end

// Template #2: Use of a if condition without else can cause a latch
// because the previous value has to be held since new value is not
// defined by a missing else clause
always @ (all_inputs) begin
	if (enable) begin
		// latch value assignments
	end
end

// Template #3: Use clock in sensitivity list for sequential elements
always @ (posedge clk) begin
	// behavior to do at posedge clock
end

// Template #4: Use clock and async reset in sensitivity list
always @ (posedge clk or negedge resetn) begin
	if (! resetn) begin
		// behavior to do during reset
	end else begin
		// behavior when not in reset
	end
end
*/