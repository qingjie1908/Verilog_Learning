//Display/Write Tasks

//Syntax
//Both $display and $write display arguments in the order they appear in the argument list.
/*
$display(<list_of_arguments>);
$write(<list_of_arguments>);
*/
//$write does not append the newline character to the end of its string, $display does

//Verilog Strobes

//$strobe prints the final values of variables at the end of the current delta time-step and has a similar format like $display.

module tb;
  initial begin
    reg [7:0] a;
    reg [7:0] b;

    a = 8'h2D;
    b = 8'h2D;

    #10;                  // Wait till simulation reaches 10ns
    b <= a + 1;           // Assign a+1 value to b

    $display ("[$display] time=%0t a=0x%0h b=0x%0h", $time, a, b); // at time 10, b has not been updated yet
    $strobe  ("[$strobe]  time=%0t a=0x%0h b=0x%0h", $time, a, b); // it will show the updated value of b

    #1;
    $display ("[$display] time=%0t a=0x%0h b=0x%0h", $time, a, b);
    $strobe  ("[$strobe]  time=%0t a=0x%0h b=0x%0h", $time, a, b);

  end
endmodule

//output
/*
# KERNEL: [$display] time=10 a=0x2d b=0x2d
# KERNEL: [$strobe]  time=10 a=0x2d b=0x2e
# KERNEL: [$display] time=11 a=0x2d b=0x2e
# KERNEL: [$strobe]  time=11 a=0x2d b=0x2e
*/

//Verilog Continuous Monitors

//$monitor helps to automatically print out variable or expression values whenever the variable or expression in its argument list changes. It achieves a similar effect of calling $display after every time any of its arguments get updated.

module tb;
  initial begin
    reg [7:0] a;
    reg [7:0] b;

    a = 8'h2D;
    b = 8'h2D;

    #10;                  // Wait till simulation reaches 10ns
    b <= a + 1;           // Assign a+1 value to b

    $monitor ("[$monitor] time=%0t a=0x%0h b=0x%0h", $time, a, b);

    #1 b <= 8'hA4;
    #5 b <= a - 8'h33;
    #10 b <= 8'h1;

  end
endmodule
//Note that $monitor is like a task that is spawned to run in the background of the main thread which monitors and displays value changes of its argument variables. A new $monitor task can be issued any number of times during simulation.
//output
/*
[$monitor] time=10 a=0x2d b=0x2e
[$monitor] time=11 a=0x2d b=0xa4
[$monitor] time=16 a=0x2d b=0xfa
[$monitor] time=26 a=0x2d b=0x1
*/

//Verilog Format Specifiers

//In order to print variables inside display functions, appropriate format specifiers have to be given for each variable.
/*
Argument	Description
%h, %H	Display in hexadecimal format
%d, %D	Display in decimal format
%b, %B	Display in binary format
%m, %M	Display hierarchical name
%s, %S	Display as a string
%t, %T	Display in time format
%f, %F	Display 'real' in a decimal format
%e, %E	Display 'real' in an exponential format
*/

module tb;
  initial begin
    reg [7:0]  a;
    reg [39:0] str = "Hello";
    time       cur_time;
    real       float_pt;

    a = 8'h0E;
    float_pt = 3.142;

    $display ("a = %h", a);
    $display ("a = %d", a);
    $display ("a = %b", a);

    $display ("str = %s", str);
    #200 cur_time = $time;
    $display ("time = %t", cur_time);
    $display ("float_pt = %f", float_pt);
    $display ("float_pt = %e", float_pt);
  end
endmodule

//output
/*
# KERNEL: a = 0e
# KERNEL: a =  14
# KERNEL: a = 00001110
# KERNEL: str = Hello
# KERNEL: time =                  200
# KERNEL: float_pt = 3.142000
# KERNEL: float_pt = 3.142000e+00
*/