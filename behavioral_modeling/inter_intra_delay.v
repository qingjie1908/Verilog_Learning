//Inter-assignment delay
//An inter-assignment delay statement has delay value on the LHS of the assignment operator. 
//This indicates that the statement itself is executed after the delay expires, and is the most commonly using form of delay control

module tb;
  reg  a, b, c, q;

  initial begin
    $monitor("[%0t] a=%0b b=%0b c=%0b q=%0b", $time, a, b, c, q);

    // Initialize all signals to 0 at time 0
    a <= 0;
    b <= 0;
    c <= 0;
    q <= 0;

    // Inter-assignment delay: Wait for #5 time units
    // and then assign a and c to 1. Note that 'a' and 'c'
    // gets updated at the end of current timestep
    #5  a <= 1;
    	c <= 1;

    // Inter-assignment delay: Wait for #5 time units
    // and then assign 'q' with whatever value RHS gets
    // evaluated to
    #5 q <= a & b | c;

    #20;
  end

endmodule

//output
/*
[0] a=0 b=0 c=0 q=0
[5] a=1 b=0 c=1 q=0
[10] a=1 b=0 c=1 q=1
*/

//Intra-assignment delay
// Delay is specified on the right side
//<LHS> = #<delay> <RHS>
//An intra-assignment delay is one where there is a delay on the RHS of the assignment operator.
//first,statement is evaluated and values of all signals on the RHS is captured
//Then it is assigned to the resultant signal only after the delay expires.

module tb;
  reg  a, b, c, q;

  initial begin
    $monitor("[%0t] a=%0b b=%0b c=%0b q=%0b", $time, a, b, c, q);

	// Initialize all signals to 0 at time 0
    a <= 0;
    b <= 0;
    c <= 0;
    q <= 0;

    // Inter-assignment delay: Wait for #5 time units
    // and then assign a and c to 1. Note that 'a' and 'c'
    // gets updated at the end of current timestep
    #5  a <= 1;
    	c <= 1;

    // Intra-assignment delay: First execute the statement
    // then wait for 5 time units and then assign the evaluated
    // value to q
    q <= #5 a & b | c;

    #20;
  end
endmodule

//output
/*
[0] a=0 b=0 c=0 q=0
[5] a=1 b=0 c=1 q=0
*/

//at time 5
//a and c are assigned using non-blocking statements. 
//the behavior of non-blocking statements is such that RHS is evaluated, 
//but gets assigned to the variable only at the end of that time step.
//So value of a and c is evaluated to 1 but not yet assigned when the next non-blocking statement which is that of q is executed.
//so when RHS of q is evaluated, a and c still has old value of 0 
//at time 5; a & b | c is  0 & 0 | 0 = 0;
//after time 5 finish, a = 1, b = 1, c = 0, q = 0 (still 0), monitor detect change a and b
//at time 6, a = 1, b = 1, c = 0, q = 0
//at time 10, previous 'a & b | c is  0' now assigend to q,
//after time 10, q update to 0, no change, so minitor no detect
//time 11, a = 1, b = 1, c = 0, q = 0
//...
//time 30, finished, still no change