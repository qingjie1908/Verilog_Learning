//SystemVerilog Associative Array

//When size of a collection is unknown or the data space is sparse, 
//an associative array is a better option. 
//Associative arrays do not have any storage allocated until it is used, 
//and the index expression is not restricted to integral expressions, but can be of any type.

//An associative array implements a look-up table of the elements of its declared type. The data type to be used as an index serves as the lookup key and imposes an ordering.

//Syntax

// Value     Array_Name          [ key ];
// data_type    array_identifier    [ index_type ];

module tb;

	int   	array1 [int]; 			// An integer array with integer index
	int   	array2 [string]; 		// An integer array with string index
	string  array3 [string]; 		// A string array with string index

  	initial begin
      	// Initialize each dynamic array with some values
    	array1 = '{ 1 : 22,
	            	6 : 34 };

		array2 = '{ "Ross" : 100,
	            	"Joey" : 60 };

		array3 = '{ "Apples" : "Oranges",
	            	"Pears" : "44" };

      	// Print each array
      $display ("array1 = %p", array1);
      $display ("array2 = %p", array2);
      $display ("array3 = %p", array3);
    end
endmodule
//output
/*
# KERNEL: array1 = '{1:22, 6:34}
# KERNEL: array2 = '{"Joey":60, "Ross":100}
# KERNEL: array3 = '{"Apples":"Oranges", "Pears":"44"}
*/

module tb2;
    int      fruits_l0 [string];

    initial begin
      fruits_l0 = '{ "apple"  : 4,
                     "orange" : 10,
                     "plum"   : 9,
                     "guava"  : 1 };


      // size() : Print the number of items in the given dynamic array
      $display ("fruits_l0.size() = %0d", fruits_l0.size());


      // num() : Another function to print number of items in given array
      $display ("fruits_l0.num() = %0d", fruits_l0.num());


      // exists() : Check if a particular key exists in this dynamic array
      if (fruits_l0.exists ("orange"))
        $display ("Found %0d orange !", fruits_l0["orange"]);

      if (!fruits_l0.exists ("apricots"))
        $display ("Sorry, season for apricots is over ...");

      // Note: String indices are taken in alphabetical order
      // first() : Get the first element in the array
      begin
      	string f;
        // This function returns true if it succeeded and first key is stored
        // in the provided string "f"
        if (fruits_l0.first (f))
          $display ("fruits_l0.first [%s] = %0d", f, fruits_l0[f]);
      end

      // last() : Get the last element in the array
      begin
        string f;
        if (fruits_l0.last (f))
          $display ("fruits_l0.last [%s] = %0d", f, fruits_l0[f]);
      end

      // prev() : Get the previous element in the array
      begin
        string f = "orange";
        if (fruits_l0.prev (f))
          $display ("fruits_l0.prev [%s] = %0d", f, fruits_l0[f]);
      end

      // next() : Get the next item in the array
      begin
        string f = "orange";
        if (fruits_l0.next (f))
          $display ("fruits_l0.next [%s] = %0d", f, fruits_l0[f]);
      end
    end
endmodule
//output
/*
# KERNEL: fruits_l0.size() = 4
# KERNEL: fruits_l0.num() = 4
# KERNEL: Found 10 orange !
# KERNEL: Sorry, season for apricots is over ...
# KERNEL: fruits_l0.first [apple] = 4
# KERNEL: fruits_l0.last [plum] = 9
# KERNEL: fruits_l0.prev [guava] = 1
# KERNEL: fruits_l0.next [plum] = 9
*/

//=====Dynamic array of Associative arrays

module tb3;
  // Create an associative array with key of type string and value of type int
  // for each index in a dynamic array
  int fruits [] [string];
  // 1. fruits is 2-D array
  // 2. fruit [] is dynamic array
  // 3. each element in fruit [] is associative array int [string]; key is string, data is int

  initial begin
    // Create a dynamic array with size 2
    fruits = new [2];

    // Initialize the associative array inside each dynamic array index
    fruits [0] = '{ "apple" : 1, "grape" : 2 };
    fruits [1] = '{ "melon" : 3, "cherry" : 4 };

    // Iterate through each index of dynamic array
    foreach (fruits[i])
      // Iterate through each key of the current index in dynamic array
      foreach (fruits[i][fruit])
        $display ("fruits[%0d][%s] = %0d", i, fruit, fruits[i][fruit]);

  end
endmodule
//output
/*
# KERNEL: fruits[0][apple] = 1
# KERNEL: fruits[0][grape] = 2
# KERNEL: fruits[1][cherry] = 4
# KERNEL: fruits[1][melon] = 3
*/


//====Dynamic array within each index of an Associative array


// Create a new typedef that represents a dynamic array
typedef int int_da [];

module tb3;
  // Create an associative array where key is a string
  // and value is a dynamic array
  int_da fruits [string];
  // 1. replace int_da to int []
  // 2. becomes int fruits [string] []
  // 3. this is 2-D array
  // 4. first level is associative arry fruits [string]
  // 5. in each element of fruits [string] is an int [] (dynamic array, data is int)

  initial begin
    // For key "apple", create a dynamic array that can hold 2 items
    fruits ["apple"] = new [2];

    // Initialize the dynamic array with some values
    fruits ["apple"] = '{ 4, 5};

    // Iterate through each key, where key represented by str1
    foreach (fruits[str1])
      // Iterate through each item inside the current dynamic array ie.fruits[str1]
      foreach (fruits[str1][i])
        $display ("fruits[%s][%0d] = %0d", str1, i, fruits[str1][i]);

  end
endmodule
//output
/*
# KERNEL: fruits[apple][0] = 4
# KERNEL: fruits[apple][1] = 5
*/