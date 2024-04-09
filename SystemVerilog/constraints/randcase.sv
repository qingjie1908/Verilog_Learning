//Sometimes we come across scenarios where we want the solver to randomly pick one out of the many statements. 
//The keyword randcase introduces a case statement that randomly selects one of its branches. 
//The case item expressions are positive integer values that represent the weights associated with each item.
// Probability of selecting an item is derived by the division of that item's weight divided by the sum of all weights.

//Syntax
/*
randcase
	item 	: 	statement;
	...
endcase
*/

//The sum of all weights is 9, 
//and hence the probability of taking the first branch is 1/9 or 11.11%, 
//the probability of taking the second branch is 5/9 or 55.56% 
//and the probability of taking the last branch is 3/9 or 33.33%.
module tb;
	initial begin
      for (int i = 0; i < 10; i++)
      	randcase
        	1 	: 	$display ("Wt 1");
      		5 	: 	$display ("Wt 5");
      		3 	: 	$display ("Wt 3");
      	endcase
    end
endmodule
//output
/*
# KERNEL: Wt 5
# KERNEL: Wt 3
# KERNEL: Wt 5
# KERNEL: Wt 5
# KERNEL: Wt 1
# KERNEL: Wt 1
# KERNEL: Wt 3
# KERNEL: Wt 1
# KERNEL: Wt 3
# KERNEL: Wt 5
*/

//If a branch specifies a zero weight, then that branch is not taken.

module tb;
	initial begin
      for (int i = 0; i < 10; i++)
      	randcase
        	0 	: 	$display ("Wt 1");
      		5 	: 	$display ("Wt 5");
      		3 	: 	$display ("Wt 3");
      	endcase
    end
endmodule
//output
/*
# KERNEL: Wt 3
# KERNEL: Wt 5
# KERNEL: Wt 3
# KERNEL: Wt 5
# KERNEL: Wt 3
# KERNEL: Wt 5
# KERNEL: Wt 5
# KERNEL: Wt 5
# KERNEL: Wt 5
# KERNEL: Wt 5
*/