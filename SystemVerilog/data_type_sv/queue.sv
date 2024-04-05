//A SystemVerilog queue is a First In First Out 
//scheme which can have a variable size to store elements of the same data type.

//A bounded queue has a specific size and can hold a limited number of entries.
/*
[data_type]  [name_of_queue] [$:N];

int 	bounded_queue [$:10]; 	// Depth 10
*/

//An unbounded queue can have an unlimited number of entries.
/*
[data_type]  [name_of_queue] [$];

int 	unbounded_queue [$]; 	// Unlimited entries
*/

//Basic usage
/*
string       name_list [$];        // A queue of string elements
bit [3:0]    data [$];             // A queue of 4-bit elements

logic [7:0]  elements [$:127];     // A bounded queue of 8-bits with maximum size of 128 slots

int  q1 [$] =  { 1, 2, 3, 4, 5 };  // Integer queue, initialize elements
int  q2 [$];                       // Integer queue, empty
int  tmp;                          // Temporary variable to store values

tmp = q1 [0];                      // Get first item of q1 (index 0) and store in tmp
tmp = q1 [$];                      // Get last item of q1 (index 4) and store in tmp
q2  = q1;                          // Copy all elements in q1 into q2
q1  = {};                          // Empty the queue (delete all items)

q2[2] = 15;                        // Replace element at index 2 with 15
q2.insert (2, 15);                 // Inserts value 15 to index# 2
q2 = { q2, 22 };                   // Append 22 to q2
q2 = { 99, q2 };                   // Put 99 as the first element of q2
q2 = q2 [1:$];                     // Delete first item
q2 = q2 [0:$-1];                   // Delete last item
q2 = q2 [1:$-1];   
*/

module tb;
  	// Create a queue that can store "string" values
  	string   fruits[$] =  { "orange", "apple", "kiwi" };

	initial begin
   		// Iterate and access each queue element
  		foreach (fruits[i])
    		$display ("fruits[%0d] = %s", i, fruits[i]);

  		// Display elements in a queue
  		$display ("fruits = %p", fruits);

      	// Delete all elements in the queue
      	fruits = {};
      	$display ("After deletion, fruits = %p", fruits);
	end
endmodule
//output
/*
# KERNEL: fruits[0] = orange
# KERNEL: fruits[1] = apple
# KERNEL: fruits[2] = kiwi
# KERNEL: fruits = '{"orange", "apple", "kiwi"}
# KERNEL: After deletion, fruits = '{}
*/

//A slice expression selects a subset of the existing variable. Queue elements can be selected using slice expressions as shown in the example below.

module tb2;
	// Create a queue that can store "string" values
	string   fruits[$] =  { "orange", "apple", "lemon", "kiwi" };

	initial begin
		// Select a subset of the queue
		$display ("citrus fruits = %p", fruits[1:2]);

		// Get elements from index 1 to end of queue
		$display ("fruits = %p", fruits[1:$]);

		// Add element to the end of queue
		fruits[$+1] = "pineapple";
		$display ("fruits = %p", fruits);

		// Delete first element
		$display ("Remove orange, fruits = %p", fruits[1:$]);
	end
endmodule
//output
/*
# KERNEL: citrus fruits = '{"apple", "lemon"}
# KERNEL: fruits = '{"apple", "lemon", "kiwi"}
# KERNEL: fruits = '{"orange", "apple", "lemon", "kiwi", "pineapple"}
# KERNEL: Remove orange, fruits = '{"apple", "lemon", "kiwi", "pineapple"}
*/

//====Queue methods
/*
Methods	Description
function int size ();	Returns the number of items in the queue, 0 if empty
function void insert (input integer index, input element_t item);	Inserts the given item at the specified index position
function void delete ( [input integer index] );	Deletes the element at the specified index, and if not provided all elements will be deleted
function element_t pop_front ();	Removes and returns the first element of the queue
function element_t pop_back ();	Removes and returns the last element of the queue
function void push_front (input element_t item);	Inserts the given element at the front of the queue
function void push_back (input element_t item);	Inserts the given element at the end of the queue
*/

