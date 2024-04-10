//SystemVerilog covergroup is a user-defined type that encapsulates the specification of a coverage model.
//They can be defined once and instantiated muliple times at different places via the new function.

//covergroup can be defined in either a package, module, program, interface, or class and usually encapsulates the following information:
/*
A set of coverage points
Cross coverage between coverage points
An event that defines when the covergroup is sampled
Other options to configure coverage object
*/

//covergroup

module tb;

  // Declare some variables that can be "sampled" in the covergroup
  bit [1:0] mode;
  bit [2:0] cfg;

  // Declare a clock to act as an event that can be used to sample
  // coverage points within the covergroup
  bit clk;
  always #20 clk = ~clk;

  // "cg" is a covergroup that is sampled at every posedge clk
  covergroup cg @ (posedge clk);
    coverpoint mode;
  endgroup

  // Create an instance of the covergroup
  cg  cg_inst;

  initial begin
    // Instantiate the covergroup object similar to a class object
    //only instantiate covergroup then start monitor cover at certain condition like posedge in this example
    //if we put this after for loop
    //then cg_inst will only capture the last mode value
    //which makes the coverage always 25% (mode total have 4 possible value)
    cg_inst= new();

    // Stimulus : Simply assign random values to the coverage variables
    // so that different values can be sampled by the covergroup object
    for (int i = 0; i < 5; i++) begin
      @(negedge clk);
      mode = $random;
      cfg  = $random;
      $display ("[%0t] mode=0x%0h cfg=0x%0h", $time, mode, cfg);
    end
  end

  // At the end of 500ns, terminate test and print collected coverage
  initial begin
    #500 $display ("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
    $finish;
  end
endmodule
//output
/*
# KERNEL: [40] mode=0x0 cfg=0x1
# KERNEL: [80] mode=0x1 cfg=0x3
# KERNEL: [120] mode=0x1 cfg=0x5
# KERNEL: [160] mode=0x1 cfg=0x2
# KERNEL: [200] mode=0x1 cfg=0x5
# KERNEL: Coverage = 50.00 %
*/

//====coverpoint
//A covergroup can contain one or more coverage points. 
//A coverpoint specifies an integral expression that is required to be covered.
//Evaluation of the coverpoint expression happens when the covergroup is sampled. 
//The SystemVerilog coverage point can be optionally labeled with a colon :

//The example shown below randomizes the two variables mode and cfg multiple times and is assigned a value on every negative edge of the clock.
//The covergroup is specified to be sampled at every occurence of a positive edge of the clock.

module tb;

  bit [1:0] mode;
  bit [2:0] cfg;

  bit clk;
  always #20 clk = ~clk;

  // "cg" is a covergroup that is sampled at every posedge clk
  // This covergroup has two coverage points, one to cover "mode"
  // and the other to cover "cfg". Mode can take any value from
  // 0 -> 3 and cfg can take any value from 0 -> 7
  covergroup cg @ (posedge clk);

    // Coverpoints can optionally have a name before a colon ":"
    cp_mode    : coverpoint mode;
    cp_cfg_10  : coverpoint cfg[1:0];
    cp_cfg_lsb : coverpoint cfg[0];
    cp_sum     : coverpoint (mode + cfg);
    //note expression mode+cfg [0:3] + [0:7]
    //total have sum inside [0:10], but cfg is 3bit data
    //so sum will be truncated, sum will only have value inside [0:7]
  endgroup

  cg  cg_inst;

  initial begin
    cg_inst= new();
    //noted at this point 0ns, mode = 0; cfg = 0
    //so at first posedge clk, they will be sampled as 0, 0

    for (int i = 0; i < 5; i++) begin
      @(negedge clk);
      mode = $random;
      cfg  = $random;
      $display ("[%0t] mode=0x%0h cfg=0x%0h", $time, mode, cfg);
    end
  end

  initial begin
    #500 $display ("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
    $finish;
  end
endmodule
//output
//mode = 0, cfg = 0 will be sampled at first posedge, not printed in output
//coverpoint mode: has hit value  0, 1 (total 4)
//coverpoint cfg[1:0]: has hit value 0, 1, 2, 3 (total 4)
//coverpoint cfg[0]: has hit value 0, 1 (total 2)
//coverpoint (mode+cfg): has hit value 0, 1, 3, 4, 6 (total 8)
//for coverpoints, each has weight 0.25
//so coverage = 50%*0.25+ 100%*0.25 + 100%*0.25 + 5/8*0.25 = 78.12%
/*
# KERNEL: [40] mode=0x0 cfg=0x1
# KERNEL: [80] mode=0x1 cfg=0x3
# KERNEL: [120] mode=0x1 cfg=0x5
# KERNEL: [160] mode=0x1 cfg=0x2
# KERNEL: [200] mode=0x1 cfg=0x5
# KERNEL: Coverage = 78.12 %
*/