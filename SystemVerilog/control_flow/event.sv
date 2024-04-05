//An event is a static object handle to synchronize between two or more concurrently active processes.
//One process will trigger the event, and another process waits for the event.

//Can be assigned or compared to other event variables
//Can be assigned to null
//When assigned to another event, both variables point to same synchronization object
//Can be passed to queues, functions and tasks

/*
event  over;                     // a new event is created called over
event  over_again = over;        // over_again becomes an alias to over
event  empty = null;             // event variable with no synchronization object
*/

//How to trigger and wait for an event?

//Named events can be triggered using -> or ->> operator
//Processes can wait for an event using @ operator or .triggered

module tb;

  // Create an event variable that processes can use to trigger and wait
  event event_a;

  // Thread1: Triggers the event using "->" operator
  initial begin
    #20 ->event_a;
    $display ("[%0t] Thread1: triggered event_a", $time);
  end

  // Thread2: Waits for the event using "@" operator
  initial begin
    $display ("[%0t] Thread2: waiting for trigger ", $time);
    @(event_a);
    $display ("[%0t] Thread2: received event_a trigger ", $time);
  end

  // Thread3: Waits for the event using ".triggered"
  initial begin
    $display ("[%0t] Thread3: waiting for trigger ", $time);
    wait(event_a.triggered);
    $display ("[%0t] Thread3: received event_a trigger", $time);
  end
endmodule
//output
/*
# KERNEL: [0] Thread2: waiting for trigger 
# KERNEL: [0] Thread3: waiting for trigger 
# KERNEL: [20] Thread1: triggered event_a
# KERNEL: [20] Thread2: received event_a trigger 
# KERNEL: [20] Thread3: received event_a trigger
*/

//====What is the difference between @ and .triggered ?

//An event's triggered state persists throughout the time step, 
//until simulation advances. 
//Hence if both wait for the event and trigger of the event happens at the same time there will be a race condition and the triggered property helps to avoid that.

//A process that waits on the triggered state always unblocks, regardless of the order of wait and trigger.

module tb2;

  // Create an event variable that processes can use to trigger and wait
  event event_a;

  // Thread1: Triggers the event using "->" operator at 20ns
  initial begin
    #20 ->event_a;
    $display ("[%0t] Thread1: triggered event_a", $time);
  end

  // Thread2: Starts waiting for the event using "@" operator at 20ns
  initial begin
    $display ("[%0t] Thread2: waiting for trigger ", $time);
    #20 @(event_a) begin
        //Note that Thread2 never received a trigger, because of the race condition between @ and -> operations.
        $display ("[%0t] Thread2: received event_a trigger ", $time);
    end
    
  end

  // Thread3: Starts waiting for the event using ".triggered" at 20ns
  initial begin
    $display ("[%0t] Thread3: waiting for trigger ", $time);
    #20 wait(event_a.triggered) begin
        $display ("[%0t] Thread3: received event_a trigger", $time);   
    end
   
  end
endmodule

//output
/*
# KERNEL: [0] Thread2: waiting for trigger 
# KERNEL: [0] Thread3: waiting for trigger 
# KERNEL: [20] Thread1: triggered event_a
# KERNEL: [20] Thread3: received event_a trigger
*/

//wait_order

//Waits for events to be triggered in the given order, and issues an error if any event executes out of order.

module tb3;
  // Declare three events that can be triggered separately
  event a, b, c;

  // This block triggers each event one by one
  initial begin
    #10 -> a;
    #10 -> b;
    #10 -> c;
  end

  // This block waits until each event is triggered in the given order
  initial begin

    wait_order (a,b,c)
    	$display ("Events were executed in the correct order");
    else
      	$display ("Events were NOT executed in the correct order !");
  end
endmodule
//output
/*
# KERNEL: Events were executed in the correct order
*/

//Merging Events

module tb4;

  // Create event variables
  event event_a, event_b;

  initial begin
    fork
      // Thread1: waits for event_a to be triggered
      begin
        wait(event_a.triggered);
        $display ("[%0t] Thread1: Wait for event_a is over", $time);
      end
  	  // Thread2: waits for event_b to be triggered
      begin
        wait(event_b.triggered);
        $display ("[%0t] Thread2: Wait for event_b is over", $time);
      end

      // Thread3: triggers event_a at 20ns
      #20 ->event_a;

      // Thread4: triggers event_b at 30ns
      #30 ->event_b;

      // Thread5: Assigns event_b to event_a at 10ns
      begin
        // Comment code below and try again to see Thread2 finish later
        #10 event_b = event_a;
      end
    join
  end
endmodule
//output
/*
[20] Thread1: Wait for event_a is over
*/
//why? no thread 2