//Verilog also provides support for transistor level modeling although it is rarely used by designers these days as the complexity of circuits have required them to move to higher levels of abstractions rather than use switch level modeling.

//NMOS/PMOS
module des1 (input d, ctrl,
			output outn, outp);

  nmos (outn, d, ctrl); // ctrl = 1, nmos active
  pmos (outp, d, ctrl); // ctrl = 0, pmos active
endmodule
module tb;
  reg d, ctrl;
  wire outn, outp;

  des u0 (.d(d), .ctrl(ctrl), .outn(outn), .outp(outp));

  initial begin
    {d, ctrl} <= 0;

    $monitor ("T=%0t d=%0b ctrl=%0b outn=%0b outp=%0b", $time, d, ctrl, outn, outp);

    #10 d <= 1;
    #10 ctrl <= 1;
    #10 ctrl <= 0;
    #10 d <= 0;
  end
endmodule

//output
/*
T=0 d=0 ctrl=0 outn=z outp=0
T=10 d=1 ctrl=0 outn=z outp=1
T=20 d=1 ctrl=1 outn=1 outp=z
T=30 d=1 ctrl=0 outn=z outp=1
T=40 d=0 ctrl=0 outn=z outp=0
*/

//CMOS Switches
module des (input d, nctrl, pctrl,
			output out);

  cmos (out, d, nctrl, pctrl);
endmodule
module tb;
  reg d, nctrl, pctrl;
  wire out;

  des u0 (.d(d), .nctrl(nctrl), .pctrl(pctrl), .out(out));

  initial begin
    {d, nctrl, pctrl} <= 0;

    $monitor ("T=%0t d=%0b nctrl=%0b pctrl=%0b out=%0b", $time, d, nctrl, pctrl, out);

    #10 d <= 1;
    #10 nctrl <= 1;
    #10 pctrl <= 1;
    #10 nctrl <= 0;
    #10 pctrl <= 0;
    #10 d <= 0;
    #10;
  end
endmodule

//output
/*
T=0 d=0 nctrl=0 pctrl=0 out=0
T=10 d=1 nctrl=0 pctrl=0 out=1
T=20 d=1 nctrl=1 pctrl=0 out=1
T=30 d=1 nctrl=1 pctrl=1 out=1
T=40 d=1 nctrl=0 pctrl=1 out=z //only pctrl = 1, nctrl = 0, output has highz, both transistor not active
T=50 d=1 nctrl=0 pctrl=0 out=1
T=60 d=0 nctrl=0 pctrl=0 out=0
*/

//Bidirectional Switches

module des (input io1, ctrl,
            output io2);

  tran (io1, io2);
endmodule
module tb;
  reg io1, ctrl;
  wire io2;

  des u0 (.io1(io1), .ctrl(ctrl), .io2(io2));

  initial begin
    {io1, ctrl} <= 0;

    $monitor ("T=%0t io1=%0b ctrl=%0b io2=%0b", $time, io1, ctrl, io2);

    #10 io1  <= 1;
    #10 ctrl <= 1;
    #10 ctrl <= 0;
    #10 io1  <= 0;

  end
endmodule

//output
/*
T=0 io1=0 ctrl=0 io2=0
T=10 io1=1 ctrl=0 io2=1
T=20 io1=1 ctrl=1 io2=1
T=30 io1=1 ctrl=0 io2=1
T=40 io1=0 ctrl=0 io2=0
*/

//tranif0

module des (input io1, ctrl, // when ctrl = 0, active. ctrl = 1, output high z
            output io2);

  tranif0 (io1, io2, ctrl);
endmodule

//tranif1
module des (input io1, ctrl, //ctrl = 1, avtive, out = input,
            output io2);

  tranif1 (io1, io2, ctrl);
endmodule

//Power and Ground

module des (output vdd,
			output gnd);

	supply1 _vdd; // supply1 high voltage, 1
	supply0 _gnd; // supply0 low voltage, 0

	assign vdd = _vdd;
	assign gnd = _gnd;
endmodule
module tb;
  wire vdd, gnd;

  des u0 (.vdd(vdd), .gnd(gnd));

  initial begin
    #10;
    $display ("T=%0t vdd=%0d gnd=%0d", $time, vdd, gnd);
  end
endmodule

//output
/*
T=10 vdd=1 gnd=0
*/