//====unique,unique0 case

//All case statements can be qualified by unique or unique0 keywords to perform violation checks like we saw in if-else-if construct.

//unique and unique0 ensure that there is no overlapping case items and hence can be evaluated in parallel. 
//If there are overlapping case items, then a violation is reported.

//If more than one case item is found to match the given expression, then a violation is reported and the first matching expression is executed
//If no case item is found to match the given expression, then a violation is reported only for unqiue

//unique0 does not report a violation if no items match the expression

//unique : No items match for given expression

module tb;
  bit [1:0] 	abc;

  initial begin
    abc = 1;

    // None of the case items match the value in "abc"
    // A violation is reported here
    unique case (abc)
      0 : $display ("Found to be 0");
      2 : $display ("Found to be 2");
    endcase
  end
endmodule
//output
/*
# KERNEL: Warning: unique_case_1: testbench.sv(9), scope: tb, time: 0. None of case items matched, actual expression value: 01 
*/

//unique : More than one case item matches

module tb2;
  bit [1:0] 	abc;

  initial begin
    abc = 0;

    // Multiple case items match the value in "abc"
    // A violation is reported here
    unique case (abc)
      0 : $display ("Found to be 0");
      0 : $display ("Again found to be 0");
      2 : $display ("Found to be 2");
    endcase
  end
endmodule
//output
/*
# KERNEL: Found to be 0
# KERNEL: Simulation has finished. There are no more test vectors to simulate.
*/

//====priority case

module tb3;
  bit [1:0] 	abc;

  initial begin
    abc = 0;

    // First match is executed
    priority case (abc)
      0 : $display ("Found to be 0");
      0 : $display ("Again found to be 0");
      2 : $display ("Found to be 2");
    endcase
  end
endmodule
//output
/*
# KERNEL: Found to be 0
# KERNEL: Simulation has finished. There are no more test vectors to simulate.
*/