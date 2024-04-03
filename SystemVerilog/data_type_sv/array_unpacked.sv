//An unpacked array is used to refer to dimensions declared after the variable name.

//Unpacked arrays may be fixed-size arrays, dynamic arrays, associative arrays or queues.

//Single Dimensional Unpacked Array
module tb;
	byte 	stack [8]; 		// depth = 8, 1 byte wide variable

	initial begin
		// Assign random values to each slot of the stack
		foreach (stack[i]) begin
			stack[i] = $random;
			$display ("Assign 0x%0h to index %0d", stack[i], i);
		end

		// Print contents of the stack
		$display ("stack = %p", stack);
	end
endmodule

//output
/*
# KERNEL: Assign 0x24 to index 0
# KERNEL: Assign 0x81 to index 1
# KERNEL: Assign 0x9 to index 2
# KERNEL: Assign 0x63 to index 3
# KERNEL: Assign 0xd to index 4
# KERNEL: Assign 0x8d to index 5
# KERNEL: Assign 0x65 to index 6
# KERNEL: Assign 0x12 to index 7
# KERNEL: stack = '{36, -127, 9, 99, 13, -115, 101, 18}
*/

//Multidimensional Unpacked Array
module tb2;
  byte 	stack [2][4]; 		// 2 rows, 4 cols

	initial begin
		// Assign random values to each slot of the stack
		foreach (stack[i])
          foreach (stack[i][j]) begin
            stack[i][j] = $random;
            $display ("stack[%0d][%0d] = 0x%0h", i, j, stack[i][j]);
			end

		// Print contents of the stack
		$display ("stack = %p", stack);
	end
endmodule
//output
/*
# KERNEL: stack[0][0] = 0x24
# KERNEL: stack[0][1] = 0x81
# KERNEL: stack[0][2] = 0x9
# KERNEL: stack[0][3] = 0x63
# KERNEL: stack[1][0] = 0xd
# KERNEL: stack[1][1] = 0x8d
# KERNEL: stack[1][2] = 0x65
# KERNEL: stack[1][3] = 0x12
# KERNEL: stack = '{'{36, -127, 9, 99}, '{13, -115, 101, 18}}
*/

//Packed + Unpacked Array
//The example shown below illustrates a multidimensional packed + unpacked array.

module tb3;
  bit [3:0][7:0] 	stack [2][4]; 		// 2 rows, 4 cols

	initial begin
		// Assign random values to each slot of the stack
		foreach (stack[i])
          foreach (stack[i][j]) begin
            stack[i][j] = $random;
            $display ("stack[%0d][%0d] = 0x%0h", i, j, stack[i][j]);
			end

		// Print contents of the stack
		$display ("stack = %p", stack);

		// Print content of a given index
        $display("stack[0][0][2] = 0x%0h", stack[0][0][2]);
	end
endmodule
//output
/*
# KERNEL: stack[0][0] = 0x12153524
# KERNEL: stack[0][1] = 0xc0895e81
# KERNEL: stack[0][2] = 0x8484d609
# KERNEL: stack[0][3] = 0xb1f05663
# KERNEL: stack[1][0] = 0x6b97b0d
# KERNEL: stack[1][1] = 0x46df998d
# KERNEL: stack[1][2] = 0xb2c28465
# KERNEL: stack[1][3] = 0x89375212
# KERNEL: stack = '{'{303379748, 3230228097, 2223298057, 2985317987}, '{112818957, 1189058957, 2999092325, 2302104082}}
# KERNEL: stack[0][0][2] = 0x15
*/

//In a multidimensional declaration, the dimensions declared before the name vary more faster than the dimensions following the name.
/* the inner most element vary most fast
bit 	[1:4] 		m_var 	[1:5]			// 1:4 varies faster than 1:5
bit 				m_var2 	[1:5] [1:3]  	// 1:3 varies faster than 1:5
bit 	[1:3] [1:7] m_var3; 				// 1:7 varies faster than 1:3

bit 	[1:3] [1:2] m_var4 [1:7] [0:2] 		// 1:2 varies most rapidly, followed by 1:3, then 0:2 and then 1:7
*/