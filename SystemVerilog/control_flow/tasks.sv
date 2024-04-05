//a task is more general and can calculate multiple result values and return them 
//using output and inout type arguments. 
//Tasks can contain simulation time consuming elements such as @, posedge and others.


// see /Users/qingjie/github/Verilog_Learning/behavioral_modeling/task.v
// same usage


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

//====Static Task

//If a task is static, 
//then all its member variables will be shared across different invocations of the same task that has been launched to run concurrently

//Automatic Task

//The keyword automatic will make the task reentrant, 
//otherwise it will be static by default. 
//All items inside automatic tasks are allocated dynamically for each invocation 
//and not shared between invocations of the same task running concurrently. 
//Note that automatic task items cannot be accessed by hierarchical references.

//Global tasks
//Tasks that are declared outside all modules are called global tasks as they have a global scope and can be called within any module.

