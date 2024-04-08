//Variables are declared random using the rand or randc keyword.
//They can be used on normal variables, arrays, dynamic arrays or queues.

//====rand

class Packet;
	rand int   		count;
	rand byte  		master [$];
	rand bit [7:0]  data [];

	...
endclass

//Let's take a simple class with a 3-bit variable called data that is randomized 10 times. 
//The function randomize() is invoked as part of the class object to randomize all the rand type variables within that class object.

class Packet;
	rand bit [2:0] data;
endclass

module tb;
	initial begin
		Packet pkt = new ();
		for (int i = 0 ; i < 10; i++) begin
			pkt.randomize ();
			$display ("itr=%0d data=0x%0h", i, pkt.data);
		end
	end
endmodule
//output
/*
# KERNEL: itr=0 data=0x7
# KERNEL: itr=1 data=0x2
# KERNEL: itr=2 data=0x2
# KERNEL: itr=3 data=0x1
# KERNEL: itr=4 data=0x2
# KERNEL: itr=5 data=0x4
# KERNEL: itr=6 data=0x0
# KERNEL: itr=7 data=0x1
# KERNEL: itr=8 data=0x5
# KERNEL: itr=9 data=0x0
*/

//If this variable is randomized without any constraints, 
//then any value in this range will be assigned to the variable with equal probability.
//On successive randomization attempts the variable could end up having the same value, but the probability is 1/8.

//====randc

class Packet;
	randc int	 	count;
	randc byte 	 	master [$];
	randc bit [1:0] 	data [];

	...
endclass

//Variables declared as randc are random-cyclic and 
//hence cycle through all the values within their range before repeating any particular value.

class Packet;
	randc bit [2:0] data;
endclass

module tb;
	initial begin
		Packet pkt = new ();
		for (int i = 0 ; i < 10; i++) begin
			pkt.randomize ();
			$display ("itr=%0d data=0x%0h", i, pkt.data);
		end
	end
endmodule
//output
/*
# KERNEL: itr=0 data=0x6
# KERNEL: itr=1 data=0x3
# KERNEL: itr=2 data=0x4
# KERNEL: itr=3 data=0x7
# KERNEL: itr=4 data=0x0
# KERNEL: itr=5 data=0x1
# KERNEL: itr=6 data=0x5
# KERNEL: itr=7 data=0x2
# KERNEL: itr=8 data=0x5
# KERNEL: itr=9 data=0x0
*/