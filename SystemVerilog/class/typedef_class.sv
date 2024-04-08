//Sometimes the compiler errors out because of a class variable being used before the declaration of the class itself.
//This is because the compiler processes the first class where it finds a reference to the second class being that which hasn't been declared yet.

/*
class ABC;
	DEF 	def; 	// Error: DEF has not been declared yet
endclass

class DEF;
	ABC 	abc;
endclass
*/

//In such cases you have to provide a forward declaration for the second class using typedef keyword.
// When the compiler see a typedef class, it will know that a definition for the class will be found later in the same file.

typedef class DEF;  // Inform compiler that DEF might be
                    // used before actual class definition

class ABC;
	DEF 	def;      // Okay: Compiler knows that DEF
	                // declaration will come later
endclass

class DEF;
	ABC 	abc;
endclass

// It is not necessary to specify that DEF is of type class in the typedef statement.
/*
typedef DEF; 		// Legal

class ABC;
	DEF def;
endclass
*/

//====Using typedef with parameterized classes
//A typedef can also be used on classes with a parameterized port list as shown below.

typedef XYZ;

module top;
	XYZ #(8'h3f, real)              xyz0;   // positional parameter override
	XYZ #(.ADDR(8'h60), .T(real))   xyz1;  	// named parameter override
endmodule

class XYZ #(parameter ADDR = 8'h00, type T = int);
endclass