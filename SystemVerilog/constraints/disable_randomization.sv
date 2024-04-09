//Randomization of variables in a class can be disabled using rand_mode method call.

//This is very similar to the constraint_mode() method used to Disable Constraints.
//So a disabled random variable is treated the same as if they had not been declared rand or randc.

//rand_mode can be called both as a function and task. 
//Current state of the variable will be returned if it is called as a function.

// Disables randomization of variable [variable_name] inside [class_object] class
[class_object].[variable_name].rand_mode (0);

// Enables randomization of variable [variable_name] inside [class_object] class
[class_object].[variable_name].rand_mode (1);

//====Without using rand_mode()
// Create a class that contains random variables
class Fruits;
  rand bit [3:0] var1;
  rand bit [1:0] var2;
endclass

module tb;
  initial begin
  	// Instantiate an object of the class
    Fruits f = new();

    // Print values of those variables before randomization
    $display ("Before randomization var1=%0d var2=%0d", f.var1, f.var2);

    // rand_mode() is called as a function which returns the state of the given variable
    // If it is enabled, then print a statement
    if (f.var1.rand_mode())
    	if (f.var2.rand_mode())
      		$display ("Randomization of all variables enabled");

    // Randomize the class object which in turn randomizes all internal variables
    // declared using rand/randc keywords
    f.randomize();

    // Print the value of these variables after randomization
    $display ("After randomization var1=%0d var2=%0d", f.var1, f.var2);
  end
endmodule
//output
/*
# KERNEL: Before randomization var1=0 var2=0
# KERNEL: Randomization of all variables enabled
# KERNEL: After randomization var1=7 var2=2
*/

//====After using rand_mode()
class Fruits;
  rand bit [3:0] var1;
  rand bit [1:0] var2;
endclass

module tb;
  initial begin
    Fruits f = new();
    $display ("Before randomization var1=%0d var2=%0d", f.var1, f.var2);

    // Turn off randomization for var1
    f.var1.rand_mode (0);

    // Print if var1 has randomization enabled/disabled
    if (f.var1.rand_mode())
      $display ("Randomization of var1 enabled");
    else
      $display ("Randomization of var1 disabled");

    f.randomize();

    $display ("After randomization var1=%0d var2=%0d", f.var1, f.var2);
  end
endmodule
//output
/*
# KERNEL: Before randomization var1=0 var2=0
# KERNEL: Randomization of var1 disabled
# KERNEL: After randomization var1=0 var2=3
*/

//====skip mentioning a variable name while invoking rand_mode().

// Create a class that contains random variables
class Fruits;
  rand bit [3:0] var1;
  rand bit [1:0] var2;
endclass

module tb;

  initial begin
    Fruits f = new();
    $display ("Before randomization var1=%0d var2=%0d", f.var1, f.var2);

    // Turns off randomization for all variables
    f.rand_mode (0);

    if (! f.var1.rand_mode())
      if (! f.var2.rand_mode())
        $display ("Randomization of all variables disabled");

    f.randomize();

    $display ("After randomization var1=%0d var2=%0d", f.var1, f.var2);
  end
endmodule
//output
/*
# KERNEL: Before randomization var1=0 var2=0
# KERNEL: Randomization of all variables disabled
# KERNEL: After randomization var1=0 var2=0
*/
