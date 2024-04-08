//A constructor is simply a method to create a new object of a particular class data-type.

//SystemVerilog, although not a programming language, is capable of simple construction of objects and automatic garbage collection.

//====When class constructor is explicity defined

// Define a class called "Packet" with a 32-bit variable to store address
// Initialize "addr" to 32'hfade_cafe in the new function, also called constructor
class Packet;
  bit [31:0] addr;

  function new ();
    addr = 32'hfade_cafe;
  endfunction
endclass

module tb;

  // Create a class handle called "pkt" and instantiate the class object
  initial begin
    // The class's constructor new() fn is called when the object is instantiated
    Packet pkt = new;

    // Display the class variable - Because constructor was called during
    // instantiation, this variable is expected to have 32'hfade_cafe;
    $display ("addr=0x%0h", pkt.addr);
  end
endmodule

//The new() function is called a class constructor and is a way to initialize the class variables with some value. 
//Note that it does not have a return type and is non-blocking.

//output
/*
# KERNEL: addr=0xfadecafe
*/

//====When class constructor is implicitly called

//If the class does not have a new() function explicitly coded, 
//an implicit new method will be automatically provided. 
//In this case, addr is initialized to zero since it is of type bit for which the default value is zero.

class Packet;
	bit [31:0] addr;
endclass

module tb;

  	// When the class object is instantiated, then the constructor is
  	// implicitly defined by the tool and called
	initial begin
		Packet pkt = new;
		$display ("addr=0x%0h", pkt.addr);
	end
endmodule

//output
/*
# KERNEL: addr=0x0
*/

//====Behavior of inherited classes

//The new method of the derived class will first call its parent class constructor using super.new(). 
//Once the base class constructor has completed, each property defined in the derived class will be initialized to a default value after which rest of the code within the new method will be executed.

// Define a simple class and initialize the class member "data" in new() function
class baseClass;
  bit [15:0] data;

  function new ();
    data = 16'hface;
  endfunction
endclass

// Define a child class extended from the above class with more members
// The constructor new() function accepts a value as argument, and by default is 2
class subClass extends baseClass;
  bit [3:0] id;
  bit [2:0] mode = 3;

  function new (int val = 2);
    // The new() function in child class calls the new function in
    // the base class using the "super" keyword
    super.new ();

    // Assign the value obtained through the argument to the class member
    id = val;
  endfunction
endclass

module tb;
  initial begin
    // Create two handles for the child class
    subClass  sc1, sc2;

    // Instantiate the child class and display member variable values
    sc1 = new ();
    $display ("data=0x%0h id=%0d mode=%0d", sc1.data, sc1.id, sc1.mode);

    // Pass a value as argument to the new function in this case and print
    sc2 = new (4);
    $display ("data=0x%0h id=%0d mode=%0d", sc2.data, sc2.id, sc2.mode);
  end
endmodule

//output
/*
# KERNEL: data=0xface id=2 mode=3
# KERNEL: data=0xface id=4 mode=3
*/

//====When the new function is declared as static or virtual

//A constructor can be declared as local or protected, 
//but not as static or virtual.

//====Typed constructors
//The difference here is that you can call the new() function of a subclass but assign it to the handle of a base class in a single statement. This is done by referencing the new() function of the subclass using scope operator :: as shown below
class C;
endclass

class D extends C;
endclass

module tb;
   initial begin
      C c = D::new;
   end
endmodule

//Variable c of base class C now references a newly constructed object of type D. This achieves the same effect as the code given below.
module tb;
	initial begin
		D d = new;
		C c = d;
	end
endmodule

