//An Interface is a way to encapsulate signals into a block. 
//All related signals are grouped together to form an interface block 
//so that the same interface can be re-used for other projects.
//Also it becomes easier to connect with the DUT and other verification components.

//Example

//APB bus protocol signals are put together in the given interface. Note that signals are declared within interface and endinterface.

interface apb_if (input pclk);
	logic [31:0]    paddr;
	logic [31:0]    pwdata;
	logic [31:0]    prdata;
	logic           penable;
	logic           pwrite;
	logic           psel;
endinterface

//====why signals declared logic

//First
//logic is a new data type that lets you drive signals of this type via assign statements and in a procedural block. 
//could drive a reg only in procedural block
//and a wire only in assign statement. 

//Second
//Signals connected to the DUT should support 4-states so that X/Z values can be caught. 
//If these signals were bit then the X/Z would have shown up as 0, and you would have missed that DUT had a X/Z value.

//====How to define port directions ?

//modport is used to define signal directions.
//Different modport definitions can be passed to different components that allows us to define different input-output directions for each component.

interface myBus (input clk);
  logic [7:0]  data;
  logic      enable;

  // From TestBench perspective, 'data' is input and 'write' is output
  modport TB  (input data, clk, output enable);

  // From DUT perspective, 'data' is output and 'enable' is input
  modport DUT (output data, input enable, clk);
endinterface


//====How to connect an interface with DUT ?

//An interface object should be created in the top testbench module where DUT is instantiated, 
//and passed to DUT.
//It is essential to ensure that the correct modport is assigned to DUT.

module dut (myBus busIf);
  always @ (posedge busIf.clk)
    if (busIf.enable)
      busIf.data <= busIf.data+1;
    else
      busIf.data <= 0;
endmodule


// Filename : tb_top.sv
module tb_top;
  bit clk;

  // Create a clock
  always #10 clk = ~clk;

  // Create an interface object
  myBus busIf (clk);

  // Instantiate the DUT; pass modport DUT of busIf
  dut dut0 (busIf.DUT);

  // Testbench code : let's wiggle enable
  initial begin
    busIf.enable  <= 0;
    #10 busIf.enable <= 1;
    #40 busIf.enable <= 0;
    #20 busIf.enable <= 1;
    #100 $finish;
  end
endmodule

//====What are the advantages ?

//Interfaces can contain tasks, functions, parameters, variables, functional coverage, and assertions. 
//This enables us to monitor and record the transactions via the interface within this block. 
//It also becomes easier to connect to design regardless of the number of ports it has since that information is encapsulated in an interface.

//====How to parameterize an interface ?

//The same way you would do for a module.
/*
interface myBus #(parameter D_WIDTH=31) (input clk);
	logic [D_WIDTH-1:0] data;
	logic               enable;
endinterface
*/


//====What are clocking blocks ?
//Signals that are specified inside a clocking block will be sampled/driven with respect to that clock.
//There can be mulitple clocking blocks in an interface. 
//Note that this is for testbench related signals. 
//You want to control when the TB drives and samples signals from DUT. 
//Solves some part of the race condition, but not entirely. You can also parameterize the skew values.
interface my_int (input bit clk);
	// Rest of interface code

	clocking cb_clk @(posedge clk);
		default input #3ns output #2ns;
		input enable;
		output data;
	endclocking
endinterface

//In above
//we have specified that by default, input should be sampled 3ns before posedge of clk, and output should be driven 2ns after posedge of clk.

//====How to use a clocking block ?

// To wait for posedge of clock
//@busIf.cb_clk;

// To use clocking block signals
//busIf.cb_clk.enable = 1;