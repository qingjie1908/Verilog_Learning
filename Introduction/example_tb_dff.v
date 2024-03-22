module tb
    // 1. declare the input/output varables to drive the design
    reg tb_clk;
    reg tb_d;
    reg tb_rstn;
    reg tb_q;

    // 2. Create an instance of the design
    // This is called design instantiation
    dff dff0(   .clk    (tb_clk), // connect design instance dff0 clock input with TB signal
                .d      (tb_d),
                .rstn   (tb_rstn),
                .q      (tb_q))

    // 3. The following is an example of a stimulus
    // Here we drive the signals tb_* with certain values
    // Since these tb_* signals are connected to the design inputs
    // the design will be driven with the values in tb_*

    initial begin
        tb_rsnt     <=  1'b0;
        tb_clk      <=  1'b0;
        tb_d        <=  1'b0;
    end
endmodule