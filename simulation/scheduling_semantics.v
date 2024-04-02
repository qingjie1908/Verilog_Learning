//Every change in value of a signal in the Verilog model is considered an update event. 
//And processes such as always and assign blocks that are sensitive to these update events are evaluated in an arbitrary order and is called an evaluation event. 
//Since these events can happen at different times, they are better managed and ensured of their correct order of execution by scheduling them into event queues that are arranged by simulation time.

module tb;
	reg a, b, c;
	wire d;

	// 'always' is a process that gets evaluated when either 'a' or 'b' is updated.
	// When 'a' or 'b' changes in value it is called an 'update event'. 
	// When 'always' block is triggered because of a change in 'a' or 'b' it is called an evaluation event
	always @ (a or b) begin
		c = a & b;
	end

	// Here 'assign' is a process which is evaluated when either 'a' or 'b' or 'c'
	// gets updated
	assign d = a | b ^ c;
endmodule

//Event Queue

//A simulation step can be segmented into four different regions. An active event queue is just a set of processes that need to execute at the current time which can result in more processes to be scheduled into active or other event queues. 
//Events can be added to any of the regions, but always removed from the active region.

//Active events occur at the current simulation time and can be processed in any order.
//Inactive events occur at the current simulation time, but is processed after all active events are processed
//Nonblocking assign events that were evaluated previously will be assigned after all active and inactive events are processed.
//Monitor events are processed after all active, inactive and nonblocking assignments are done.
//When all events in the active queue for the current time step has been executed, the simulator advances time to the next time step and executes its active queue

