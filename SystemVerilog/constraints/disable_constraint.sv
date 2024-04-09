//All constraints are by default enabled and will be considered by the SystemVerilog constraint solver during randomization. 
//A disabled constraint is not considered during randomization.

//Constraints can be enabled or disabled by constraint_mode()

//Syntax

//constraint_mode() can be called both as a task and as a function.

//When called as a task, the method does not return anything.The task is supplied with an input argument to either turn on or off the given constraint.
//When called as a function, the method returns the current state of the given constraint.

// Called as a task
class_obj.const_name.constraint_mode(0); 			// Turn off the constraint
class_obj.const_name.constraint_mode(1); 			// Turn on the constraint

// Called as a function
status = class_obj.const_name.constraint_mode(); 	// status is an int variable to hold return value

//constraint_mode() is a built-in method and cannot be overriden !

class Fruits;
  rand bit[3:0]  num; 				// Declare a 4-bit variable that can be randomized

  constraint c_num { num > 4;  		// Constraint is by default enabled, and applied
                    num < 9; }; 	// during randomization giving num a value between 4 and 9
endclass

module tb;
  initial begin
    Fruits f = new ();

	// 1. Print value of num before randomization
    $display ("Before randomization num = %0d", f.num);

    // 2. Call "constraint_mode" as a function, the return type gives status of constraint
    if (f.c_num.constraint_mode ())
      $display ("Constraint c_num is enabled");
    else
      $display ("Constraint c_num is disabled");

    // 3. Randomize the class object
    f.randomize ();

    // 4. Display value of num after randomization
    $display ("After randomization num = %0d", f.num);
  end
endmodule
//output
/*
# KERNEL: Before randomization num = 0
# KERNEL: Constraint c_num is enabled
# KERNEL: After randomization num = 7
*/

//disabling the constraint using constraint_mode() before attempting to randomize the variable.
module tb;
  initial begin
    Fruits f = new ();
    $display ("Before randomization num = %0d", f.num);

    // Disable constraint
    f.c_num.constraint_mode(0);

    if (f.c_num.constraint_mode ())
      $display ("Constraint c_num is enabled");
    else
      $display ("Constraint c_num is disabled");

    // Randomize the variable and display
    f.randomize ();
    $display ("After randomization num = %0d", f.num);
  end
endmodule
//output
/*
 KERNEL: Before randomization num = 0
# KERNEL: Constraint c_num is disabled
# KERNEL: After randomization num = 7
*/

//Note that turning off the constraint made 
//the solver choose any value that the variable supported, 
//instead of confining the values to the range specified in the constraint.

//If constraint_mode() method is called on a constraint that does not exist, it will result in a compiler error.