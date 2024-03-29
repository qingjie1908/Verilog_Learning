// blocking assignemnts
// Blocking assignment statements are assigned using = 
// and are executed one after the other in a procedural block. 

module tb;
  reg [7:0] a, b, c, d, e;

  initial begin
    a = 8'hDA;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    b = 8'hF1;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    c = 8'h30;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
  end

  initial begin
    d = 8'hAA;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
 	e = 8'h55;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
  end
endmodule

// both 2 intiial blocks start at 0ns
//output
/*
[0] a=0xda b=0xxx c=0xxx
[0] a=0xda b=0xf1 c=0xxx
[0] a=0xda b=0xf1 c=0x30
[0] d=0xaa e=0xxx
[0] d=0xaa e=0x55
*/

module tb2;
  reg [7:0] a, b, c, d, e;

  initial begin
    a = 8'hDA;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    #10 b = 8'hF1;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    c = 8'h30;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
  end

  initial begin
    #5 d = 8'hAA;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
 	#5 e = 8'h55;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
  end
endmodule

//both 2 inital blocks start at 0ns
//output:
/*
[0] a=0xda b=0xxx c=0xxx
[5] d=0xaa e=0xxx
[10] a=0xda b=0xf1 c=0xxx
[10] a=0xda b=0xf1 c=0x30
[10] d=0xaa e=0x55
*/

//Non-blocking assinment
//Nonblocking assignments are executed concurrently by evalu- ating the set of expressions on the right-hand side of the list of statements; 
//they do not make assignments to their left-hand sides until all of the expressions are evaluated.

//note: $display is a blocking statement
module tb3;
  reg [7:0] a, b, c, d, e;

  initial begin
    a <= 8'hDA;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    b <= 8'hF1;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    c <= 8'h30;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
  end

  initial begin
    d <= 8'hAA;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
 	e <= 8'h55;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
  end
endmodule

//output
/*
[0] a=0xxx b=0xxx c=0xxx
[0] a=0xxx b=0xxx c=0xxx
[0] a=0xxx b=0xxx c=0xxx
[0] d=0xxx e=0xxx
[0] d=0xxx e=0xxx
*/

/*
|__ Spawn Block1: initial
|      |___ Time #0ns : a <= 8'DA, is non-blocking so note value of RHS (8'hDA) and execute next step
|      |___ Time #0ns : $display() is blocking, so execute this statement: But a hasn't received new values so a=8'hx
|      |___ Time #0ns : b <= 8'F1, is non-blocking so note value of RHS (8'hF1) and execute next step
|      |___ Time #0ns : $display() is blocking, so execute this statement. But b hasn't received new values so b=8'hx
|      |___ Time #0ns : c <= 8'30, is non-blocking so note value of RHS (8'h30) and execute next step
|      |___ Time #0ns : $display() is blocking, so execute this statement. But c hasn't received new values so c=8'hx
|      |___ End of time-step and initial block, assign captured values into variables a, b, c
|
|__ Spawn Block2: initial
|      |___ Time #0ns : d <= 8'AA, is non-blocking so note value of RHS (8'hAA) and execute next step
|      |___ Time #0ns : $display() is blocking, so execute this statement: But d hasn't received new values so d=8'hx
|      |___ Time #0ns : e <= 8'55, is non-blocking so note value of RHS (8'h55) and execute next step
|      |___ Time #0ns : $display() is blocking, so execute this statement. But e hasn't received new values so e=8'hx
|      |___ End of time-step and initial block, assign captured values into variables d and e
|
|__ End of simulation at #0ns
*/

module tb4;
  reg [7:0] a, b, c, d, e;

  initial begin
    a <= 8'hDA;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    #10 b <= 8'hF1;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
    c <= 8'h30;
    $display ("[%0t] a=0x%0h b=0x%0h c=0x%0h", $time, a, b, c);
  end

  initial begin
    #5 d <= 8'hAA;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
 	#5 e <= 8'h55;
    $display ("[%0t] d=0x%0h e=0x%0h", $time, d, e);
  end
endmodule

//output:
/*
[0] a=0xxx b=0xxx c=0xxx
[5] d=0xxx e=0xxx
[10] a=0xda b=0xxx c=0xxx
[10] a=0xda b=0xxx c=0xxx
[10] d=0xaa e=0xxx
*/

/*
|__ Spawn Block1 at #0ns: initial
|      |___ Time #0ns : a <= 8'DA, is non-blocking so note value of RHS (8'hDA) and execute next step
|      |___ Time #0ns : $display() is blocking, so execute this statement: But a hasn't received new values so a=8'hx
|      |___ End of time-step : Assign captured value to variable a, and a is now 8'hDA
|      |___ Wait until time advances by 10 time-units to #10ns
|	
|      |___ Time #10ns : b <= 8'F1, is non-blocking so note value of RHS (8'hF1) and execute next step
|      |___ Time #10ns : $display() is blocking, so execute this statement. But b hasn't received new values so b=8'hx
|	   |___ Time #10ns : c <= 8'30, is non-blocking so note value of RHS (8'h30) and execute next step
|      |___ Time #10ns : $display() is blocking, so execute this statement. But c hasn't received new values so c=8'hx
|      |___ End of time-step and initial block, assign captured values into variables b, c
|	
|__ Spawn Block2 at #0ns: initial
|      |___ Wait until time advances by 5 time-units to #5ns
|	
|      |___ Time #5ns : d <= 8'AA, is non-blocking so note value of RHS (8'hAA) and execute next step
|      |___ Time #5ns : $display() is blocking, so execute this statement: But d hasn't received new values so d=8'hx
|      |___ End of time-step : Assign captured value to variable d, and d is now 8'hAA
|      |___ Wait until time advances by 5 time-units to #5ns
|	
|      |___ Time #10ns : e <= 8'55, is non-blocking so note value of RHS (8'h55) and execute next step
|      |___ Time #10ns : $display() is blocking, so execute this statement. But e hasn't received new values so e=8'hx
|      |___ End of time-step and initial block, assign captured values to variable e, and e is now 8'h55
|
|__ End of simulation at #10ns
*/