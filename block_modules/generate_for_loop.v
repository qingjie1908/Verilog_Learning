//A generate block allows to multiply module instances or perform conditional instantiation of any module.
//It provides the ability for the design to be built based on Verilog parameters.

// Design for a half-adder
module ha ( input   a, b,
            output  sum, cout);

  assign sum  = a ^ b;
  assign cout = a & b;
  //initial $display("this is half adder");
endmodule

// A top level design that contains N instances of half adder
module my_design
	#(parameter N=4)
		(	input [N-1:0] a, b,
			output [N-1:0] sum, cout);

	// Declare a temporary loop variable to be used during
	// generation and won't be available during simulation
	genvar i;

	// Generate for loop to instantiate N times
	generate
		for (i = 0; i < N; i = i + 1) begin
          ha u0 (a[i], b[i], sum[i], cout[i]);
		end
	endgenerate
endmodule

module tb;
    parameter N = 2;
    reg  [N-1:0] a, b;
    wire [N-1:0] sum, cout;

    // Instantiate top level design with N=2 so that it will have 2
    // separate instances of half adders and both are given two separate
    // inputs
    my_design #(.N(N)) md( .a(a), .b(b), .sum(sum), .cout(cout));

    initial begin
        a <= 0;
        b <= 0;

        $monitor ("a=0x%0h b=0x%0h sum=0x%0h cout=0x%0h", a, b, sum, cout);

        #10 a <= 'h2;
                b <= 'h3;
        #20 b <= 'h4;
        #10 a <= 'h5;
    end
endmodule

//output:
/*
a=0x0 b=0x0 sum=0x0 cout=0x0
a=0x2 b=0x3 sum=0x1 cout=0x2
a=0x2 b=0x0 sum=0x2 cout=0x0
a=0x1 b=0x0 sum=0x1 cout=0x0
*/