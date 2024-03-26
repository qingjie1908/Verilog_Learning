module jk_ff (  input   j,
                input   k,
                input   clk,
                input   rstn,
                output  reg q);
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            q <= 0;
        end
        else begin 
            q <= (j & ~q) | (~k & q);
        end
    end   
endmodule

module tb();
    reg j;
    reg k;
    reg clk;
    reg rstn;
    wire q; // type wire because it is connected to an output of the design which will be actively driving it
    //All other inputs to the design are of type reg so that they can be driven within a procedural block such as initial
    integer i;
    reg [2:0] dly;

    // start the clcok
    always #10 clk = ~clk;

    //instantiation the design
    jk_ff u0(.j(j), .k(k), .clk(clk), .rstn(rstn), .q(q));

    //write the stimulus
    initial begin 
        {j, k, clk, rstn} <= 0;
        #10 rstn <= 1;

        for(i = 0; i < 10; i = i +1) begin 
            dly = $random;
            #(dly) j <= $random;
            #(dly) k <= $random;
        end

        #20 $finish;
    end
endmodule