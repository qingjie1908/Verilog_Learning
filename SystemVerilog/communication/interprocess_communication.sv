//Interprocess Communication
//Components in a testbench often need to communicate with each other to exchange data and check output values of the design. 
//A few mechanisms that allow components or threads to affect the control flow of data are shown in the table below.
/*
Events	Different threads synchronize with each other via event handles in a testbench
Semaphores	Different threads might need to access the same resource; they take turns by using a semaphore
Mailbox	Threads/Components need to exchange data with each other; data is put in a mailbox and sent
*/

//====event
//An event is a way to synchronize two or more different processes. 
//One process waits for the event to happen 
//while another process triggers the event. 
//When the event is triggered, the process waiting for the event will resume execution.
/*
//1. Create an event using event
event 	eventA;  	// Creates an event called "eventA"

//2. Trigger an event using -> operator
->eventA; 		// Any process that has access to "eventA" can trigger the event

//3. Wait for event to happen
@eventA; 						// Use "@" operator to wait for an event
wait (eventA.triggered);		// Or use the wait statement with "eventA.triggered"
//4. Pass events as arguments to functions
*/

module tb_top;
	event eventA; 		// Declare an event handle called  "eventA"

	initial begin
		fork
			waitForTrigger (eventA);    // Task waits for eventA to happen
			#5 ->eventA;                // Triggers eventA
            #1 $display ("[%0t] Thread3 ongoing", $time);
		join
	end

	// The event is passed as an argument to this task. It simply waits for the event
	// to be triggered
	task waitForTrigger (event eventA);
		$display ("[%0t] Waiting for EventA to be triggered", $time);
		wait (eventA.triggered);
		$display ("[%0t] EventA has triggered", $time);
	endtask
endmodule
//output
/*
# KERNEL: [0] Waiting for EventA to be triggered
# KERNEL: [1] Thread3 ongoing
# KERNEL: [5] EventA has triggered
*/

//====semaphore
//A semaphore is used to control access to a resource 
//and is known as a mutex (mutually exclusive) 
//because only one entity can have the semaphore at a time.

module tb_top2;
   semaphore key; 				// Create a semaphore handle called "key"

   initial begin
      key = new (1); 			// Create only a single key; multiple keys are also possible
      fork
         personA (); 			// personA tries to get the room and puts it back after work
         personB (); 			// personB also tries to get the room and puts it back after work
         #25 personA (); 		// personA tries to get the room a second time
      join_none
   end

   task getRoom (bit [1:0] id);
      $display ("[%0t] Trying to get a room for id[%0d] ...", $time, id);
      key.get (1);
      $display ("[%0t] Room Key retrieved for id[%0d]", $time, id);
   endtask

   task putRoom (bit [1:0] id);
      $display ("[%0t] Leaving room id[%0d] ...", $time, id);
      key.put (1);
      $display ("[%0t] Room Key put back id[%0d]", $time, id);
   endtask

   // This person tries to get the room immediately and puts
   // it back 20 time units later
   task personA ();
      getRoom (1);
      #20 putRoom (1);
   endtask

  // This person tries to get the room after 5 time units and puts it back after
  // 10 time units
   task personB ();
      #5  getRoom (2);
      #10 putRoom (2);
   endtask
endmodule

//A semaphore object key is declared and created using new () function. Argument to new () defines the number of keys.
//you get the key by using the get () keyword which will wait until a key is available (blocking)
//You put the key back using the put () keyword

//output
/*
# KERNEL: [0] Trying to get a room for id[1] ...
# KERNEL: [0] Room Key retrieved for id[1]
# KERNEL: [5] Trying to get a room for id[2] ...
# KERNEL: [20] Leaving room id[1] ...
# KERNEL: [20] Room Key put back id[1]
# KERNEL: [20] Room Key retrieved for id[2]
# KERNEL: [25] Trying to get a room for id[1] ...
# KERNEL: [30] Leaving room id[2] ...
# KERNEL: [30] Room Key put back id[2]
# KERNEL: [30] Room Key retrieved for id[1]
# KERNEL: [50] Leaving room id[1] ...
# KERNEL: [50] Room Key put back id[1]
*/


//====mailbox
//A mailbox is like a dedicated channel established to send data between two components
//a mailbox can be created and the handles be passed to a data generator and a driver
//The generator can push the data object into the mailbox and the driver will be able to retrieve the packet

// Data packet in this environment
class transaction;
   rand bit [7:0] data;

   function display ();
      $display ("[%0t] Data = 0x%0h", $time, data);
   endfunction
endclass

// Generator class - Generate a transaction object and put into mailbox
class generator;
   mailbox mbx;

   function new (mailbox mbx);
      this.mbx = mbx;
   endfunction

   task genData ();
      transaction trns = new ();
      trns.randomize ();
      trns.display ();
      $display ("[%0t] [Generator] Going to put data packet into mailbox", $time);
      mbx.put (trns);
      $display ("[%0t] [Generator] Data put into mailbox", $time);
   endtask
endclass

// Driver class - Get the transaction object from Generator
class driver;
   mailbox mbx;

   function new (mailbox mbx);
      this.mbx = mbx;
   endfunction

   task drvData ();
      transaction drvTrns = new ();
      $display ("[%0t] [Driver] Waiting for available data", $time);
      mbx.get (drvTrns);
      $display ("[%0t] [Driver] Data received from Mailbox", $time);
      drvTrns.display ();
   endtask
endclass

// Top Level environment that will connect Gen and Drv with a mailbox
module tb_top3;
   mailbox   mbx;
   generator Gen;
   driver    Drv;

   initial begin
      mbx = new ();
      Gen = new (mbx);
      Drv = new (mbx);

      fork
         #10 Gen.genData ();
         Drv.drvData ();
      join_none
   end
endmodule
//output
/*
# KERNEL: [0] [Driver] Waiting for available data
# KERNEL: [10] Data = 0x8d
# KERNEL: [10] [Generator] Going to put data packet into mailbox
# KERNEL: [10] [Generator] Data put into mailbox
# KERNEL: [10] [Driver] Data received from Mailbox
# KERNEL: [10] Data = 0x8d
*/