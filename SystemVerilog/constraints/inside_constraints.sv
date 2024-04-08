//Syntax

<variable> inside {<values or range>}

// Inverted "inside"
!(<variable> inside {<values or range>})

m_var inside {4, 7, 9} 		// Check if m_var is either 4,7 or 9
m_var inside {[10:100]} 	// Check if m_var is between 10 and 100 inclusive

//==== used in conditional statements
module tb;
	bit [3:0] 	m_data;
	bit 		flag;

	initial begin
		for (int i = 0; i < 10; i++) begin
			m_data = $random;

			// Used in a ternary operator
			flag = m_data inside {[4:9]} ? 1 : 0;

			// Used with "if-else" operators
			if (m_data inside {[4:9]})
				$display ("m_data=%0d INSIDE [4:9], flag=%0d", m_data, flag);
			else
				$display ("m_data=%0d outside [4:9], flag=%0d", m_data, flag);


		end
	end
endmodule
//output
/*
# KERNEL: m_data=4 INSIDE [4:9], flag=1
# KERNEL: m_data=1 outside [4:9], flag=0
# KERNEL: m_data=9 INSIDE [4:9], flag=1
# KERNEL: m_data=3 outside [4:9], flag=0
# KERNEL: m_data=13 outside [4:9], flag=0
# KERNEL: m_data=13 outside [4:9], flag=0
# KERNEL: m_data=5 INSIDE [4:9], flag=1
# KERNEL: m_data=2 outside [4:9], flag=0
# KERNEL: m_data=1 outside [4:9], flag=0
# KERNEL: m_data=13 outside [4:9], flag=0
*/

//====Used in constraints
class ABC;
	rand bit [3:0] 	m_var;

	// Constrain m_var to be either 3,4,5,6 or 7
	constraint c_var { m_var inside {[3:7]}; }
endclass

module tb;
	initial begin
		ABC abc = new();
		repeat (5) begin
			abc.randomize();
			$display("abc.m_var = %0d", abc.m_var);
		end

	end
endmodule
//output
/*
# KERNEL: abc.m_var = 7
# KERNEL: abc.m_var = 3
# KERNEL: abc.m_var = 3
# KERNEL: abc.m_var = 5
# KERNEL: abc.m_var = 4
*/

//====Inverted inside
class ABC;
	rand bit [3:0] 	m_var;

	// Inverted inside: Constrain m_var to be outside 3 to 7
	constraint c_var { !(m_var inside {[3:7]}); }
endclass

module tb;
	initial begin
		ABC abc = new();
		repeat (5) begin
			abc.randomize();
			$display("abc.m_var = %0d", abc.m_var);
		end

	end
endmodule
//output
/*
# KERNEL: abc.m_var = 15
# KERNEL: abc.m_var = 0
# KERNEL: abc.m_var = 1
# KERNEL: abc.m_var = 1
# KERNEL: abc.m_var = 2
*/