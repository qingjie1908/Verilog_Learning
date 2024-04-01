//ifdef, ifndef
//Conditional compilation can be achieved with Verilog `ifdef and `ifndef keywords. 
//These keywords can appear anywhere in the design and can be nested one inside the other.

//The keyword `ifdef simply tells the compiler to include the piece of code until the next `else or `endif if the given macro called FLAG is defined using a `define directive.

/*
// Style #1: Only single `ifdef
`ifdef <FLAG>
	// Statements
`endif

// Style #2: `ifdef with `else part
`ifdef <FLAG>
	// Statements
`else
	// Statements
`endif

// Style #3: `ifdef with additional ifdefs
`ifdef <FLAG1>
	// Statements
`elsif <FLAG2>
	// Statements
`elsif <FLAG3>
	// Statements
`else
	// Statements
`endif
*/

module my_design (input clk, d,
`ifdef INCLUDE_RSTN
                  input rstn,
`endif
                  output reg q);

  always @ (posedge clk) begin
`ifdef INCLUDE_RSTN
    if (!rstn) begin
      q <= 0;
    end else
`endif
    begin
      q <= d;
    end
  end
endmodule

module tb;
  reg clk, d, rstn;
  wire q;
  reg [3:0] delay;

  my_design u0 ( .clk(clk), .d(d),
`ifdef INCLUDE_RSTN
                .rstn(rstn),
`endif
                .q(q));

  always #10 clk = ~clk;

  initial begin
    integer i;

    {d, rstn, clk} <= 0;

	#20 rstn <= 1;
    for (i = 0 ; i < 20; i=i+1) begin
      delay = $random;
      #(delay) d <= $random;
      $display("Time[%0t] delay=%0d d=%0d", $time, delay, d);
    end

    #20 $finish;
  end
endmodule

//Note that by default, rstn will not be included during compilation of the design 
//and hence it will not appear in the portlist. 
//However if a macro called INCLUDE_RSTN is either defined in any Verilog file that is part of the compilation list of files 
//or passed through the command line to the compiler, rstn will be included in compilation and the design will have it.