module tb3;
	string fruits[$] = {"apple", "pear", "mango", "banana"};

	initial begin
		// size() - Gets size of the given queue
		$display ("Number of fruits=%0d   fruits=%p", fruits.size(), fruits);

		// insert() - Insert an element to the given index
		fruits.insert (1, "peach");
		$display ("Insert peach, size=%0d fruits=%p", fruits.size(), fruits);

		// delete() - Delete element at given index
		fruits.delete (3);
		$display ("Delete mango, size=%0d fruits=%p", fruits.size(), fruits);

		// pop_front() - Pop out element at the front
		$display ("Pop %s,    size=%0d fruits=%p", fruits.pop_front(), fruits.size(), fruits);

		// push_front() - Push a new element to front of the queue
		fruits.push_front("apricot");
		$display ("Push apricot, size=%0d fruits=%p", fruits.size(), fruits);

		// pop_back() - Pop out element from the back
		$display ("Pop %s,   size=%0d fruits=%p", fruits.pop_back(), fruits.size(), fruits);

		// push_back() - Push element to the back
		fruits.push_back("plum");
		$display ("Push plum,    size=%0d fruits=%p", fruits.size(), fruits);
	end
endmodule
//output
/*
# KERNEL: Number of fruits=4   fruits='{"apple", "pear", "mango", "banana"}
# KERNEL: Insert peach, size=5 fruits='{"apple", "peach", "pear", "mango", "banana"}
# KERNEL: Delete mango, size=4 fruits='{"apple", "peach", "pear", "banana"}
# KERNEL: Pop apple,    size=3 fruits='{"peach", "pear", "banana"}
# KERNEL: Push apricot, size=4 fruits='{"apricot", "peach", "pear", "banana"}
# KERNEL: Pop banana,   size=3 fruits='{"apricot", "peach", "pear"}
# KERNEL: Push plum,    size=4 fruits='{"apricot", "peach", "pear", "plum"}
*/


//====create a queue of classes 
// Define a class with a single string member called "name"
class Fruit;
  string name;

  function new (string name="Unknown");
   	this.name = name;
  endfunction
endclass

module tb4;
  // Create a queue that can hold values of data type "Fruit"
  Fruit list [$];

  initial begin
    // Create a new class object and call it "Apple"
    // and push into the queue
    Fruit f = new ("Apple");
    list.push_back (f);

    // Create another class object and call it "Banana" and
    // push into the queue
    f = new ("Banana");
    list.push_back (f);

    // Iterate through queue and access each class object
    foreach (list[i])
      $display ("list[%0d] = %s", i, list[i].name);

    // Simply print the whole queue, note that class handles are printed
    // and not class object contents
    $display ("list = %p", list);
  end
endmodule
//output
/*
# KERNEL: list[0] = Apple
# KERNEL: list[1] = Banana
# KERNEL: list = '{'{name:"Apple"}, '{name:"Banana"}}
*/

//====create a queue of dynamic arrays
typedef string str_da [];

module tb5;
  // This is a queue of dynamic arrays
  str_da list [$];
  // 2-D array
  // string list [$][]
  // first level is unbound queue
  // second level each element in queue is string []

  initial begin
    // Initialize separate dynamic arrays with some values
    str_da marvel = '{"Spiderman", "Hulk", "Captain America", "Iron Man"};
    str_da dcWorld = '{"Batman", "Superman" };

    // Push the previously created dynamic arrays to queue
    list.push_back (marvel);
    list.push_back (dcWorld);

    // Iterate through the queue and access dynamic array elements
    foreach (list[i])
      foreach (list[i][j])
        $display ("list[%0d][%0d] = %s", i, j, list[i][j]);

    // Simply print the queue
    $display ("list = %p", list);
  end
endmodule
//output
/*
# KERNEL: list[0][0] = Spiderman
# KERNEL: list[0][1] = Hulk
# KERNEL: list[0][2] = Captain America
# KERNEL: list[0][3] = Iron Man
# KERNEL: list[1][0] = Batman
# KERNEL: list[1][1] = Superman
# KERNEL: list = '{'{"Spiderman", "Hulk", "Captain America", "Iron Man"}, '{"Batman", "Superman"}}
*/