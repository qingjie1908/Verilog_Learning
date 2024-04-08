//====Shallow Copy

//Contents in pkt will be copied into pkt2 when pkt is used along with the new() constructor for the new object.

Packet pkt, pkt2;

pkt = new;
pkt2 = new pkt;

//This method is known as a shallow copy,
//because all of the variables are copied across integers, strings, instance handles, etc
//but nested objects are not copied entirely
//Only their handles will be assigned to the new object and hence both the packets will point to the same nested object instance. 

class Header;
	int id;
	function new (int id);
		this.id = id;
	endfunction
	
	function showId();
		$display ("id=0x%0d", id);
	endfunction
endclass

class Packet;
	int 	addr;
	int 	data;
	Header 	hdr;
	
	function new (int addr, int data, int id);
		hdr = new (id);
		this.addr = addr;
		this.data = data;
	endfunction
	
	function display (string name);
		$display ("[%s] addr=0x%0h data=0x%0h id=%0d", name, addr, data, hdr.id);
	endfunction
endclass

module tb;
	Packet p1, p2;
	initial begin
		// Create a new pkt object called p1
		p1 = new (32'hface_cafe, 32'h1234_5678, 26);
		p1.display ("p1");
		
		// Shallow copy p1 into p2; p2 is a new object with contents in p1
		p2 = new p1;
		p2.display ("p2");
		
		// Now let's change the addr and id in p1
		p1.addr = 32'habcd_ef12;
		p1.data = 32'h5a5a_5a5a;
		p1.hdr.id = 17;
		p1.display ("p1");
		
		// Print p2 and see that hdr.id points to the hdr in p1, while
		// addr and data remain unchanged.
		p2.display ("p2");
	end
endmodule
//output
/*
# KERNEL: [p1] addr=0xfacecafe data=0x12345678 id=26
# KERNEL: [p2] addr=0xfacecafe data=0x12345678 id=26
# KERNEL: [p1] addr=0xabcdef12 data=0x5a5a5a5a id=17
# KERNEL: [p2] addr=0xfacecafe data=0x12345678 id=17
*/

//The class Packet contains a nested class called Header. 
//p2 was created as a copy of p1 using the shallow copy method
//only handles and not the entire object is copied,

//====Deep Copy

//A deep copy is where everything (including nested objects) is copied 
//and typically custom code is required for this purpose
Packet p1 = new;
Packet p2 = new;
p2.copy (p1);


//Let's add in a custom function called copy() within the Packet class to the example given above.

class Header;
	int id;
	function new (int id);
		this.id = id;
	endfunction
	
	function showId();
		$display ("id=0x%0d", id);
	endfunction
endclass

class Packet;
	int 	addr;
	int 	data;
	Header 	hdr;
	
	function new (int addr, int data, int id);
		hdr = new (id);
		this.addr = addr;
		this.data = data;
	endfunction
	
	function display (string name);
		$display ("[%s] addr=0x%0h data=0x%0h id=%0d", name, addr, data, hdr.id);
	endfunction

    //new add copy()
    function copy (Packet p);
        this.addr = p.addr;
        this.data = p.data;
        this.hdr.id = p.hdr.id;
    endfunction
endclass

module tb;
	Packet p1, p2;
	initial begin
		p1 = new (32'hface_cafe, 32'h1234_5678, 32'h1a);
		p1.display ("p1");
		
		p2 = new (1,2,3);  // give some values
		p2.copy (p1);
		p2.display ("p2");
		
		// Now let's change the addr and id in p1
		p1.addr = 32'habcd_ef12;
		p1.data = 32'h5a5a_5a5a;
		p1.hdr.id = 32'h11;
		p1.display ("p1");
		
		// Now let's print p2 - you'll see the changes made to p1 
		// will not affect p2
		p2.display ("p2");
	end
endmodule
//output
/*
# KERNEL: [p1] addr=0xfacecafe data=0x12345678 id=26
# KERNEL: [p2] addr=0xfacecafe data=0x12345678 id=26
# KERNEL: [p1] addr=0xabcdef12 data=0x5a5a5a5a id=17
# KERNEL: [p2] addr=0xfacecafe data=0x12345678 id=26
*/