//SystemVerilog randomization also works on array data structures like static arrays, dynamic arrays and queues. 
//The variable has to be declared with type rand or randc to enable randomization of the variable.

//====Static Arrays

//Randomization of static arrays are straight-forward and can be done similar to any other type of SystemVerilog variable.

class Packet;
  rand bit [3:0] 	s_array [7]; 	// Declare a static array with "rand"
endclass

module tb;
  Packet pkt;

  // Create a new packet, randomize it and display contents
  initial begin
    pkt = new();
    pkt.randomize();
    $display("queue = %p", pkt.s_array);
  end
endmodule
//output
/*
# KERNEL: queue = '{6, 5, 3, 4, 15, 13, 11}
*/

//====Dynamic Arrays

//Dynamic arrays are arrays where the size is not pre-determined during array declaration.
//These arrays can have variable size as new members can be added to the array at any time.

//Consider the example below where we declare a dynamic array as indicated by the empty square brackets [] of type rand. 
//A constraint is defined to limit the size of the dynamic array to be somewhere in between 5 and 10.
//Another constraint is defined to assign each element in the array with the value of its index.

//Randomization yields an empty array if the size is not constrainted 
//-> applicable for dynamic arrays and queues

class Packet;
  rand bit [3:0] 	d_array []; 	// Declare a dynamic array with "rand"

  // Constrain size of dynamic array between 5 and 10
  constraint c_array { d_array.size() > 5; d_array.size() < 10; }

  // Constrain value at each index to be equal to the index itself
  constraint c_val   { foreach (d_array[i])
    					d_array[i] == i;
                     }

  // Utility function to display dynamic array contents
  function void display();
    foreach (d_array[i])
      $display ("d_array[%0d] = 0x%0h", i, d_array[i]);
  endfunction
endclass

module tb;
  Packet pkt;

  // Create a new packet, randomize it and display contents
  initial begin
    pkt = new();
    pkt.randomize();
    pkt.display();
  end
endmodule
//output
/*
# KERNEL: d_array[0] = 0x0
# KERNEL: d_array[1] = 0x1
# KERNEL: d_array[2] = 0x2
# KERNEL: d_array[3] = 0x3
# KERNEL: d_array[4] = 0x4
# KERNEL: d_array[5] = 0x5
*/

//Queue randomization

class Packet;
  rand bit [3:0] 	queue [$]; 	// Declare a queue with "rand"

  // Constrain size of queue between 5 and 10
  constraint c_array { queue.size() == 4; }
endclass

module tb;
  Packet pkt;

  // Create a new packet, randomize it and display contents
  initial begin
    pkt = new();
    pkt.randomize();

    // Tip : Use %p to display arrays
    $display("queue = %p", pkt.queue);
  end
endmodule
//output
/*
# KERNEL: queue = '{6, 5, 3, 4}
*/
