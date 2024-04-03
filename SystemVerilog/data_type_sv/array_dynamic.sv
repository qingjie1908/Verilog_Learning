//A dynamic array is an unpacked array 
//whose size can be set or changed at run time, 
//and hence is quite different from a static array where the size is pre-determined during declaration of the array. 
//The default size of a dynamic array is zero 
//until it is set by the new() constructor.

//Syntax

//A dynamic array dimensions are specified by the empty square brackets [ ].
/*
[data_type] [identifier_name]  [];

bit [7:0] 	stack []; 		// A dynamic array of 8-bit vector
string 		names []; 		// A dynamic array that can contain strings
*/

//The new() function is used to allocate a size for the array and initialize its elements if required.

module tb;
	// Create a dynamic array that can hold elements of type int
	int 	array [];

	initial begin
		// Create a size for the dynamic array -> size here is 5
		// so that it can hold 5 values
		array = new [5];

		// Initialize the array with five values
		array = '{31, 67, 10, 4, 99};

		// Loop through the array and print their values
		foreach (array[i])
			$display ("array[%0d] = %0d", i, array[i]);
	end
endmodule
//output
/*
# KERNEL: array[0] = 31
# KERNEL: array[1] = 67
# KERNEL: array[2] = 10
# KERNEL: array[3] = 4
# KERNEL: array[4] = 99
*/

//Dynamic Array Methods
/*
Function	Description
function int size ();	Returns the current size of the array, 0 if array has not been created
function void delete ();	Empties the array resulting in a zero-sized array
*/

module tb2;
	// Create a dynamic array that can hold elements of type string
	string 	fruits [];

	initial begin
		// Create a size for the dynamic array -> size here is 5
		// so that it can hold 5 values
      	fruits = new [3];

		// Initialize the array with five values
      	fruits = '{"apple", "orange", "mango"};

      	// Print size of the dynamic array
		$display ("fruits.size() = %0d", fruits.size());

		// Empty the dynamic array by deleting all items
		fruits.delete();
		$display ("fruits.size() = %0d", fruits.size());
	end
endmodule
//output
/*
# KERNEL: fruits.size() = 3
# KERNEL: fruits.size() = 0
*/



/*
int array [];
array = new [10];

// This creates one more slot in the array, while keeping old contents
array = new [array.size() + 1] (array);
*/

module tb3;
	// Create two dynamic arrays of type int
	int array [];
	int id [];

	initial begin
		// Allocate 5 memory locations to "array" and initialize with values
		array = new [5];
		array = '{1, 2, 3, 4, 5};

		// Point "id" to "array"
		id = array;

		// Display contents of "id"
		$display ("id = %p", id);

		// Grow size by 1 and copy existing elements to the new dyn.Array "id"
		id = new [id.size() + 1] (id);

		// Assign value 6 to the newly added location [index 5]
		id [id.size() - 1] = 6;

		// Display contents of new "id"
		$display ("New id = %p", id);

		// Display size of both arrays
		$display ("array.size() = %0d, id.size() = %0d", array.size(), id.size());
	end
endmodule
//output
/*
# KERNEL: id = '{1, 2, 3, 4, 5}
# KERNEL: New id = '{1, 2, 3, 4, 5, 6}
# KERNEL: array.size() = 5, id.size() = 6
*/