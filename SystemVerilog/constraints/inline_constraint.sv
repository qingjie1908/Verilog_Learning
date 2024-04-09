//Consider that a class already has well written constraints 
//and there is a need to randomize the class variables with a set of different constraints decided by the user. 
//By using the with construct, users can declare in-line constraints at the point where the randomize() method is called. 
//These additional constraints will be considered along with the object's original constraints by the solver.

class Item;
  rand bit [7:0] id;

  constraint c_id { id < 25; }

endclass

module tb;

  initial begin
    Item itm = new ();
    itm.randomize() with { id == 10; }; 		// In-line constraint using with construct
    $display ("Item Id = %0d", itm.id);
  end
endmodule
//output:
//# KERNEL: Item Id = 10

//If the original constraint c_id is fixed to 25 as follows 
//and we provide a conflicting in-line value, 
//then the randomization will fail.
//variable retain original value without constraint, which is default constructor initial value

class Item;
  rand bit [7:0] id;

  constraint c_id { id == 25; }
endclass

module tb;
  initial begin
    Item itm = new ();
    if (! itm.randomize() with { id < 10; })
    	$display ("Randomization failed");
    $display ("Item Id = %0d", itm.id);
  end
endmodule
//output
/*
# RCKERNEL: Warning: RC_0024 testbench.sv(10): Randomization failed. The condition of randomize call cannot be satisfied.
# RCKERNEL: Info: RC_0109 testbench.sv(10): ... after reduction itm.id to 25
# RCKERNEL: Info: RC_0103 testbench.sv(10): ... the following condition cannot be met: (8'(25)<10)
# RCKERNEL: Info: RC_1007 testbench.sv(1): ... see class 'Item' declaration.
# KERNEL: Randomization failed
# KERNEL: Item Id = 0
*/

//The takeaway here is that constraints provided should not conflict with each other 
//and in-line method of providing constraints does not override 
//but instead is also considered along with the original by the solver.