module lshift_4b_reg (  input   d,
                        input   clk,
                        input   rstn,
                        output  reg [3:0] out);
    always @(posedge clk) begin 
        if (!rstn) begin 
            out <= 0;
        end
        else begin 
            out <= {out[2:0], d}; // keep 3 LSB [2:0], shift to MSB, then concatenate input 1-bit d, 
        end
    end
endmodule

module tb();
    //declare varaible 
    reg d, clk, rstn;
    wire [3:0] out;
    integer i;

    //instantiation
    lshift_4b_reg u0(.d(d), .clk(clk), .rstn(rstn), .out(out));

    //clock setting
    always #10 clk = ~clk; // cycle is 20 time units
    // since always has no sensitivity list here, we need to add $finish at last

    //intial stimulus
    initial begin
        {d, clk, rstn} <= 0;

        #10 rstn <= 1;

        for(i = 0; i < 20; i = i + 1) begin 
            @(posedge clk) begin 
                d <= $random; // d will be random 1-bit 0 or 1
            end
        end

        #10 $finish; // $finish will terminate the program, $stop just suspend
    end

endmodule