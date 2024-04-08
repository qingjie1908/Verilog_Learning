//====Why do we need parameterization for classes ?

//At times it would be much easier to write a generic class which can be instantiated in multiple ways to achieve different array sizes or data types.
//Parameters are like constants that are local to the specified class.
//Classes are allowed to have default value for each parameter that can be overridden during class instantiation.

//Syntax

// Declare parameterized class
class <name_of_class> #(<parameters>);
class Trans #(addr = 32);

// Override class parameter
<name_of_class>  #(<parameters>) <name_of_inst>;
Trans #(.addr(16)) obj;

//example
// A class is parameterized by #()
// Here, we define a parameter called "size" and gives it
// a default value of 8. The "size" parameter is used to
// define the size of the "out" variable
class something #(int size = 8);
	bit [size-1:0] out;
endclass

module tb;

  // Override default value of 8 with the given values in #()
  something  #(16) sth1;                 // pass 16 as "size" to this class object
  something  #(.size (8)) sth2;          // pass 8 as "size" to this class object
  typedef something #(4) td_nibble;      // create an alias for a class with "size" = 4 as "td_nibble"
  td_nibble nibble;

  initial begin
    // 1. Instantiate class objects
    sth1 = new;
    sth2 = new;
  	nibble = new;

    // 2. Print size of "out" variable. $bits() system task will return
    // the number of bits in a given variable
    $display ("sth1.out   = %0d bits", $bits(sth1.out));
    $display ("sth2.out   = %0d bits", $bits(sth2.out));
    $display ("nibble.out = %0d bits", $bits(nibble.out));
  end
endmodule
//output
/*
# KERNEL: sth1.out   = 16 bits
# KERNEL: sth2.out   = 8 bits
# KERNEL: nibble.out = 4 bits
*/

//====Pass datatype as a parameter

//Data-type is parameterized in this case and can be overridden during instantiation. In the previous case, we defined parameters to have a specific value.
// "T" is a parameter that is set to have a default value of "int"
// Hence "items" will be "int" by default
class stack #(type T = int);
  T item;

  function T add_a (T a);
    return item + a;
  endfunction
endclass

module tb;
	stack 			 	st; 	// st.item is by default of int type
	stack #(bit[3:0]) 	bs; 	// bs.item will become a 4-bit vector
	stack #(real) 		rs; 	// rs.item will become a real number

  	initial begin
      st = new;
      bs = new;
      rs = new;

      // Assign different values, and add 10 to these values
      // Then print the result - Note the different values printed
      // that are affected by change in data type
      st.item = -456;
      $display ("st.item = %0d", st.add_a (10));

      bs.item = 8'hA1;
      $display ("bs.item = %0d", bs.add_a (10));

      rs.item = 3.14;
      $display ("rs.item = %0.2f", rs.add_a (10));
    end
endmodule
//output
/*
# KERNEL: st.item = -446
# KERNEL: bs.item = 11
# KERNEL: rs.item = 13.14
*/