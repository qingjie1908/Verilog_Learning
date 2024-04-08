//====static variable
//When a variable inside a class is declared as static, that variable will be the only copy in all class instances.

class Packet;
	bit [15:0] 	addr;
	bit [7:0] 	data;
	static int 	static_ctr = 0;
		   int 	ctr = 0;

	function new (bit [15:0] ad, bit [7:0] d);
		addr = ad;
		data = d;
		static_ctr++;
		ctr++;
		$display ("static_ctr=%0d ctr=%0d addr=0x%0h data=0x%0h", static_ctr, ctr, addr, data);
	endfunction
endclass

module tb;
	initial begin
		Packet 	p1, p2, p3;
		p1 = new (16'hdead, 8'h12);
		p2 = new (16'hface, 8'hab);
		p3 = new (16'hcafe, 8'hfc);
	end
endmodule
//output
/*
# KERNEL: static_ctr=1 ctr=1 addr=0xdead data=0x12
# KERNEL: static_ctr=2 ctr=1 addr=0xface data=0xab
# KERNEL: static_ctr=3 ctr=1 addr=0xcafe data=0xfc
*/

//Declaring a variable as static can be very useful in cases where you want to know the total number of packets generated until a particular time.

//====static function
//A static method follows all class scoping and access rules,
//but the only difference being that it can be called outside the class even with no class instantiation.
//A static method has no access to non-static members 
//but it can directly access static class properties or call static methods of the same class.
//Also static methods cannot be virtual
//Static function calls using class names need to be made through the scope operator ::

class Packet;
	static int ctr=0;

   function new ();
      ctr++;
   endfunction

	static function get_pkt_ctr ();
		$display ("ctr=%0d", ctr);
	endfunction

endclass

module tb;
	Packet pkt [6];
	initial begin
		for (int i = 0; i < $size(pkt); i++) begin
			pkt[i] = new;
		end
		Packet::get_pkt_ctr(); 	// Static call using :: operator
		pkt[5].get_pkt_ctr(); 	// Normal call using instance
	end
endmodule
//output
/*
# KERNEL: ctr=6
# KERNEL: ctr=6
*/

//A static method has no access to non-static members 

class Packet;
	static int ctr=0;
   bit [1:0] mode;

   function new ();
      ctr++;
   endfunction

	static function get_pkt_ctr ();
		$display ("ctr=%0d mode=%0d", ctr, mode); //error, mode is non-static member, cannot be call in static function
	endfunction
endclass
