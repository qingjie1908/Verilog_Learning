//task
//A function is meant to do some processing on the input and return a single value
//whereas a task is more general and can calculate multiple result values and return them using output and inout type arguments.
//Tasks can contain simulation time consuming elements such as @, posedge and others.
//A task need not have a set of arguments in the port list, in which case it can be kept empty

//


//Syntax
/*
// Style 1
task [name];
	input  [port_list];
	inout  [port_list];
	output [port_list];
	begin
		[statements]
	end
endtask

// Style 2
task [name] (input [port_list], inout [port_list], output [port_list]);
	begin
		[statements]
	end
endtask

// Empty port list
task [name] ();
	begin
		[statements]
	end
endtask

*/

module m1;
	task sum;
		input  [7:0] a, b;
		output [7:0] c;
		begin
			c = a + b;
		end
	endtask

	initial begin
		reg [7:0] x, y , z;
		sum (x, y, z);
	end
endmodule
//The task-enabling arguments (x, y, z) correspond to the arguments (a, b, c) defined by the task

//Static Task
//If a task is static, then all its member variables will be shared across different invocations of the same task that has been launched to run concurrently
//so integer m in first and second display1() task will be the same m,
module tb;
	initial display1();
	initial display1();

  // This is a static task
	task display1();
		begin:display1
		    integer m;
		    $display("time[%0t] m=%0d", $time, m);
		    m = 0;
			$display("time[%0t] m=%0d", $time, m);
			m = m + 1;
		end
	endtask
endmodule

//output:
/*
time[0] m=x
time[0] m=0
time[0] m=1
time[0] m=0
*/

//Automatic task
//The keyword automatic will make the task reentrant, otherwise it will be static by default. 
//All items inside automatic tasks are allocated dynamically for each invocation and not shared between invocations of the same task running concurrently.
//So integer m in first and second display1() task are different

module tb2;
	initial display1();
	initial display1();

  // This is a automatic task, diffe
	task automatic display1();
		begin:display1
		    integer m;
		    $display("time[%0t] m=%0d", $time, m);
		    m = 0;
			$display("time[%0t] m=%0d", $time, m);
			m = m + 1;
		end
	endtask
endmodule
// output:
/*
time[0] m=x
time[0] m=0
time[0] m=x
time[0] m=0
*/

//Global task
//Tasks that are declared outside all modules are called global tasks
//can be called within any module.

// This task is outside all modules
task display1();
  $display("Hello World !");
endtask

module des;
  initial begin
    display1();
  end
endmodule

//If the task was declared within the module 'des' , 
//if we want to call it in another module
//it would have to be called in reference to the module instance name
module tb3;
	des u0();

	initial begin
		$display("need to call task in another module by reference to instance");
		u0.display1();  // Task is not visible in the module 'tb'
	end
endmodule

module des;
	initial begin
		display1(); 	// Task definition is local to the module
	end

	task display1();
		$display("Hello World");
	endtask
endmodule

//output
/*
Hello World
need to call task in another module by reference to instance
Hello World
*/

//When a function attempts to call a task or contain a time consuming statement, the compiler reports an error.
module tb4;
  reg signal;

  initial wait_for_1(signal);

  function wait_for_1(reg signal);
    #10; // illegal time/event control statement within a function or final block or analog initial block
  endfunction
endmodule

//Disable Task
//Tasks can be disabled using the disable keyword.
module tb5;

  initial display();

  initial begin
  	// After 50 time units, disable a particular named
  	// block T_DISPLAY inside the task called 'display'
    #50 disable display.T_DISPLAY;
  end

  task display();
  begin
    begin : T_DISPLAY
      $display("[%0t] T_Task started", $time);
      #100;
      $display("[%0t] T_Task ended", $time);
    end

    begin : S_DISPLAY
      #10;
      $display("[%0t] S_Task started", $time);
      #20;
      $display("[%0t] S_Task ended", $time);
    end
  end
  endtask
endmodule

//output
/*
[0] T_Task started
[60] S_Task started
[80] S_Task ended
*/
//When display task was launched by the first initial block, T_DISPLAY started and got disabled when time reached 50 units. 
//Immediately the next block S_DISPLAY started and ran to completion by 80 units.
