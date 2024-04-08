//In Inheritance, we saw that methods invoked by a base class handle which points to a child class instance 
//would eventually end up executing the base class method instead of the one in child class. 
//If that function in the base class was declared as virtual, only then the child class method will be executed.

bc = sc;            // Base class handle is pointed to a sub class

bc.display ();      // This calls the display() in base class and
                    // not the sub class as we might think

//====Without virtual keyword

// Without declaring display() as virtual
class Packet;
   int addr;

   function new (int addr);
      this.addr = addr;
   endfunction

   // This is a normal function definition which
   // starts with the keyword "function"
   function void display ();
		$display ("[Base] addr=0x%0h", addr);
   endfunction
endclass

class ExtPacket extends Packet;

	// This is a new variable only available in child class
	int data;

   function new (int addr, data);
      super.new (addr); 	// Calls 'new' method of parent class
      this.data = data;
   endfunction

	function display ();
		$display ("[Child] addr=0x%0h data=0x%0h", addr, data);
	endfunction
endclass

module tb;
   Packet bc;
   ExtPacket sc;

	initial begin
        sc = new (32'hfeed_feed, 32'h1234_5678);

        bc = sc;
		bc.display ();
	end
endmodule
//output
/*
# KERNEL: [Base] addr=0xfeedfeed
*/

//====With virtual keyword

class Packet;
   int addr;

   function new (int addr);
      this.addr = addr;
   endfunction

   // Here the function is declared as "virtual"
   // so that a different definition can be given
   // in any child class
   virtual function void display ();
		$display ("[Base] addr=0x%0h", addr);
	endfunction
endclass

class ExtPacket extends Packet;

	// This is a new variable only available in child class
	int data;

   function new (int addr, data);
      super.new (addr); 	// Calls 'new' method of parent class
      this.data = data;
   endfunction

	function void display (); // void is necessary so that to keep it identical to base class display function
        //otherwise compiler will not find its virtual version in base class
		$display ("[Child] addr=0x%0h data=0x%0h", addr, data);
	endfunction
endclass

module tb;
   Packet bc;
   ExtPacket sc;

	initial begin
        sc = new (32'hfeed_feed, 32'h1234_5678);

        bc = sc;
		bc.display ();
        //remember its calling child function, and display child object addr and data
        // bc.data still not exist
	end
endmodule
//output
/*
# KERNEL: [Child] addr=0xfeedfeed data=0x12345678
*/