// dff is the name of this module
module dff (input  d,
                    rstn,
                    clk,
            output reg q);
    // reg q; redeclaration, wrong

    always @(posedge clk) begin
        if (!rstn)
            q <= 0;
        else
            q <= d;
    end
endmodule