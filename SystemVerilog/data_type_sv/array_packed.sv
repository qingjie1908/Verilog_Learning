//There are two types of arrays in SystemVerilog - packed and unpacked arrays.

//A packed array is used to refer to dimensions declared before the variable name.

//bit [3:0] 	data; 			// Packed array or vector
//logic 		queue [9:0]; 	// Unpacked array

//A packed array is guaranteed to be represented as a contiguous set of bits.

//A one-dimensional packed array is also called as a vector.

module tb;
	bit [7:0] 	m_data; 	// A vector or 1D packed array

	initial begin
		// 1. Assign a value to the vector
		m_data = 8'hA2;

		// 2. Iterate through each bit of the vector and print value
		for (int i = 0; i < $size(m_data); i++) begin
			$display ("m_data[%0d] = %b", i, m_data[i]);
		end
	end
endmodule
//output
/*
# KERNEL: m_data[0] = 0
# KERNEL: m_data[1] = 1
# KERNEL: m_data[2] = 0
# KERNEL: m_data[3] = 0
# KERNEL: m_data[4] = 0
# KERNEL: m_data[5] = 1
# KERNEL: m_data[6] = 0
# KERNEL: m_data[7] = 1
*/

//A multidimensional packed array is still a set of contiguous bits but are also segmented into smaller groups.
//The code shown below declares a 2D packed array that occupies 32-bits or 4 bytes and iterates through the segments and prints its value.

module tb2;
  bit [3:0][7:0] 	m_data; 	// A MDA, 4 bytes

	initial begin
		// 1. Assign a value to the MDA
		m_data = 32'hface_cafe;

      $display ("m_data = 0x%0h", m_data);

		// 2. Iterate through each segment of the MDA and print value
      for (int i = 0; i < $size(m_data); i++) begin
        $display ("m_data[%0d] = %b (0x%0h)", i, m_data[i], m_data[i]);
		end
	end
endmodule
//output
/*
# KERNEL: m_data = 0xfacecafe
# KERNEL: m_data[0] = 11111110 (0xfe)
# KERNEL: m_data[1] = 11001010 (0xca)
# KERNEL: m_data[2] = 11001110 (0xce)
# KERNEL: m_data[3] = 11111010 (0xfa)
*/

module tb3;
  bit [2:0][3:0][7:0] 	m_data; 	// An MDA, 12 bytes

	initial begin
		// 1. Assign a value to the MDA
      m_data[0] = 32'hface_cafe;
      m_data[1] = 32'h1234_5678;
      m_data[2] = 32'hc0de_fade;

      // m_data gets a packed value
      $display ("m_data = 0x%0h", m_data);

		// 2. Iterate through each segment of the MDA and print value
      foreach (m_data[i]) begin
        $display ("m_data[%0d] = 0x%0h", i, m_data[i]);
        foreach (m_data[i][j]) begin
          $display ("m_data[%0d][%0d] = 0x%0h", i, j, m_data[i][j]);
        end
      end
	end
endmodule
//output
/*
# KERNEL: m_data = 0xc0defade12345678facecafe
# KERNEL: m_data[2] = 0xc0defade
# KERNEL: m_data[2][3] = 0xc0
# KERNEL: m_data[2][2] = 0xde
# KERNEL: m_data[2][1] = 0xfa
# KERNEL: m_data[2][0] = 0xde
# KERNEL: m_data[1] = 0x12345678
# KERNEL: m_data[1][3] = 0x12
# KERNEL: m_data[1][2] = 0x34
# KERNEL: m_data[1][1] = 0x56
# KERNEL: m_data[1][0] = 0x78
# KERNEL: m_data[0] = 0xfacecafe
# KERNEL: m_data[0][3] = 0xfa
# KERNEL: m_data[0][2] = 0xce
# KERNEL: m_data[0][1] = 0xca
# KERNEL: m_data[0][0] = 0xfe
*/
