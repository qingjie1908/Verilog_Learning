//break

module tb;
  	initial begin

      // This for loop increments i from 0 to 9 and exit
      for (int i = 0 ; i < 10; i++) begin
        $display ("Iteration [%0d]", i);

        // Let's create a condition such that the
        // for loop exits when i becomes 7
        if (i == 7)
          break;
      end
    end
endmodule
//output
/*
# KERNEL: Iteration [0]
# KERNEL: Iteration [1]
# KERNEL: Iteration [2]
# KERNEL: Iteration [3]
# KERNEL: Iteration [4]
# KERNEL: Iteration [5]
# KERNEL: Iteration [6]
# KERNEL: Iteration [7]
*/


//continue
module tb2;
  	initial begin

      // This for loop increments i from 0 to 9 and exit
      for (int i = 0 ; i < 10; i++) begin

        // Let's create a condition such that the
        // for loop
        if (i == 7)
          continue;

        $display ("Iteration [%0d]", i);
      end
    end
endmodule
//output
/*
# KERNEL: Iteration [0]
# KERNEL: Iteration [1]
# KERNEL: Iteration [2]
# KERNEL: Iteration [3]
# KERNEL: Iteration [4]
# KERNEL: Iteration [5]
# KERNEL: Iteration [6]
# KERNEL: Iteration [8]
# KERNEL: Iteration [9]
*/