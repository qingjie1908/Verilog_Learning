//Semaphore
//Semaphore is just like a bucket with a fixed number of keys.
//Processes that use a semaphore must first get a key from the bucket before they can continue to execute
//Other proceses must wait until keys are available in the bucket for them to use.
// In a sense, they are best used for mutual exclusion, access control to shared resources and basic synchronization.

//Syntax
/*
semaphore 	[identifier_name];
*/
/*
Name	Description
function new (int keyCount = 0);	Specifies number of keys initially allocated to the semaphore bucket
function void put (int keyCount = 1);	Specifies the number of keys being returned to the semaphore
task get (int keyCount = 1);	Specifies the number of keys to obtain from the semaphore
function int try_get (int keyCount = 1);	Specifies the required number of keys to obtain from the semaphore
*/

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