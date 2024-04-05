//thread / process
//A thread or process is any piece of code that gets executed as a separate entity.
//In verilog, each of the initial and always blocks are spawned off as separate threads that start to run in parallel from zero time. 
//A fork join block also creates different threads that run in parallel.

/*
fork join	Finishes when all child threads are over
fork join_any	Finishes when any child thread gets over
fork join_none	Finishes soon after child threads are spawned
*/

//====frok join
//The main thread stays suspended until all the threads spawned by the fork is completed. 
//Any block of code within begin and end are considered as a separate thread,
module tb;
	initial begin
      $display ("[%0t] Main Thread: Fork join going to start", $time);
		fork
			// Thread 1
			#30 $display ("[%0t] Thread1 finished", $time);

			// Thread 2
          	begin
              	#5 $display ("[%0t] Thread2 ...", $time);
				#10 $display ("[%0t] Thread2 finished", $time);
            end

            // Thread 3
			#20 $display ("[%0t] Thread3 finished", $time);
		join
      $display ("[%0t] Main Thread: Fork join has finished", $time);
	end
endmodule
//output
/*
# KERNEL: [0] Main Thread: Fork join going to start
# KERNEL: [5] Thread2 ...
# KERNEL: [15] Thread2 finished
# KERNEL: [20] Thread3 finished
# KERNEL: [30] Thread1 finished
# KERNEL: [30] Main Thread: Fork join has finished
*/

//Nested fork join
module tb2;
	initial begin
      $display ("[%0t] Main Thread: Fork join going to start", $time);
		fork
			fork
              print (20, "Thread1_0");
              print (30, "Thread1_1"); // these two print are seperate statements without begin end, so they are seperate thread, start at the same time
            join
          print (10, "Thread2");
		join
      $display ("[%0t] Main Thread: Fork join has finished", $time);
	end

  // Note that this task has to be automatic
  task automatic print (int _time, string t_name);
    #(_time) $display ("[%0t] %s", $time, t_name);
  endtask
endmodule
//output
/*
# KERNEL: [0] Main Thread: Fork join going to start
# KERNEL: [10] Thread2
# KERNEL: [20] Thread1_0
# KERNEL: [30] Thread1_1
# KERNEL: [30] Main Thread: Fork join has finished
*/

module tb3;
	initial begin
      $display ("[%0t] Main Thread: Fork join going to start", $time);
		fork
			fork 
            // These two state ments are without begin end so they are two seperate threads
              #50 $display ("[%0t] Thread1_0 ...", $time);
              #70 $display ("[%0t] Thread1_1 ...", $time);
              begin
                #10 $display ("[%0t] Thread1_2 ...", $time);
                #100 $display ("[%0t] Thread1_2 finished", $time);
              end
            join

			// Thread 2
          	begin
              	#5 $display ("[%0t] Thread2 ...", $time);
				#10 $display ("[%0t] Thread2 finished", $time);
            end

            // Thread 3
			#20 $display ("[%0t] Thread3 finished", $time);
		join
      $display ("[%0t] Main Thread: Fork join has finished", $time);
	end
endmodule
//output
/*
# KERNEL: [0] Main Thread: Fork join going to start
# KERNEL: [5] Thread2 ...
# KERNEL: [10] Thread1_2 ...
# KERNEL: [15] Thread2 finished
# KERNEL: [20] Thread3 finished
# KERNEL: [50] Thread1_0 ...
# KERNEL: [70] Thread1_1 ...
# KERNEL: [110] Thread1_2 finished
# KERNEL: [110] Main Thread: Fork join has finished
*/

//fork join_any
//If five threads are launched, 
//the main thread will resume execution only when any one of the five threads finish execution.

module tb4;
	initial begin
      $display ("[%0t] Main Thread: Fork join going to start", $time);
		fork
          print (20, "Thread1_0");
          print (30, "Thread1_1");
          print (10, "Thread2");
        join_any
      $display ("[%0t] Main Thread: Fork join has finished", $time);
	end

  // Note that this task needs to be automatic
  task automatic print (int _time, string t_name);
    #(_time) $display ("[%0t] %s", $time, t_name);
  endtask
