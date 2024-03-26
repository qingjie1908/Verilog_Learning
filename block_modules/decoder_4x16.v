module dec_3x8 ( 	input 					en,
									input 	[3:0] 	in,
									output  [15:0] 	out);

	assign out = en ? 1 << in: 0; // bitwise shift left, 0000_0000_0000_0001, 1 can shift 0 to 15 bits since in is [3:0], so out have 16 values

    // if we want to use always, we need to declared out as reg, not wire
    // // reg is necessary, reg signals can only be driven in procedural blocks like initial and always, and cannot use assign, assign only for wire
    /*
    always @ (en or in) begin 
        out =  en ? 1 << in : 0;
    end
    */
endmodule

/*
Inputs are declared as reg and outputs as wire only in Verilog. In SystemVerilog, we use logic for 4-state simulation and bit for 2-state simulation.

In Verilog, inputs are declared as reg because they are variables which store values during simulation. The value is stored in the inputs of type reg till it is overwritten by some other value.

The datatype wire is used for outputs because outputs in the testbench are driven by the DUT (Device Under Test) continuously, and they don't store any value during simulation.

In SystemVerilog, declare a signal as wire only if you expect it to have multiple drivers.
*/

module tb;
  reg en;
  reg [3:0] in;
  wire [15:0] out;
  integer i;

  dec_3x8 u0 ( .en(en), .in(in), .out(out));

  initial begin
    en <= 0;
    in <= 0;

    $monitor("en=%0b in=0x%0h out=0x%16b time=%0t", en, in, out, $time); //0x16b, output has 16bits wide, in binary

    for (i = 0; i < 32; i = i + 1) begin
      {en, in} = i;
      #10;
    end
  end
endmodule

// run in
//output:
/*
en=0 in=0x0 out=0x0000000000000000 time=0
en=0 in=0x1 out=0x0000000000000000 time=10
en=0 in=0x2 out=0x0000000000000000 time=20
en=0 in=0x3 out=0x0000000000000000 time=30
en=0 in=0x4 out=0x0000000000000000 time=40
en=0 in=0x5 out=0x0000000000000000 time=50
en=0 in=0x6 out=0x0000000000000000 time=60
en=0 in=0x7 out=0x0000000000000000 time=70
en=0 in=0x8 out=0x0000000000000000 time=80
en=0 in=0x9 out=0x0000000000000000 time=90
en=0 in=0xa out=0x0000000000000000 time=100
en=0 in=0xb out=0x0000000000000000 time=110
en=0 in=0xc out=0x0000000000000000 time=120
en=0 in=0xd out=0x0000000000000000 time=130
en=0 in=0xe out=0x0000000000000000 time=140
en=0 in=0xf out=0x0000000000000000 time=150
en=1 in=0x0 out=0x0000000000000001 time=160
en=1 in=0x1 out=0x0000000000000010 time=170
en=1 in=0x2 out=0x0000000000000100 time=180
en=1 in=0x3 out=0x0000000000001000 time=190
en=1 in=0x4 out=0x0000000000010000 time=200
en=1 in=0x5 out=0x0000000000100000 time=210
en=1 in=0x6 out=0x0000000001000000 time=220
en=1 in=0x7 out=0x0000000010000000 time=230
en=1 in=0x8 out=0x0000000100000000 time=240
en=1 in=0x9 out=0x0000001000000000 time=250
en=1 in=0xa out=0x0000010000000000 time=260
en=1 in=0xb out=0x0000100000000000 time=270
en=1 in=0xc out=0x0001000000000000 time=280
en=1 in=0xd out=0x0010000000000000 time=290
en=1 in=0xe out=0x0100000000000000 time=300
en=1 in=0xf out=0x1000000000000000 time=310
*/