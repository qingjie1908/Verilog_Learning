module dec_2x4 (
    input x, y, en,
    output a, b, c, d
);
    assign {a, b, c, d} = en ? 1 << {x, y} : 0;
    //if using gate_level
    /*
    not(nx, x);
    not(ny, y);
    and(d, en, nx, ny);
    and(c, en, nx, y);
    and(b, en, x, ny);
    and(a, en, x, y);
    */
endmodule

module tb (
);
    reg x, y, en;
    wire a, b, c, d;
    integer i;

    dec_2x4 u0(.x(x), .y(y), .en(en), .a(a), .b(b), .c(c), .d(d));

    initial begin
        {x, y, en} <= 0;
        $monitor("[%0t] x=%0b y=%0b en=%0b a=%0b b=%0b c=%0b d=%0b", $time, x, y, en, a, b, c, d);

        for(i = 0; i < 8; i = i + 1)
            #1 {x, y, en} <= i;
    end
    
endmodule

//output
/*
[0] x=0 y=0 en=0 a=0 b=0 c=0 d=0
[2] x=0 y=0 en=1 a=0 b=0 c=0 d=1
[3] x=0 y=1 en=0 a=0 b=0 c=0 d=0
[4] x=0 y=1 en=1 a=0 b=0 c=1 d=0
[5] x=1 y=0 en=0 a=0 b=0 c=0 d=0
[6] x=1 y=0 en=1 a=0 b=1 c=0 d=0
[7] x=1 y=1 en=0 a=0 b=0 c=0 d=0
[8] x=1 y=1 en=1 a=1 b=0 c=0 d=0
*/