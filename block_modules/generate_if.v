// Design #1: Multiplexer design uses an "assign" statement to assign
// out signal
module mux_assign ( input a, b, sel,
                   output out);
  assign out = sel ? a : b;

  // The initial display statement is used so that
  // we know which design got instantiated from simulation
  // logs
  initial
  	$display ("mux_assign is instantiated");
endmodule

// Design #2: Multiplexer design uses a "case" statement to drive
// out signal
module mux_case (input a, b, sel,
                 output reg out);
  always @ (a or b or sel) begin
  	case (sel)
    	0 : out = a;
   	 	1 : out = b;
  	endcase
  end

  // The initial display statement is used so that
  // we know which design got instantiated from simulation
  // logs
  initial
    $display ("mux_case is instantiated");
endmodule

// Top Level Design: Use a parameter to choose either one
module my_design (	input a, b, sel,
         			output out);
  parameter USE_CASE = 0;

  // Use a "generate" block to instantiate either mux_case
  // or mux_assign using an if else construct with generate
  generate
  	if (USE_CASE)
      mux_case mc (.a(a), .b(b), .sel(sel), .out(out));
    else
      mux_assign ma (.a(a), .b(b), .sel(sel), .out(out));
  endgenerate

endmodule

module tb;
	// Declare testbench variables
  reg a, b, sel;
  wire out;
  integer i;

  // Instantiate top level design and set USE_CASE parameter to 1 so that
  // the design using case statement is instantiated
  my_design #(.USE_CASE(1)) u0 ( .a(a), .b(b), .sel(sel), .out(out));

  initial begin
  	// Initialize testbench variables
  	a <= 0;
    b <= 0;
    sel <= 0;

    // Assign random values to DUT inputs with some delay
    for (i = 0; i < 5; i = i + 1) begin
      #10 a <= $random;
      	  b <= $random;
          sel <= $random;
      $display ("i=%0d a=0x%0h b=0x%0h sel=0x%0h out=0x%0h", i, a, b, sel, out);
    end
  end
endmodule

//output:
/*
mux_case is instantiated
i=0 a=0x0 b=0x0 sel=0x0 out=0x0
i=1 a=0x0 b=0x1 sel=0x1 out=0x1
i=2 a=0x1 b=0x1 sel=0x1 out=0x1
i=3 a=0x1 b=0x0 sel=0x1 out=0x0
i=4 a=0x1 b=0x0 sel=0x1 out=0x0
*/