module mux_2x1 (input   a,
                        b,
                        sel,
                output  reg c);
    always @ (a or b or sel) begin
        c = sel ? a : b;
    end
endmodule

module tb();
    // decalre variables
    reg a, b, sel;
    wire c; // since  output must be driven continuosly, so need type wire, not type reg
    integer i;

    //instantiation
    mux_2x1 mux0(.a(a), .b(b), .sel(sel), .c(c));

    //initial input
    initial begin
        a = 0;
        b = 0;
        sel = 0;

        //$monitor change and output
        $monitor("a=%0b b=%0b sel=%0b c=%0b", a, b, sel, c);

        //differrent input
        for(i = 0; i < 8; i = i + 1) begin 
            {a, b, sel} = i; 
            #10; // delay is necessary otherwise output only have last combination a=1 b=1 sel=1 c=1
        end
    end
endmodule

//output:
/*
a=0 b=0 sel=0 c=0
a=0 b=0 sel=1 c=0
a=0 b=1 sel=0 c=1
a=0 b=1 sel=1 c=0
a=1 b=0 sel=0 c=0
a=1 b=0 sel=1 c=1
a=1 b=1 sel=0 c=1
a=1 b=1 sel=1 c=1
*/