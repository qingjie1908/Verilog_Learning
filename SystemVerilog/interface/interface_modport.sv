//Modport lists with directions are defined in an interface to impose certain restrictions on interface access within a module. 
//The keyword modport indicates that the directions are declared as if inside the module

//Syntax
/*
modport  [identifier]  (
	input  [port_list],
	output [port_list]
);
*/

interface 	myInterface;
	logic 	ack;
	logic 	gnt;
	logic 	sel;
	logic 	irq0;

	// ack and sel are inputs to the dut0, while gnt and irq0 are outputs
	modport  dut0 (
		input 	ack, sel,
		output 	gnt, irq0
	);

	// ack and sel are outputs from dut1, while gnt and irq0 are inputs
	modport  dut1 (
		input 	gnt, irq0,
		output 	ack, sel
	);
endinterface

//Example of named port bundle

//In this style, the design will take the required correct modport definition from the interface object as mentioned in its port list. 
//The testbench only needs to provide the whole interface object to the design.
/*
module dut0  ( myinterface.dut0  _if);
	...
endmodule

module dut1  ( myInterface.dut1 _if);
	...
endmodule

module tb;
	myInterface 	_if;
	dut0  	d0 	( .* );
	dut1 	d1 	( .* );
endmodule
*/

//Example of connecting port bundle

//In this style, the design simply accepts whatever directional information is given to it. 
//Hence testbench is responsible to provide the correct modport values to the design.
/*
module dut0  ( myinterface  _if);
	...
endmodule

module dut1  ( myInterface _if);
	...
endmodule

module tb;
	myInterface 	_if;
	dut0  	d0 	( ._if (_if.dut0));
	dut1 	d1 	( ._if (_if.dut1));
endmodule
*/

//====What is the need for a modport ?
//Nets declared within a simple interface is inout by default and hence any module connected to the same net, can either drive values or take values from it.
// You could end up with an X on the net because both the testbench and the design are driving two different values to the same interface net

//Example of connecting to generic interface

//A module can also have a generic interface as the portlist. The generic handle can accept any modport passed to it from the hierarchy above.
/*
module dut0  ( interface  _if);
	...
endmodule

module dut1  ( interface _if);
	...
endmodule

module tb;
	myInterface 	_if;
	dut0  	d0 	( ._if (_if.dut0));
	dut1 	d1 	( ._if (_if.dut1));
endmodule
*/

//====Design Example

//Lets consider two modules master and slave connected by a very simple bus structure.
//Assume that the bus is capable of sending an address and data which the slave is expected to capture and update the information in its internal registers.
//So the master always has to initiate the transfer and the slave is capable of indicating to the master whether it is ready to accept the data by its sready signal.

//Interface

//Shown below is an interface definition that is shared between the master and slave modules.

interface ms_if (input clk);
  logic sready;      // Indicates if slave is ready to accept data
  logic rstn;        // Active low reset
  logic [1:0] addr;  // Address
  logic [7:0] data;  // Data

  modport slave ( input addr, data, rstn, clk,
                 output sready);

  modport master ( output addr, data,
                  input  clk, sready, rstn);
endinterface

// This module accepts an interface with modport "master"
// Master sends transactions in a pipelined format
// CLK    1   2   3   4   5   6
// ADDR   A0  A1  A2  A3  A0  A1
// DATA       D0  D1  D2  D3  D4
module master ( ms_if.master mif);
  always @ (posedge mif.clk) begin

  	// If reset is applied, set addr and data to default values
    if (! mif.rstn) begin
      mif.addr <= 0;
      mif.data <= 0;

    // Else increment addr, and assign data accordingly if slave is ready
    end else begin
    // Send new addr and data only if slave is ready
      if (mif.sready) begin
      	mif.addr <= mif.addr + 1;
      	mif.data <= (mif.addr * 4);

     // Else maintain current addr and data
      end else begin
        mif.addr <= mif.addr;
        mif.data <= mif.data;
      end
    end
  end
endmodule

//Assume that the slave accepts data for every addr and assigns them to internal registers. 
//When the address wraps from 3 to 0, the slave requires 1 additional clock to become ready.
module slave (ms_if.slave sif);
  reg [7:0] reg_a;
  reg [7:0]	reg_b;
  reg 		reg_c;
  reg [3:0] reg_d;

  reg		dly;
  reg [3:0] addr_dly;


  always @ (posedge sif.clk) begin
    if (! sif.rstn) begin
      addr_dly <= 0;
    end else begin
      addr_dly <= sif.addr;
    end
  end

  always @ (posedge sif.clk) begin
    if (! sif.rstn) begin
      	reg_a <= 0;
    	reg_b <= 0;
    	reg_c <= 0;
    	reg_d <= 0;
  	end else begin
      case (addr_dly)
        0 : reg_a <= sif.data;
        1 : reg_b <= sif.data;
        2 : reg_c <= sif.data;
        3 : reg_d <= sif.data;
      endcase
    end
  end

  assign sif.sready = ~(sif.addr[1] & sif.addr[0]) | ~dly;

  always @ (posedge sif.clk) begin
    if (! sif.rstn)
      dly <= 1;
    else
      dly <= sif.sready;
  end

endmodule

//The two design modules are tied together at a top level.
module d_top (ms_if tif);
	// Pass the "master" modport to master
  	master 	m0 (tif.master);

  	// Pass the "slave" modport to slave
  	slave 	s0 (tif.slave);
endmodule

//Testbench

//The testbench will pass the interface handle to the design, 
//which will then assign master and slave modports to its sub-modules.

module tb;
  reg clk;
  always #10 clk = ~clk;

  ms_if 	if0 (clk);
  d_top 	d0  (if0);

  // Let the stimulus run for 20 clocks and stop
  initial begin
    clk <= 0;
    if0.rstn <= 0;
    repeat (5) @ (posedge clk);
    if0.rstn <= 1;

    repeat (20) @ (posedge clk);
    $finish;
  end
endmodule
