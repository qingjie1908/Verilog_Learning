//There are ways to group a set of statements together that are syntactically equivalent to a single statement and are known as block statements.
//There are two kinds of block statements: sequential and parallel.

// Statements are wrapped using begin and end keywords and will be executed sequentially in the given order,

module design0;
	//bit [31:0] data; bit is availble in systemverilog, which file extension is .sv
    reg [31:0] data;

	// "initial" block starts at time 0
	initial begin

		// After 10 time units, data becomes 0xfe
		#10   data = 8'hfe;
		$display ("[Time=%0t] data=0x%0h", $time, data);

		// After 20 time units, data becomes 0x11
		#20   data = 8'h11;
		$display ("[Time=%0t] data=0x%0h", $time, data);
	end
endmodule

//Parallel
//A parallel block can execute statements concurrently and delay control can be used to provide time-ordering of the assignments. 
//Statements are launched in parallel by wrapping them within the fork and join keywords.

module design1();
    reg [7:0] data;
    initial begin
        #10   data = 8'hfe; // executed at 10ns
        fork
        #20 data = 8'h11;   // executed at 10 + 20 = 30ns
        #10 data = 8'h00;   // executed at 10 + 10 = 20ns, so data will be updated to h00 first
        join
    end
endmodule

module design2();
    reg [7:0] data;
    initial begin
	#10 data = 8'hfe; // data = 0xfe at 10ns
        fork
            #10 data = 8'h11; // data = 0x11 at 10 + 10 = 20ns
            begin
                #20 data = 8'h00; // data = 0x00 at 10 + 20 = 30ns
                #30 data = 8'haa; // data = 0xaa at 10 + 20 +30 = 60ns
            end
        join
    end
endmodule

// Both sequential and parallel blocks can be named by adding : name_of_block after the keywords begin and fork. 
// By doing so, the block can be referenced in a disable statement.