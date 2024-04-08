//====Why do we need randomness in the environment ?

//Directed tests take a long time to develop 
//because you have to think about all possible scenarios to verify different features. 
//There is a high possibility that you would miss some kind of corner cases. 
//So we want to be able to generate random values that fall within a valid range 
//and apply these random values to the signals we are interested in.

//====Why cannot we have any random value ?

//Simply running randomized tests do not make much sense 
//because there will be many invalid cases. 
//The way we create randomized tests with valid configurations is by the use of constraints. 
//Such a verification style is commonly called Constrained Random Verification (CRV).

//====How is randomization done in SystemVerilog ?

//To enable randomization on a variable, 
//you have to declare variables as either rand or randc.
//The difference between the two is that randc is cyclic in nature, and hence after randomization, the same value will be picked again only after all other values have been applied. 
//If randomization succeeds, randomize() will return 1, else 0.

//We can ensure that randomization has succeeded by using assert() function. 
//This is will avoid running simulations junk values that we may not figure until we look closer.

class myPacket;

	// Declare two variables for randomization
	// mode is of type rand and hence any random value between 0 and 3 can be picked each time
	// key is of type randc and hence random values between 0 and 7 can be picked and
	// values will be repeated only after all other values have been already taken
	rand   bit [1:0]    mode;
	randc  bit [2:0]    key;

	// These statements are called constraints that help us to limit
	// the randomness within specified ranges
	// mode is constrained to have a value less than 3 (excluding)
	// key is constrained to have a value between 2 and 7 (excluding)
	constraint c_mode1 { mode < 3; }
	constraint c_key1  { key > 2;
                         key < 7; }

    // This is just a function to display current values of these variables
    function display ();
       $display ("Mode : 0x%0h Key : 0x%0h", mode, key);
    endfunction
endclass

module tb_top;

	// Create a class object handle
	myPacket pkt;

	initial begin

		// Instantiate the object, and allocate memory to this variable
		pkt = new ();

		// Let's just randomize the class object 15 times and display all the
		// values randomization yielded each time
		for (int i = 0; i < 15; i++) begin

			// By using assert(), we are ensuring that randomization is successful.
            // pkt.randomize() will random the value in different loop
            // without pkt.randomize() all loop value is the same as first one
			assert (pkt.randomize ());
			pkt.display ();
		end
	end
endmodule
//output
/*
# KERNEL: Mode : 0x0 Key : 0x4
# KERNEL: Mode : 0x1 Key : 0x6
# KERNEL: Mode : 0x1 Key : 0x3
# KERNEL: Mode : 0x0 Key : 0x5
# KERNEL: Mode : 0x1 Key : 0x4
# KERNEL: Mode : 0x1 Key : 0x5
# KERNEL: Mode : 0x0 Key : 0x6
# KERNEL: Mode : 0x1 Key : 0x3
# KERNEL: Mode : 0x1 Key : 0x6
# KERNEL: Mode : 0x1 Key : 0x3
# KERNEL: Mode : 0x1 Key : 0x5
# KERNEL: Mode : 0x0 Key : 0x4
# KERNEL: Mode : 0x1 Key : 0x4
# KERNEL: Mode : 0x1 Key : 0x3
# KERNEL: Mode : 0x1 Key : 0x6
*/
//Notice that randomization of Mode has resulted in repetitive values,
// while for Key, the values are cyclic in nature (3,4,5,6 is a complete set).

//====What are the different constraint styles ?

//You can write constraints in a variety of ways. 
//Constraints should not contradict each other, 
//else randomization will fail at run-time.

class myPacket;
	rand   bit [7:0] mode;
	randc  bit [7:0] key;
	int  low, high;

	constraint c_simple {  mode > 2;
	                       key == 3; }

// This won't work, because it contradicts c_simple - Run-time error
//	constraint c_key    {  key < 2; }

// This won't work either, because of wrong syntax - you can't specify it this way
//  constraint c_signs  {  0 < key < 4; }

    constraint c_range  { key inside {[low:high]};
    					mode inside {[21:50]};
    					mode inside {23, 24, 51}; }

// Choose any value other than 2,3,4,5
    constraint c_invert { !(key inside {[2:5]}); }

// Choose 10 or 22 ; with equal probability even if 10 and 20 appeared multiple times
    constraint c_weight { mode inside {10, 10, 10, 22, 22};

// 4 has 50/130 chance, 43 has 10/130 chance, any value between 45:90 has 70/130 chance
    constraint c_key_dist  { key  dist {4:=50, 43:=10, [45:90]:=70 };

// 4 has 10/100 chance, 43 has 30/100 chance, any value between 45:47 has 20/100 chance
    constraint c_mode_dist { mode dist {4:/10, 43:/30, [45:47]:/60 };

    function void pre_randomize ();
       this.low = 1;
       this.high = 2;
    endfunction
endclass