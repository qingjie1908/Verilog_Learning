//The bins construct allows the creation of a separate bin for each value in the given range of possible values of a coverage point variable.

coverpoint mode {
	// Manually create a separate bin for each value
	bins zero = {0};
	bins one  = {1};

	// Allow SystemVerilog to automatically create separate bins for each value
	// Values from 0 to maximum possible value is split into separate bins
	bins range[] = {[0:$]};

	// Create automatic bins for both the given ranges
	bins c[] = { [2:3], [5:7]};

	// Use fixed number of automatic bins. Entire range is broken up into 4 bins
	bins range[4] = {[0:$]};

	// If the number of bins cannot be equally divided for the given range, then
	// the last bin will include remaining items; Here there are 13 values to be
	// distributed into 4 bins which yields:
	// [1,2,3] [4,5,6] [7,8,9] [10, 1, 3, 6]
	bins range[4] = {[1:10], 1, 3, 6};

	// A single bin to store all other values that don't belong to any other bin
	bins others = default;
}

//example

module tb;
  bit [2:0] mode;

  // This covergroup does not get sample automatically because
  // the sample event is missing in declaration
  covergroup cg;
    coverpoint mode {
    	bins one = {1};
    	bins five = {5};
    }
  endgroup

  // Stimulus : Simply randomize mode to have different values and
  // manually sample each time
  initial begin
    cg cg_inst = new();
    for (int i = 0; i < 5; i++) begin
	  #10 mode = $random;
      $display ("[%0t] mode = 0x%0h", $time, mode);
      cg_inst.sample();
    end
    $display ("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
  end

endmodule
//output
/*
# KERNEL: [10] mode = 0x4
# KERNEL: [20] mode = 0x1
# KERNEL: [30] mode = 0x1
# KERNEL: [40] mode = 0x3
# KERNEL: [50] mode = 0x5
# KERNEL: Coverage = 100.00 %
*/

//====Automatic Bins

covergroup cg;
  coverpoint mode {

    // Declares a separate bin for each values -> Here there will be 8 bins
    bins range[] = {[0:$]};
  }
endgroup
//output
/*
# KERNEL: [10] mode = 0x4
# KERNEL: [20] mode = 0x1
# KERNEL: [30] mode = 0x1
# KERNEL: [40] mode = 0x3
# KERNEL: [50] mode = 0x5
# KERNEL: Coverage = 50.00 %
*/

//====Fixed Number of automatic bins

covergroup cg;
  coverpoint mode {

    // Declares 4 bins for the total range of 8 values
    // So bin0->[0:1] bin1->[2:3] bin2->[4:5] bin3->[6:7]
    bins range[4] = {[0:$]};
  }
endgroup
//output
/*
# KERNEL: [10] mode = 0x4
# KERNEL: [20] mode = 0x1
# KERNEL: [30] mode = 0x1
# KERNEL: [40] mode = 0x3
# KERNEL: [50] mode = 0x5
# KERNEL: Coverage = 75.00 %
*/

//====Split fixed number of bins between a given range

covergroup cg;
  coverpoint mode {

    // Defines 3 bins
    // Two bins for values from 1:4, and one bin for value 7
    // bin1->[1,2] bin2->[3,4], bin3->7
    bins range[3] = {[1:4], 7};
  }
endgroup
//output
/*
# KERNEL: [10] mode = 0x4
# KERNEL: [20] mode = 0x1
# KERNEL: [30] mode = 0x1
# KERNEL: [40] mode = 0x3
# KERNEL: [50] mode = 0x5
# KERNEL: Coverage = 66.67 %
*/