endmodule
//output
/*
# KERNEL: [0] Main Thread: Fork join going to start
# KERNEL: [10] Thread2
# KERNEL: [10] Main Thread: Fork join has finished
# KERNEL: [20] Thread1_0
# KERNEL: [30] Thread1_1
*/

//Nested fork join_any
module tb5;
	initial begin
      $display ("[%0t] Main Thread: Fork join going to start", $time);
		fork
			fork
              print (20, "Thread1_0");
              print (30, "Thread1_1");
            join_any
          print (10, "Thread2");
        join_any
      $display ("[%0t] Main Thread: Fork join has finished", $time);
	end

  // Note that this task has to be automatic
  task automatic print (int _time, string t_name);
    #(_time) $display ("[%0t] %s", $time, t_name);
  endtask
endmodule
//output
/*
# KERNEL: [0] Main Thread: Fork join going to start
# KERNEL: [10] Thread2
# KERNEL: [10] Main Thread: Fork join has finished
# KERNEL: [20] Thread1_0
# KERNEL: [30] Thread1_1
*/

//====fork join_none
//main thread to resume execution of further statements that lie after the fork regardless of whether the forked threads finish.
module tb6;
	initial begin
      $display ("[%0t] Main Thread: Fork join going to start", $time);
		fork
          print (20, "Thread1_0");
          print (30, "Thread1_1");
          print (10, "Thread2");
		join_none
      $display ("[%0t] Main Thread: Fork join has finished", $time);
	end

  // Note that we need automatic task
  task automatic print (int _time, string t_name);
    #(_time) $display ("[%0t] %s", $time, t_name);
  endtask
endmodule
//output
/*
# KERNEL: [0] Main Thread: Fork join going to start
# KERNEL: [0] Main Thread: Fork join has finished
# KERNEL: [10] Thread2
# KERNEL: [20] Thread1_0
# KERNEL: [30] Thread1_1
*/

//nested fork join_none
module tb7;
	initial begin
      $display ("[%0t] Main Thread: Fork join going to start", $time);
		fork
          begin
			fork
              print (20, "Thread1_0");
              print (30, "Thread1_1");
            join_none
            $display("[%0t] Nested fork has finished", $time);
          end
          print (10, "Thread2");
        join_none
      $display ("[%0t] Main Thread: Fork join has finished", $time);
	end

  // Note that we need automatic task
  task automatic print (int _time, string t_name);
    #(_time) $display ("[%0t] %s", $time, t_name);
  endtask
endmodule
//output
/*
# KERNEL: [0] Main Thread: Fork join going to start
# KERNEL: [0] Main Thread: Fork join has finished
# KERNEL: [0] Nested fork has finished
# KERNEL: [10] Thread2
# KERNEL: [20] Thread1_0
# KERNEL: [30] Thread1_1
*/


//====disable fork

//Thread2 and Thread3 are still running even though the main thread has come out of fork join_any block.
module tb_top8;

	initial begin
   		// Fork off 3 sub-threads in parallel and the currently executing main thread
      	// will finish when any of the 3 sub-threads have finished.
		fork

         // Thread1 : Will finish first at time 40ns
         #40 $display ("[%0t ns] Show #40 $display statement", $time);

         // Thread2 : Will finish at time 70ns
         begin
            #20 $display ("[%0t ns] Show #20 $display statement", $time);
            #50 $display ("[%0t ns] Show #50 $display statement", $time);
         end

         // Thread3 : Will finish at time 60ns
          #60 $display ("[%0t ns] TIMEOUT", $time);
      join_any

      // Display as soon as the fork is done
      $display ("[%0tns] Fork join is done, let's disable fork", $time);
   end
endmodule
//output
/*
# KERNEL: [20 ns] Show #20 $display statement
# KERNEL: [40 ns] Show #40 $display statement
# KERNEL: [40ns] Fork join is done, let's disable fork
# KERNEL: [60 ns] TIMEOUT
# KERNEL: [70 ns] Show #50 $display statement
*/

