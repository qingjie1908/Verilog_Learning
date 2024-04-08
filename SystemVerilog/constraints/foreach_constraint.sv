//SystemVerilog provides the support to use foreach loop inside a constraint so that arrays can be constrained.

class ABC;
  rand bit[3:0] array [5];

  // This constraint will iterate through each of the 5 elements
  // in an array and set each element to the value of its
  // particular index
  constraint c_array { foreach (array[i]) {
    					array[i] == i;
  						}
                     }
endclass

module tb;

  initial begin
    ABC abc = new;
    abc.randomize();
    $display ("array = %p", abc.array);
  end
endmodule
//output
/*
# KERNEL: array = '{0, 1, 2, 3, 4}
*/

//====Dynamic Arrays/Queues

//Dynamic arrays and queues do not have a size at the time of declaration 
//and hence the foreach loop cannot be directly used.

//Therefore, the array's size has to be either assigned directly 
//or constrained as part of the set of constraints.

class ABC;
  rand bit[3:0] darray []; 		// Dynamic array -> size unknown
  rand bit[3:0] queue [$]; 		// Queue -> size unknown

  // Assign size for the queue if not already known
  constraint c_qsize  { queue.size() == 5; }

  // Constrain each element of both the arrays and queues
  constraint c_array  { foreach (darray[i])
    					  darray[i] == i;
                        foreach (queue[i])
                          queue[i] == i + 1;
                      }

    // Size of an array can be assigned using a constraint like
    // we have done for the queue, but let's assign the size before
    // calling randomization
    function new ();
		darray = new[5]; 	// Assign size of dynamic array
	endfunction
endclass

module tb;

  initial begin
    ABC abc = new;
    abc.randomize();
    $display ("array = %p\nqueue = %p", abc.darray, abc.queue);
  end
endmodule
//output
/*
# KERNEL: array = '{0, 1, 2, 3, 4}
# KERNEL: queue = '{1, 2, 3, 4, 5}
*/

//====Multidimensional Arrays
class ABC;
  rand bit[4:0][3:0] md_array [2][5]; 	// Multidimansional Arrays

  constraint c_md_array {
    foreach (md_array[i]) { //i = 0, 1
    	foreach (md_array[i][j]) { //j = 0,1,2,3,4
          foreach (md_array[i][j][k]) { //k = 0,1,2,3,4; each element is [3:0] 4bit data, and md_array[i][j] is packed 5*4=20 bit data
            if (k %2 == 0)
              md_array[i][j][k] == 'hF;
            else
              md_array[i][j][k] == 0;
        }
      }
    }
  }


endclass

module tb;

  initial begin
    ABC abc = new;
    abc.randomize();
    $display ("md_array = %p", abc.md_array);
  end
endmodule
//output
/*
# KERNEL: md_array = '{'{986895, 986895, 986895, 986895, 986895}, '{986895, 986895, 986895, 986895, 986895}}
*/
//another simulator
/*
md_array = '{'{'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f}, '{'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f, 'hf0f0f}}
*/

//====Multidimensional Dynamic Arrays
//Constraining a multi-dimensional dynamic array is a little more tricky and may not be supported by all simulators. 
class ABC;
  rand bit[3:0] md_array [][]; 	// Multidimansional Arrays with unknown size

  constraint c_md_array {
     // First assign the size of the first dimension of md_array
     md_array.size() == 2;

     // Then for each sub-array in the first dimension do the following:
     foreach (md_array[i]) {

        // Randomize size of the sub-array to a value within the range
        md_array[i].size() inside {[1:5]};

        // Iterate over the second dimension
        foreach (md_array[i][j]) {

           // Assign constraints for values to the second dimension
           md_array[i][j] inside {[1:10]};
         }
      }
   }

endclass

module tb;

  initial begin
    ABC abc = new;
    abc.randomize();
    $display ("md_array = %p", abc.md_array);
  end
endmodule
//output
/*
# KERNEL: md_array = '{'{1, 1, 6}, '{3}}
*/

//====Array Reduction Iterative Constraint
//Array reduction methods can produce a single value from an unpacked array of integral values.
// This can be used within a constraint to allow the expression to be considered during randomization.

class ABC;
  rand bit[3:0] array [5];

  // Intrepreted as int'(array[0]) + int'(array[1]) + .. + int'(array[4]) == 20;
  constraint c_sum { array.sum() with (int'(item)) == 20; }

endclass

module tb;
  initial begin
    ABC abc = new;
    abc.randomize();
    $display ("array = %p", abc.array);
  end
endmodule
//output
/*
# KERNEL: array = '{5, 1, 1, 4, 9}
*/