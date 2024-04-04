//Array manipulation methods simply iterate through the array elements 
//and each element is used to evaluate the expression specified by the with clause.
// The iterator argument specifies a local variable that can be used within the with expression to refer to the current element in the iteration. 
//If an argument is not provided, 'item' is the name used by default.

//====Array Locator Methods
//The with clause and expresison is mandatory for some of these methods and for some others its optional.

//Mandatory 'with' clause
//These methods are used to filter out certain elements from an existing array based on a given expression. 
//All such elements that satisfy the given expression is put into an array and returned. 
//Hence the with clause is mandatory for the following methods.
/*
Method name	Description
find()	Returns all elements satisfying the given expression
find_index()	Returns the indices of all elements satisfying the given expression
find_first()	Returns the first element satisfying the given expression
find_first_index()	Returns the index of the first element satisfying the given expression
find_last()	Returns the last element satisfying the given expression
find_last_index()	Returns the index of the last element satisfying the given expression
*/

module tb;
  int array[9] = '{4, 7, 2, 5, 7, 1, 6, 3, 1};
  int res[$]; //A queue : is a data type where data can be either pushed into the queue or popped from the array.

  initial begin
    res = array.find(x) with (x > 3);
    $display ("find(x)         : %p", res);

    res = array.find_index with (item == 4);
    $display ("find_index      : res[%0d] = 4", res[0]);

    res = array.find_first with (item < 5 & item >= 3);
    $display ("find_first      : %p", res);

    res = array.find_first_index(x) with (x > 5);
    $display ("find_first_index: %p", res);

    res = array.find_last with (item <= 7 & item > 3);
    $display ("find_last       : %p", res);

    res = array.find_last_index(x) with (x < 3);
    $display ("find_last_index : %p", res);
  end
endmodule
//output
/*
# KERNEL: find(x)         : '{4, 7, 5, 7, 6}
# KERNEL: find_index      : res[0] = 4
# KERNEL: find_first      : '{4}
# KERNEL: find_first_index: '{1}
# KERNEL: find_last       : '{6}
# KERNEL: find_last_index : '{8}
*/

//Optional 'with' clause
/*
Methods	Description
min()	Returns the element with minimum value or whose expression evaluates to a minimum
max()	Returns the element with maximum value or whose expression evaluates to a maximum
unique()	Returns all elements with unique values or whose expression evaluates to a unique value
unique_index()	Returns the indices of all elements with unique values or whose expression evaluates to a unique value
*/

module tb2;
  int array[9] = '{4, 7, 2, 5, 7, 1, 6, 3, 1};
  int res[$];

  initial begin
    res = array.min();
    $display ("min          : %p", res);

    res = array.max();
    $display ("max          : %p", res);

    res = array.unique();
    $display ("unique       : %p", res);

    // expression x < 3 can only have unique value 0 and 1
    // so return first element <3 and first element >3
    // in this case, return 4 and 2
    res = array.unique(x) with (x < 3);
    $display ("unique       : %p", res);

    res = array.unique_index;
    $display ("unique_index : %p", res);
  end
endmodule
//output
//only keep one tb module in this file, then using command line 'verilator --binary array_methods.sv'
/*
min          : '{'h1} 
max          : '{'h7} 
unique       : '{'h4, 'h7, 'h2, 'h5, 'h1, 'h6, 'h3} 
unique       : '{'h4, 'h2} 
unique_index : '{'h0, 'h1, 'h2, 'h3, 'h5, 'h6, 'h7}
*/

//====Array Ordering Methods

//These methods operate 
//and alter the array directly.

//Method	Description
/*
reverse()	Reverses the order of elements in the array
sort()	Sorts the array in ascending order, optionally using with clause
rsort()	Sorts the array in descending order, optionally using with clause
shuffle()	Randomizes the order of the elements in the array. with clause is not allowed here.
*/

