//SystemVerilog introduced the following if else constructs 
//for violation checks.

//====unique-if, unique0-if

//unique-if evaluates conditions in any order and does the following :

//report an error when none of the if conditions match unless there is an explicit else.
//report an erorr when there is more than 1 match found in the if else conditions

//Unlike unique-if, unique0-if does not report a violation if none of the conditions match

//No else block for unique-if

module tb;
	int x = 4;

  	initial begin
      	// This if else if construct is declared to be "unique"
		// Error is not reported here because there is a "else"
      	// clause in the end which will be triggered when none of
      	// the conditions match
    	unique if (x == 3)
      		$display ("x is %0d", x);
    	else if (x == 5)
      		$display ("x is %0d", x);
      	else
      		$display ("x is neither 3 nor 5");

      	// When none of the conditions become true and there
      	// is no "else" clause, then an error is reported
    	unique if (x == 3)
      		$display ("x is %0d", x);
    	else if (x == 5)
      		$display ("x is %0d", x);
  	end
endmodule

//output
/*
# KERNEL: x is neither 3 nor 5
# KERNEL: Warning: unique_if_2: testbench.sv(18), scope: tb, time: 0. None of 'if' branches matched.
*/

//Multiple matches in unique-if

module tb2;
	int x = 4;

  	initial begin

      	// This if else if construct is declared to be "unique"
		// When multiple if blocks match, then error is reported
      	unique if (x == 4)
          $display ("1. x is %0d", x);
      	else if (x == 4)
          $display ("2. x is %0d", x);
      	else
          $display ("x is not 4");
  	end
endmodule

//output
/*
# KERNEL: 1. x is 4
# ASSERT: Error: Assertion 'unique_if_1' FAILED at time: 0, testbench.sv(8), scope: tb2. Two or more conditions are true simultaneously: x==4 (line: 8), x==4. (line: 10)
*/

//====priority-if

//priority-if evaluates all conditions in sequential order and a violation is reported when:

//None of the conditions are true and there's no else clause to the final if construct

//No else clause in priority-if

module tb3;
	int x = 4;

  	initial begin
      	// This if else if construct is declared to be "priority"
		// Error is not reported here because there is a "else"
      	// clause in the end which will be triggered when none of
      	// the conditions match
    	priority if (x == 3)
      		$display ("x is %0d", x);
    	else if (x == 5)
      		$display ("x is %0d", x);
      	else
      		$display ("x is neither 3 nor 5");

      	// When none of the conditions become true and there
      	// is no "else" clause, then an error is reported
    	priority if (x == 3)
      		$display ("x is %0d", x);
    	else if (x == 5)
      		$display ("x is %0d", x);
  	end
endmodule
//output
/*
# KERNEL: x is neither 3 nor 5
# KERNEL: Warning: priority_if_1: testbench.sv(20), scope: tb, time: 0. None of 'if' branches matched.
*/