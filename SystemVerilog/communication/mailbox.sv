//mailbox is a way to allow different processes to exchange data between each other
//mailboxes are created as having either a bounded or unbounded queue size

//Generic Mailbox that can accept items of any data type
//Parameterized Mailbox that can accept items of only a specific data type

module tb;
	// Create a new mailbox that can hold utmost 2 items
    // if the third new put, then wait first
    // until we have mbx.get() to release 1 space
    // then put() the third item
  	mailbox 	mbx = new(2);

  	// Block1: This block keeps putting items into the mailbox
  	// The rate of items being put into the mailbox is 1 every ns
  	initial begin
		for (int i=0; i < 5; i++) begin
        	#1 mbx.put (i);
        	$display ("[%0t] Thread0: Put item #%0d, size=%0d", $time, i, mbx.num());
      	end
    end

  	// Block2: This block keeps getting items from the mailbox
  	// The rate of items received from the mailbox is 2 every ns
	initial begin
		forever begin
			int idx;
			#2 mbx.get (idx);
          	$display ("[%0t] Thread1: Got item #%0d, size=%0d", $time, idx, mbx.num());
		end
	end
endmodule
//output
// at time 6, first got, release space, then put, 
/*
# KERNEL: [1] Thread0: Put item #0, size=1
# KERNEL: [2] Thread1: Got item #0, size=0
# KERNEL: [2] Thread0: Put item #1, size=1
# KERNEL: [3] Thread0: Put item #2, size=2
# KERNEL: [4] Thread1: Got item #1, size=1
# KERNEL: [4] Thread0: Put item #3, size=2
# KERNEL: [6] Thread1: Got item #2, size=2 (why??? already release 1 space)
# KERNEL: [6] Thread0: Put item #4, size=2
# KERNEL: [8] Thread1: Got item #3, size=1
# KERNEL: [10] Thread1: Got item #4, size=0
*/

//mailbox funtion and methods
/*
Function	Description
function new (int bound = 0);	Returns a mailbox handle, bound > 0 represents size of mailbox queue
function int num ();	Returns the number of messages currently in the mailbox
task put (singular message);	Blocking method that stores a message in the mailbox in FIFO order; message is any singular expression
function int try_put (singular message);	Non-blocking method that stores a message if the mailbox is not full, returns a postive integer if successful else 0
task get (ref singular message);	Blocking method until it can retrieve one message from the mailbox, if empty blocks the process
function int try_get (ref singular message);	Non-blocking method which tries to get one message from the mailbox, returns 0 if empty
task peek (ref singular message);	Copies one message from the mailbox without removing the message from the mailbox queue.
function int try_peek (ref singular message);	Tries to copy one message from the mailbox without removing the message from queue
*/

//====Parameterized mailboxes
//By default, a SystemVerilog mailbox is typeless and hence can send and receive objects of mixed data-types. 
//it can result in type mismatches during simulation time and result in errors.
//To constrain the mailbox to accept and send objects of a fixed data-type, it can be parameterized to that particular data-type.

// Create alias for parameterized "string" type mailbox
typedef mailbox #(string) s_mbox;

// Define a component to send messages
class comp1;

  	// Create a mailbox handle to put items
  	s_mbox 	names;

	// Define a task to put items into the mailbox
	task send ();
		for (int i = 0; i < 3; i++) begin
			string s = $sformatf ("name_%0d", i);
          #1 $display ("[%0t] Comp1: Put %s", $time, s);
			names.put(s);
		end
	endtask
endclass

// Define a second component to receive messages
class comp2;

	// Create a mailbox handle to receive items
	s_mbox 	list;


  	// Create a loop that continuously gets an item from
  	// the mailbox
	task receive ();
		forever begin
			string s;
			list.get(s);
          	$display ("[%0t]    Comp2: Got %s", $time, s);
		end
	endtask
endclass

// Connect both mailbox handles at a higher level
module tb2;
  	// Declare a global mailbox and create both components
  	s_mbox 	m_mbx    = new();
  	comp1 	m_comp1  = new();
  	comp2 	m_comp2  = new();

  	initial begin
      // Assign both mailbox handles in components with the
      // global mailbox
      m_comp1.names = m_mbx;
      m_comp2.list = m_mbx;

      // Start both components, where comp1 keeps sending
      // and comp2 keeps receiving
      fork
      	m_comp1.send();
        m_comp2.receive();
      join
    end
endmodule

//output
/*
# KERNEL: [1] Comp1: Put name_0
# KERNEL: [1]    Comp2: Got name_0
# KERNEL: [2] Comp1: Put name_1
# KERNEL: [2]    Comp2: Got name_1
# KERNEL: [3] Comp1: Put name_2
# KERNEL: [3]    Comp2: Got name_2
*/

//another way use this to connect two class's mailbox component
// Create alias for parameterized "string" type mailbox
typedef mailbox #(string) s_mbox;

// Define a component to send messages
class comp1;

  	// Create a mailbox handle to put items
  	s_mbox 	names;
  
  function new(s_mbox mbx);
    this.names =  mbx;
  endfunction

	// Define a task to put items into the mailbox
	task send ();
		for (int i = 0; i < 3; i++) begin
			string s = $sformatf ("name_%0d", i);
          #1 $display ("[%0t] Comp1: Put %s", $time, s);
			names.put(s);
		end
	endtask
endclass

// Define a second component to receive messages
class comp2;

	// Create a mailbox handle to receive items
	s_mbox 	list;
  
    function new(s_mbox mbx);
    	this.list =  mbx;
  	endfunction


  	// Create a loop that continuously gets an item from
  	// the mailbox
	task receive ();
		forever begin
			string s;
			list.get(s);
          	$display ("[%0t]    Comp2: Got %s", $time, s);
		end
	endtask
endclass

// Connect both mailbox handles at a higher level
module tb2;
  	// Declare a global mailbox and create both components
  	//s_mbox 	m_mbx    = new();
  s_mbox m_mbx = new();
  comp1 	m_comp1  = new(m_mbx);
  comp2 	m_comp2  = new(m_mbx);

  	initial begin
      // Assign both mailbox handles in components with the
      // global mailbox
      //m_comp1.names = m_mbx;
      //m_comp2.list = m_mbx;

      // Start both components, where comp1 keeps sending
      // and comp2 keeps receiving
      fork
      	m_comp1.send();
        m_comp2.receive();
      join
    end
endmodule