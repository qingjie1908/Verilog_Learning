//Packages provide a mechanism for storing and sharing data, methods, property, parameters that can be re-used in multiple other modules, interfaces or programs. 
//They have explicitly named scopes that exist at the same level as the top-level module.
//all parameters and enumerations can be referenced via this scope.
//Putting such definitions and declarations inside a package also avoids cluttering the global namescope.
//Packages can then be imported into the current scope where items in that package can be used.

package my_pkg;
	typedef enum bit [1:0] { RED, YELLOW, GREEN, RSVD } e_signal;
	typedef struct { bit [3:0] signal_id;
                     bit       active;
                     bit [1:0] timeout;
                   } e_sig_param;

	function common ();
    	$display ("Called from somewhere");
   	endfunction

    task run ( ... );
    	...
    endtask
endpackage

//The package shown above can be imported into other modules and class scopes so that items defined in it can be re-used. 
//In the example below, we import everything defined in the package as indicated by the star * that follows :: operator, to be able to use any of the items.

// Import the package defined above to use e_signal
import my_pkg::*;

class myClass;
	e_signal 	my_sig;
endclass

module tb;
	myClass cls;

	initial begin
		cls = new ();
		cls.my_sig = GREEN;
		$display ("my_sig = %s", cls.my_sig.name());
		common ();
	end
endmodule
//package had to be imported for the compiler to recognize where GREEN is defined.

//Instead of importing all the definitions inside a package, you can also import them individually if you know exactly what is used in your piece of code.
import my_pkg::GREEN;
import my_pkg::e_signal;
import my_pkg::common;

//====Namespace Collision

//Consider the example below where the same definitions exist, 
//one at the top level 
//and the other via an imported package.

package my_pkg;
	typedef enum bit { READ, WRITE } e_rd_wr;
endpackage

import my_pkg::*;

typedef enum bit { WRITE, READ } e_wr_rd;

module tb;
	initial begin
        e_wr_rd  	opc1 = READ;
        //e_rd_wr  	opc2 = READ; //error
        //should use scope for READ in pkg
        e_rd_wr  	opc2 = my_pkg::READ;
      $display ("READ1 = %0d READ2 = %0d ", opc1, opc2);
	end
endmodule
//output:
//# KERNEL: READ1 = 1 READ2 = 0