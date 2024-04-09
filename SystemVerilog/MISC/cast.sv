//When values need to be assigned between two different data type variables, 
//ordinary assignment might not be valid and instead a system task called $cast should be used.

//$cast can be called as either a task or a function, 
//the difference being that when used as a function, it returns a 1 if the cast is legal.

//Syntax

function int $cast (targ_var, source_exp);

task $cast (targ_var, source_exp);
//source_exp is the source expression that should be evaluated and assigned to the target variable.

//====Calling as a task/function

    //When $cast is called as a task, it will attempt to assign the source expression to the target variable 
    //and if it's invalid, a runtime error will occur and the target variable will remain unchanged.

    //When $cast is called as a function, it will attempt to assign the source expression to the target variable 
    //and return 1 if it succeeds.
    // It does not make the assignment if it fails and returns 0. 
    //Note that in this case there will be no runtime error, 
    //and the simulation will proceed with the unchanged value of the destination variable.

typedef enum { PENNY=1, FIVECENTS=5, DIME=10, QUARTER=25, DOLLAR=100 } Cents;

module tb;
	Cents 	myCent;

	initial begin
		$cast (myCent, 10 + 5 + 10);
		$display ("Money=%s", myCent.name());
	end
endmodule
//output
/*
# KERNEL: Money=QUARTER
*/

//====Without $cast
module tb;
	Cents 	myCent;

	initial begin
		myCent = 10 + 5 + 10;
		$display ("Money=%s", myCent.name());
	end
endmodule
//ERROR VCP2694 "Assignment to enum variable from expression of different type.

//====Casting invalid values
module tb;
	Cents 	myCent;

	initial begin
		$cast (myCent, 75);
		$display ("Money=%s", myCent.name());
	end
endmodule
//error, Cents does not define enumerator for value 75.

//====$cast as a function
module tb;
	Cents 	myCent;

	initial begin
		if ($cast (myCent, 75))
		    $display ("Cast passed");
	    else
		    $display ("Cast failed");
	end
endmodule
//# KERNEL: Cast failed