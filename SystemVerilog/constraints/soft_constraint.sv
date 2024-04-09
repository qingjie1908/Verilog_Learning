//The normal constraints are called hard constraints 
//because it is mandatory for the solver to always satisfy them. 
//If the solver fails to find a solution, then the randomization will fail.

//However, a constraint declared as soft gives the solver some flexibility 
//that the constraint need to be satisfied if there are other contradicting constraints 
//- either hard or a soft constraint with higher priority.

//Soft constraints are used to specify default valus and distributions for random variables.

//Shown in the example below is a soft constraint that tells the solver to produce values within 4 and 12 for the variable called data.

class ABC;
  rand bit [3:0] data;

  // This constraint is defined as "soft"
  constraint c_data { soft data >= 4; // only data >= 4 is soft constraint
                     data <= 12; } // data <= 12 still hard constraint
endclass

module tb;
  ABC abc;

  initial begin
    abc = new;
    for (int i = 0; i < 5; i++) begin
      abc.randomize();
      $display ("abc = 0x%0h", abc.data);
    end
  end
endmodule
//output
/*
# KERNEL: abc = 0x9
# KERNEL: abc = 0x9
# KERNEL: abc = 0x6
# KERNEL: abc = 0xc
# KERNEL: abc = 0xc
*/

module tb;
  ABC abc;

  initial begin
    abc = new;
    for (int i = 0; i < 5; i++) begin
      abc.randomize() with { data == 2; }; // data == 2 is hard constraint
      // when contraint confilcts
      // soft constraint will be dicarded
      // all hard constraint still apply
      // if hard constraint confict
      // compile error, variable hold default constructor value
      $display ("abc = 0x%0h", abc.data);
    end
  end
endmodule
//output
/*
# KERNEL: abc = 0x2
# KERNEL: abc = 0x2
# KERNEL: abc = 0x2
# KERNEL: abc = 0x2
# KERNEL: abc = 0x2
*/