module tb_top9;

	initial begin
   		// Fork off 3 sub-threads in parallel and the currently executing main thread
      	// will finish when any of the 3 sub-threads have finished.
		fork

         // Thread1 : Will finish first at time 40ns
         #40 $display ("[%0t ns] Show #40 $display statement", $time);

         // Thread2 : Will finish at time 70ns
         begin
            #20 $display ("[%0t ns] Show #20 $display statement", $time);
            #50 $display ("[%0t ns] Show #50 $display statement", $time);
         end

         // Thread3 : Will finish at time 60ns
          #60 $display ("[%0t ns] TIMEOUT", $time);
      join_any

      // Display as soon as the fork is done
      $display ("[%0tns] Fork join is done, let's disable fork", $time);

    //Note that Thread2 and Thread3 got killed after main initial block finish because of disable fork
      disable fork;
   end
endmodule
//output
/*
# KERNEL: [20 ns] Show #20 $display statement
# KERNEL: [40 ns] Show #40 $display statement
# KERNEL: [40ns] Fork join is done, let's disable fork
*/

//====wait fork 
//allows the main process to wait until all forked processes are over.
//'wait fork' will waite all the fork before this wait fork statement
//
module tb_top10;

	initial begin
		// Fork off 3 sub-threads in parallel and the currently executing main thread
		// will finish when any of the 3 sub-threads have finished.
		fork

			// Thread1 : Will finish first at time 40ns
			#40 $display ("[%0t ns] Show #40 $display statement", $time);

			// Thread2 : Will finish at time 70ns
			begin
				#20 $display ("[%0t ns] Show #20 $display statement", $time);
				#50 $display ("[%0t ns] Show #50 $display statement", $time);
			end

			// Thread3 : Will finish at time 60ns
			#60 $display ("[%0t ns] TIMEOUT", $time);
		join_any

		// Display as soon as the fork is done
      	$display ("[%0t ns] Fork join is done, wait fork to end", $time);

      	// Wait until all forked processes are over and display
      	wait fork;
      	$display ("[%0t ns] Fork join is over", $time);
   end
endmodule
//output
/*
# KERNEL: [20 ns] Show #20 $display statement
# KERNEL: [40 ns] Show #40 $display statement
# KERNEL: [40 ns] Fork join is done, wait fork to end
# KERNEL: [60 ns] TIMEOUT
# KERNEL: [70 ns] Show #50 $display statement
# KERNEL: [70 ns] Fork join is over
*/

module tb_top11;

	initial begin
		// Fork off 3 sub-threads in parallel and the currently executing main thread
		// will finish when any of the 3 sub-threads have finished.
		fork

			// Thread1 : Will finish first at time 40ns
			#40 $display ("[%0t ns] Show #40 $display statement", $time);

			// Thread2 : Will finish at time 70ns
			begin
				#20 $display ("[%0t ns] Show #20 $display statement", $time);

				#50 $display ("[%0t ns] Show #50 $display statement", $time);
			end

			// Thread3 : Will finish at time 60ns
			#60 $display ("[%0t ns] TIMEOUT", $time);
		join_any

      	// Display as soon as the fork is done
      	$display ("[%0t ns] Fork join is done, wait fork to end", $time);

      	// Fork two more processes
      	fork
          #10 $display ("[%0t ns] Wait for 10", $time);
          #20 $display ("[%0t ns] Wait for 20", $time);
        join_any

      	// Wait until ALL forked processes are over
      	wait fork;
        $display ("[%0t ns] Fork join is over", $time);
   end
endmodule
//output
/*
# KERNEL: [20 ns] Show #20 $display statement
# KERNEL: [40 ns] Show #40 $display statement
# KERNEL: [40 ns] Fork join is done, wait fork to end
# KERNEL: [50 ns] Wait for 10
# KERNEL: [60 ns] TIMEOUT
# KERNEL: [60 ns] Wait for 20
# KERNEL: [70 ns] Show #50 $display statement
# KERNEL: [70 ns] Fork join is over
*/