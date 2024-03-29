//function:
/*
function [automatic] [return_type] name ([port_list]);
	[statements]
endfunction
*/

//The keyword automatic will make the function reentrant and items declared within the task are dynamically allocated rather than shared between different invocations of the task. 
//This will be useful for recursive functions 
//and when the same function is executed concurrently by N processes when forked.

//Function declarations
//There are two ways to declare inputs to a function:
/*
function [7:0] sum;
	input [7:0] a, b;
	begin
		sum = a + b;
	end
endfunction
*/

/*
function [7:0] sum (input [7:0] a, b);
	begin
		sum = a + b;
	end
endfunction
*/

//Returning a value from a function
//The function definition will implicitly create an internal variable of the same name as that of the function.
//Hence it is illegal to declare another variable of the same name inside the scope of the function.

//Recursive Functions
module tb;
    initial begin: init_block //block name is necessary since we have variable declaration inside this block
        integer a;
        a = factorial(4);
        $display("factorial(4) = %0d", a);
    end

	function automatic integer factorial(input integer i);
        //input integer i;
        // This function is called within the body of this
        // function with a different argument
        if (i) begin
            factorial = i * factorial(i-1);
            $display("i=%0d result=%0d", i, factorial);
        end else
            factorial = 1;
	endfunction
endmodule


// Function rules
/*
A function cannot contain any time-controlled statements like #, @, wait, posedge, negedge
A function cannot start a task because it may consume simulation time, but can call other functions
A function should have atleast one input
A function cannot have non-blocking assignments or force-release or assign-deassign
A function cannot have any triggers
A function cannot have an output or inout
*/
