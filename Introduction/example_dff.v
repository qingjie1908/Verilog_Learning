// dff is the name of this module
module dff (input  d,
                    rsrn,
                    clk,
            output q);
    reg q;

    always @(posedge clk) begin
        if (!rstn)
            q <= 0;
        else
            q <= d;
    end
endmodule