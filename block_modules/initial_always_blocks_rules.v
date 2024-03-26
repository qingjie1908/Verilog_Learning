// initial blocks
// An initial block is not synthesizable and hence cannot be converted into a hardware schematic with digital elements.
// An initial block is started at the beginning of a simulation at time 0 unit. 
// This block will be executed only once during the entire simulation. 
// Execution of an initial block finishes once all the statements within the block are executed.

//There are no limits to the number of initial blocks that can be defined inside a module.
// If one of the initial block had a delay of 30 time units then using $finish, the simulation would have ended at 30 time units thereby killing all the other initial blocks that are active at that time.

// Always block and initial block at the same level are both starting at 0 time units paralleled

// There are a few rules to keep in mind when writing Verilog:

// reg can be assigned to only in initial and always blocks
// wire can be assigned a value only via assign statement
// If there are multiple statements in an initial/always block, they should be wrapped in begin .. end
// Code inside the initial block will be executed at 0ns i.e. start of simulation