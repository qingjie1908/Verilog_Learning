//functional coverage 
//Functional coverage is a measure of what functionalities/features of the design have been exercised by the tests.
//This can be useful in constrained random verification (CRV) to know what features have been covered by a set of tests in a regression

//How is functional coverage done in SystemVerilog ?
//The idea is to sample interesting variables in the testbench and analyze if they have reached certain set of values.

module test;
	bit [3:0] mode;
	bit [1:0] key;

	// Other testbench code
endmodule
//mode can take 16 values, while key can take 4 values. 
//if there's something to monitor these two variables in a simulation
//and report what values of mode and key have been exercised
//you'll know if the test covered a particular feature or not.
//there are options in a simulator to dump out such coverage details into a file so that it can be reviewed after the simulation has finished. 
//you can merge all such coverage files from different tests into a single database and review them as a whole
//If test A covered feature X and test B covered feature Y, the merged database will show that you have covered both X and Y

//====How to write covergroups ?

class myTrns;
	rand bit [3:0] 	mode;
	rand bit [1:0] 	key;

   function display ();
      $display ("[%0tns] mode = 0x%0h, key = 0x%0h", $time, mode, key);
   endfunction

	covergroup CovGrp;
		coverpoint mode {
			bins featureA 	= {0};
			bins featureB 	= {[1:3]};
			bins common [] 	= {4:$};
			bins reserve	= default;
		}
		coverpoint key;
	endgroup
endclass
/*
Note:

Variables are mentioned as a coverpoint.
Coverpoints are put together in a covergroup block.
Multiple covergroups can be created to sample the same variables with different set of bins
bins are said to be "hit/covered" when the variable reaches the corresponding values. So, the bin featureB is hit when mode takes either 1,2 or 3.
bin reserve is a single bin for all values that do not fall under the other bins.
common will have 12 separate bins, one for each value from 0x4 to 0xF.
*/

//====Why are coverage metrics missing in simulations ?

//You have to enable the tool vendor specific command-line switch to dump coverage details. 
//Then open a coverage viewer tool like Cadence ICCR/IMC and open the coverage dump file.

//====How to specify when to sample ?

//There are two ways to trigger coverage collection in a covergroup.

//==Use sample() method of a particular covergroup to sample coverpoints within that group.

class myCov;
	covergroup CovGrp;
	 	...
	endgroup

	function new ();
		CovGrp = new; 	        // Create an instance of the covergroup
	endfunction
endclass

module tb_top;
	myCov myCov0 = new ();   	// Create an instance of the class

	initial begin
		myCov0.CovGrp.sample ();
	end
endmodule

//==Mention the event at which the covergroup should be sampled
covergroup CovGrp @ (posedge clk); 	// Sample coverpoints at posedge clk
covergroup CovGrp @ (eventA); 			// eventA can be triggered with ->eventA;

//====What are the ways for conditional coverage ?

//you have two ways to conditionally enable coverage.

//Use iff construct
covergroup CovGrp;
	coverpoint mode iff (!_if.reset) {
	    // bins for mode
	}
endgroup

//Use start and stop functions
CovGrp cg = new;

initial begin
	#1 _if.reset = 0;
	cg.stop ();
	#10 _if.reset = 1;
	cg.start();
end