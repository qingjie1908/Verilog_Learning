//The scope resolution operator :: is used to refer an identifier within the scope of a class.
//Left hand side of the scope resolution operator :: should be a class type name, package name, covergroup type name, coverpoint or cross name, typedef name. 
//The right hand side of the operator should be an identifier like a variable or method name.

//====1. Defining extern function

class ABC;
	int 	data;

	extern virtual function void display();
endclass

// Definition of an external function using scope
// resolution operator
function void ABC::display();
	$display("data = 0x%0h", data);
endfunction

module tb;
	initial begin
		ABC abc = new();
		abc.data = 32'hface_cafe;
		abc.display();
	end
endmodule
//output
//# KERNEL: data = 0xfacecafe

//====2. Accessing static methods and functions

class ABC;
	static int 	data;

	static function void display();
		$display("data = 0x%0h", data);
	endfunction
endclass

module tb;
	initial begin
      	ABC a1, a2;

      	// Assign to static variable before creating
      	// class objects, and display using class_type and
      	// scope resolution operator
		ABC::data = 32'hface_cafe;
		ABC::display();

      	a1 = new();
      	a2 = new();
      	$display ("a1.data=0x%0h a2.data=0x%0h", a1.data, a2.data);
	end
endmodule
//output
/*
# KERNEL: data = 0xfacecafe
# KERNEL: a1.data=0xfacecafe a2.data=0xfacecafe
*/

//====3. Using package

package my_pkg;
	typedef enum bit {FALSE, TRUE} e_bool;
endpackage

module tb;
  bit val;

  initial begin
  	// Refer to types that have been declared
  	// in a package. Note that package has to
  	// be included in compilation but not
  	// necessarily "imported"
    val = my_pkg::TRUE;
    $display("val = 0x%0h", val);
  end
endmodule
//output
//# KERNEL: val = 0x1

//====4. Avoid namespace collision

package my_pkg;
	typedef enum bit {FALSE, TRUE} e_bool;
endpackage

import my_pkg::*;

module tb;
  typedef enum bit {TRUE, FALSE} e_bool;

  initial begin
    e_bool val;
    my_pkg::e_bool val1;

    val = TRUE;
    $display("val = 0x%0h", val);
    
    val1 = my_pkg::TRUE;
    $display("val1 = 0x%0h", val1);
    
  end
endmodule
//output
/*
# KERNEL: val = 0x0
# KERNEL: val1 = 0x1
*/