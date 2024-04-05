//Functions

//The primary purpose of a function is to return a value that can be used in an expression
// and cannot consume simulation time.

//A function cannot have time controlled statements like @, #, fork join, or wait
//A function cannot start a task since tasks are allowed to consume simulation time

//====ANSI-C style declaration

module tb;

  	// There are two ways to call the function:
  	initial begin
      // 1. Call function and assign value to a variable, and then use variable
      int s = sum(3, 4);
      $display ("sum(3,4) = %0d", s);

      // 2. Call function and directly use value returned
      $display ("sum(5,9) = %0d", sum(5,9));

      $display ("mul(3,1) = %0d", mul(3,1));
    end

  	// This function returns value of type "byte", and accepts two
  	// arguments "x" and "y". A return variable of the same name as
  	// function is implicitly declared and hence "sum" can be directly
  	// assigned without having to declare a separate return variable
	function byte sum (int x, int y);
		sum = x + y;
	endfunction

  	// Instead of assigning to "mul", the computed value can be returned
  	// using "return" keyword
  	function byte mul (int x, y);
      	return x * y;
  	endfunction
endmodule
//output
/*
# KERNEL: sum(3,4) = 7
# KERNEL: sum(5,9) = 14
# KERNEL: mul(3,1) = 3
*/

//====Using declarations and directions

//Although ANSI-C style declaration was later introduced in Verilog,
// the old style declaration of port directions are still valid. 
//SystemVerilog functions can have arguments declared as input and output ports as shown in the example below.
//not support in some simulators
module tb2;
	initial begin
      	int res, s;
      	s = sum(5,9);
    	$display ("s = %0d", sum(5,9));
      	$display ("sum(5,9) = %0d", sum(5,9));
      	$display ("mul(3,1) = %0d", mul(3,1,res));
      	$display ("res = %0d", res);
    end

	// Function has an 8-bit return value and accepts two inputs
  	// and provides the result through its output port and return val
  	function bit [7:0] sum;
      	input int x, y;
      	output sum;
		sum = x + y;
	endfunction

  	// Same as above but ports are given inline
  	function byte mul (input int x, y, output int res);
    	res = x*y + 1;
    	return x * y;
  	endfunction
endmodule

//====pass arguments by value
module tb3;

  initial begin
    int a, res;

    // 1. Lets pick a random value from 1 to 10 and assign to "a"
    a = $urandom_range(1, 10);

    $display ("Before calling fn: a=%0d res=%0d", a, res);

    // Function is called with "pass by value" which is the default mode
    res = fn(a);

    // Even if value of a is changed inside the function, it is not reflected here
    $display ("After calling fn: a=%0d res=%0d", a, res);
  end

  // This function accepts arguments in "pass by value" mode
  // and hence copies whatever arguments it gets into this local
  // variable called "a".
  function int fn(int a);

    // Any change to this local variable is not
  	// reflected in the main variable declared above within the
  	// initial block
    a = a + 5;

    // Return some computed value
    return a * 10;
  endfunction

endmodule
//output
/*
# KERNEL: Before calling fn: a=8 res=0
# KERNEL: After calling fn: a=8 res=130
*/

//====pass arguments by reference
// Use "ref" to make this function accept arguments by reference
// Also make the function automatic
function automatic int fn(ref int a);

  // Any change to this local variable will be
	// reflected in the main variable declared within the
	// initial block
  a = a + 5;

  // Return some computed value
  return a * 10;
endfunction