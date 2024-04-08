//====class handle
//A class variable such as pkt below is only a name by which that object is known. 
//It can hold the handle to an object of class Packet, 
//but until assigned with something it is always null. 
//At this point, the class object does not exist yet.

// Create a new class with a single member called
// count that stores integer values
class Packet;
	int count;
endclass

module tb;
  	// Create a "handle" for the class Packet that can point to an
  	// object of the class type Packet
  	// Note: This "handle" now points to NULL
	Packet pkt;

  	initial begin
      if (pkt == null)
        $display ("Packet handle 'pkt' is null");

      // Display the class member using the "handle"
      // Expect a run-time error because pkt is not an object
      // yet, and is still pointing to NULL. So pkt is not
      // aware that it should hold a member
      $display ("count = %0d", pkt.count);
  	end
endmodule
//output will have runtime error
/*
# KERNEL: Packet handle 'pkt' is null
# RUNTIME: Fatal Error: RUNTIME_0029 testbench.sv (19): Null pointer access.
*/

//====class object
//An instance of that class is created only when it's new() function is invoked.
//To reference that particular object again, we need to assign it's handle to a variable of type Packet.
// Create a new class with a single member called
// count that stores integer values
class Packet;
	int count;
endclass

module tb;
  	// Create a "handle" for the class Packet that can point to an
  	// object of the class type Packet
  	// Note: This "handle" now points to NULL
	Packet pkt;

  	initial begin
      if (pkt == null)
        $display ("Packet handle 'pkt' is null");

      // Call the new() function of this class
      pkt = new();

      if (pkt == null)
        $display ("What's wrong, pkt is still null ?");
      else
        $display ("Packet handle 'pkt' is now pointing to an object, and not NULL");

      // Display the class member using the "handle"
      $display ("count = %0d", pkt.count);
  	end
endmodule
//output
/*
# KERNEL: Packet handle 'pkt' is null
# KERNEL: Packet handle 'pkt' is now pointing to an object, and not NULL
# KERNEL: count = 0
*/