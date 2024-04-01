//Output of module has to be of type wire in order to connect with the output port of a primitive.

module mux_2x1
(
    input a, b, sel,
    output out
);
wire sel_n;
wire out_0;

not(sel_n, sel);
and(out_0, a, sel);
and(out_1, b, sel_n);

or(out, out_0, out_1);
    
endmodule

module tb;
    reg a, b, sel;
    wire out;
    integer i;

    mux_2x1 u0(.a(a), .b(b), .sel(sel), .out(out));

    initial begin
        {a, b, sel} = 0;
        $monitor("[%0t] a=%0b b=%0b sel=%0b out=%0b", $time, a, b, sel, out);

        for(i = 0; i<8; i = i + 1)
            #1 {a, b, sel} = i;
    end
    
endmodule

//output
/*
testbench.sv:15: warning: implicit definition of wire 'out_1'.
[0] a=0 b=0 sel=0 out=0
[2] a=0 b=0 sel=1 out=0
[3] a=0 b=1 sel=0 out=1
[4] a=0 b=1 sel=1 out=0
[5] a=1 b=0 sel=0 out=0
[6] a=1 b=0 sel=1 out=1
[7] a=1 b=1 sel=0 out=1
[8] a=1 b=1 sel=1 out=1
Done
*/