module tb2;
  int array[9] = '{4, 7, 2, 5, 7, 1, 6, 3, 1};

  initial begin
    array.reverse();
    $display ("reverse  : %p", array);

    array.sort();
    $display ("sort     : %p", array);

    array.rsort();
    $display ("rsort    : %p", array);

    for (int i = 0; i < 5; i++) begin
    	array.shuffle();
      $display ("shuffle Iter:%0d  = %p", i, array);
    end
  end
endmodule

//output
/*
# KERNEL: reverse  : '{1, 3, 6, 1, 7, 5, 2, 7, 4}
# KERNEL: sort     : '{1, 1, 2, 3, 4, 5, 6, 7, 7}
# KERNEL: rsort    : '{7, 7, 6, 5, 4, 3, 2, 1, 1}
# KERNEL: shuffle Iter:0  = '{1, 1, 7, 3, 5, 2, 6, 7, 4}
# KERNEL: shuffle Iter:1  = '{1, 7, 3, 4, 1, 6, 2, 7, 5}
# KERNEL: shuffle Iter:2  = '{6, 1, 7, 5, 1, 2, 3, 7, 4}
# KERNEL: shuffle Iter:3  = '{2, 7, 5, 6, 4, 1, 1, 3, 7}
# KERNEL: shuffle Iter:4  = '{3, 7, 2, 6, 5, 4, 7, 1, 1}
*/

//Using array ordering on classes

class Register;
  string name;
  rand bit [3:0] rank;
  rand bit [3:0] pages;

  function new (string name);
    this.name = name;
  endfunction

  function void print();
    $display("name=%s rank=%0d pages=%0d", name, rank, pages);
  endfunction

endclass

module tb3;
  Register rt[4];
  string name_arr[4] = '{"alexa", "siri", "google home", "cortana"};

  initial begin
    $display ("\n-------- Initial Values --------");
    foreach (rt[i]) begin
      rt[i] = new (name_arr[i]);
      rt[i].randomize();
      rt[i].print();
    end

    $display ("\n--------- Sort by name ------------");

    rt.sort(x) with (x.name);
    foreach (rt[i]) rt[i].print();

    $display ("\n--------- Sort by rank, pages -----------");

    rt.sort(x) with ( {x.rank, x.pages}); //first order rank, then order page
    foreach (rt[i]) rt[i].print();
  end
endmodule

//output
/*
# KERNEL: 
# KERNEL: -------- Initial Values --------
# KERNEL: name=alexa rank=8 pages=1
# KERNEL: name=siri rank=9 pages=15
# KERNEL: name=google home rank=14 pages=10
# KERNEL: name=cortana rank=3 pages=12
# KERNEL: 
# KERNEL: --------- Sort by name ------------
# KERNEL: name=alexa rank=8 pages=1
# KERNEL: name=cortana rank=3 pages=12
# KERNEL: name=google home rank=14 pages=10
# KERNEL: name=siri rank=9 pages=15
# KERNEL: 
# KERNEL: --------- Sort by rank, pages -----------
# KERNEL: name=cortana rank=3 pages=12
# KERNEL: name=alexa rank=8 pages=1
# KERNEL: name=siri rank=9 pages=15
# KERNEL: name=google home rank=14 pages=10
*/

//====Array Reduction Methods

//Method	Description
/*
sum()	Returns the sum of all array elements
product()	Returns the product of all array elements
and()	Returns the bitwise AND (&) of all array elements
or()	Returns the bitwise OR (|) of all array elements
xor()	Returns the bitwise XOR (^) of all array elements
*/

module tb;
  int array[4] = '{1, 2, 3, 4};
  int res[$];

  initial begin
    $display ("sum     = %0d", array.sum());
    $display ("product = %0d", array.product());
    $display ("and     = 0x%0h", array.and());
    $display ("or      = 0x%0h", array.or());
    $display ("xor     = 0x%0h", array.xor());
  end
endmodule
//output
/*
# KERNEL: sum     = 10
# KERNEL: product = 24
# KERNEL: and     = 0x0
# KERNEL: or      = 0x7
# KERNEL: xor     = 0x4
*/