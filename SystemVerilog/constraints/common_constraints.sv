//====Simple expressions

//Note that there can be only one relational operator < <= > >= in an expression.

class MyClass;
	rand bit [7:0] min, typ, max;

	// Valid expression
	constraint my_range { 0 < min;
	                      typ < max;
	                      typ > min;
	                      max < 128; }

	// Use of multiple operators in a single expression is not allowed
	constraint my_error { 0 < min < typ < max < 128; }

	// This will set min to 16 and randomize all others
	constraint my_min {  min == 16; }

	// This will set max to a random value greater than or equal to 64
	constraint my_max {  max >= 64; }
endclass

//You cannot make assignments inside a constraint block 
//as it only contains expressions. 
//Instead you have to use an equivalence operator == as shown for the constraint named my_min in the example above where min will get a value of 16 and all other variables will be randomized. 
//This is one way of fixing a particular value to a variable even if the solver attempts to randomize it.

//You can also use a little more complex expression
/*
straint my_min { min == temp.low * 9/5 + 32; }
*/


class myClass;
      rand bit [3:0] min, typ, max;
      rand bit [3:0] fixed;

      constraint my_range { 3 < min;
                            typ < max;
                            typ > min;
                            max < 14; }

      constraint c_fixed { fixed == 5; }

      function string display ();
        return $sformatf ("min=%0d typ=%0d max=%0d fixed=%d", min, typ, max, fixed);
      endfunction

endclass

    module tb;
       initial begin
          for (int i = 0; i < 10; i++) begin
             myClass cls = new ();
             cls.randomize();
             $display ("itr=%0d %s", i, cls.display());
          end
       end
    endmodule

//output
/*
# KERNEL: itr=0 min=7 typ=9 max=12 fixed= 5
# KERNEL: itr=1 min=4 typ=9 max=12 fixed= 5
# KERNEL: itr=2 min=7 typ=10 max=13 fixed= 5
# KERNEL: itr=3 min=4 typ=6 max=11 fixed= 5
# KERNEL: itr=4 min=8 typ=12 max=13 fixed= 5
# KERNEL: itr=5 min=5 typ=6 max=13 fixed= 5
# KERNEL: itr=6 min=6 typ=9 max=13 fixed= 5
# KERNEL: itr=7 min=10 typ=12 max=13 fixed= 5
# KERNEL: itr=8 min=5 typ=11 max=13 fixed= 5
# KERNEL: itr=9 min=6 typ=9 max=11 fixed= 5
*/

//====inside operator

//You can specify a lower and an upper limit as an alternative to the expression shown below using an inside operator.

constraint my_range { typ > 32;
                      typ < 256; }

// typ >= 32 and typ <= 256
constraint new_range { typ inside {[32:256]}; }

// Choose from the following values
constraint spec_range { type inside {32, 64, 128}; }

//Note that an inside construct includes both lower and upper limits. 
//SystemVerilog gathers all the values and chooses between the values with equal probability unless there are other constraints on the variable.

//====Inverted inside operator

//If you want any value outside a specific range, 
//an inverted constraint can be written as follows. 
//This will produce a random value from 0 to 2 and 7 since typ is an 3-bit variable and the upper limit already covers the maximum value it can hold.

rand bit [2:0] typ;
constraint inv_range { ! (typ inside {[3:6]}); }

//Note that repeated randomization gave all values except the ones that fall within the range 3 through 6.
//output
/*
# KERNEL: itr=0 7
# KERNEL: itr=1 0
# KERNEL: itr=2 7
# KERNEL: itr=3 0
# KERNEL: itr=4 0
# KERNEL: itr=5 0
# KERNEL: itr=6 7
# KERNEL: itr=7 1
# KERNEL: itr=8 1
# KERNEL: itr=9 7
*/

//====Weighted distributions
//The dist operator allows you to create weighted distributions 
//so that some values are chosen more often than others. 
//The := operator specifies that the weight is the same for every specified value in the range 
//while the :/ operator specifies that the weight is to be equally divided between all the values.

//:= operator

rand bit [2:0] typ;
constraint dist1 	{  typ dist { 0:=20, [1:5]:=50, 6:=40, 7:=10}; }

//In dist1, the weight of 0 is 20, 6 is 40, and 7 is 10 while 1 through 5 is 50, 
//for a total of 320. 
//Hence the probability of choosing 0 is 20/320 and the probability of choosing a value between 1 and 5 is 50/320.

class myClass;
	rand bit [2:0] typ;
	constraint dist1 	{  typ dist { 0:=20, [1:5]:=50, 6:=40, 7:=10}; }
endclass

module tb;
	initial begin
		for (int i = 0; i < 10; i++) begin
			myClass cls = new ();
			cls.randomize();
			$display ("itr=%0d typ=%0d", i, cls.typ);
		end
	end
endmodule
//In the log shown below, note that 1 through 5 has appeared more than 0, 6 or 7 because they have a higher weight and are chosen more often.
//output
/*
# KERNEL: itr=0 typ=5
# KERNEL: itr=1 typ=1
# KERNEL: itr=2 typ=6
# KERNEL: itr=3 typ=3
# KERNEL: itr=4 typ=2
# KERNEL: itr=5 typ=3
# KERNEL: itr=6 typ=0
# KERNEL: itr=7 typ=5
# KERNEL: itr=8 typ=1
# KERNEL: itr=9 typ=4
*/

//:/ operator

rand bit [2:0] typ;
constraint dist2  	{  typ dist { 0:/20, [1:5]:/50, 6:/10, 7:/20}; }

//n dist2, the weight of 0 is 20, 
//6 is 10 and 7 is 20 
//while 1 through 5 share a total weight of 50, thus have 10 each

class myClass;
	rand bit [2:0] typ;
	constraint dist2 	{  typ dist { 0:/20, [1:5]:/50, 6:/40, 7:/10}; }
endclass

module tb;
	initial begin
		for (int i = 0; i < 10; i++) begin
			myClass cls = new ();
			cls.randomize();
			$display ("itr=%0d typ=%0d", i, cls.typ);
		end
	end
endmodule
//output
/*
# KERNEL: itr=0 typ=5
# KERNEL: itr=1 typ=6
# KERNEL: itr=2 typ=4
# KERNEL: itr=3 typ=6
# KERNEL: itr=4 typ=6
# KERNEL: itr=5 typ=4
# KERNEL: itr=6 typ=2
# KERNEL: itr=7 typ=3
# KERNEL: itr=8 typ=4
# KERNEL: itr=9 typ=6
*/

//====Bidirectional constraints

//Constraint blocks are not executed from top to bottom like procedural code,
//but are all active at the same time. Let's see this with another example.

class myClass;
	rand bit [3:0] val;
	constraint  c1 { val > 3;
	                 val < 12; }

	constraint  c2  {val >= 10; }
endclass

module tb;
	initial begin
		for (int i = 0; i < 10; i++) begin
			myClass cls = new ();
			cls.randomize();
			$display ("itr=%0d typ=%0d", i, cls.val);
		end
	end
endmodule
//output
/*
# KERNEL: itr=0 typ=11
# KERNEL: itr=1 typ=11
# KERNEL: itr=2 typ=11
# KERNEL: itr=3 typ=10
# KERNEL: itr=4 typ=11
# KERNEL: itr=5 typ=10
# KERNEL: itr=6 typ=10
# KERNEL: itr=7 typ=10
# KERNEL: itr=8 typ=10
# KERNEL: itr=9 typ=10
*/
