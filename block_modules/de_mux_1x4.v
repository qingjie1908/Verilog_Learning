module demux_1x4 (input f, // type scalar
                input   [1:0] sel, // different type vector need to add input 
                output reg a, b, c, d); // reg is necessary, reg signals can only be driven in procedural blocks like initial and always, and cannot use assign, assign only for wire
    always @ (f or sel) begin
        a = f & ~sel[1] & ~sel[0];
        b = f & ~sel[1] & sel[0];
        c = f & sel[1] & ~sel[0];
        d = f & sel[1] & sel[0];
    end
    // or equal as
    // assign a = f & ~sel[1] & ~sel[0]; in this case, a,b,c,d should decalre as wire type
endmodule

module tb();
    //declare vairables
    reg f;
    reg [1:0]sel;
    wire a, b, c, d;
    integer i;

    //instantiation
    demux_1x4 dmux0(.f(f), .sel(sel), .a(a), .b(b), .c(c), .d(d));

    //initial input
    initial begin
        f <= 0;
        sel <= 0;

        //monitor
        $monitor("f=%2b, sel=%2b, a=%2b, b=%2b, c=%2b, d=%2b", f, sel, a, b, c, d);

        for(i = 0; i < 8; i = i + 1) begin
            {f, sel} = i;
            #10;
        end
    end
endmodule