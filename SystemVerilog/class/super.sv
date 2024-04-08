//The super keyword is used from within a sub-class to refer to properties and methods of the base class.
//It is mandatory to use the super keyword to access properties and methods if they have been overridden by the sub-class.

//The super keyword can only be used within a class scope that derives from a base class.
//Note that new method is implicitly defined for every class definition, and hence we do not need a new defintion in the base class Packet.
class Packet;
	int addr;
	function display ();
		$display ("[Base] addr=0x%0h", addr);
	endfunction
endclass

class extPacket extends Packet;                       // "extends" keyword necessary
	function new ();
		super.new ();
	endfunction
endclass

module tb;
	Packet p;
  	extPacket ep;

  	initial begin
      ep = new();
      p = new();
      p.display();
    end
endmodule
//output
/*
# KERNEL: [Base] addr=0x0
*/

//====Accessing base class methods

class Packet;
  int addr;

  function display ();
    $display ("[Base] addr=0x%0h", addr);
  endfunction
endclass

class extPacket extends Packet;
  function display();
    super.display();                          // Call base class display method
    $display ("[Child] addr=0x%0h", addr);
  endfunction

  function new ();
    super.new ();
  endfunction
endclass

module tb;
 	Packet p;
  	extPacket ep;

  	initial begin
      ep = new();
      p = new();
      ep.display();
    end
endmodule

//output
/*
# KERNEL: [Base] addr=0x0
# KERNEL: [Child] addr=0x0
*/