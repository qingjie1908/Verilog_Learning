//the need to avoid testbench recompilation,
// and instead be able to accept values from the command line
//this information is provided to the simulation as an optional argument always starting with the + character.
//These arguments passed in from the command line are accessible in SV code via the following system functions called as plusargs.

//Syntax
/*
$test$plusargs (user_string)

$value$plusargs (user_string, variable)
*/

//====$test$plusargs

//The function $test$plusargs is typically used when a value for the argument is not required.
//It searches the list of plusargs for a user specified string
//A variable can also be used to specify the string, and any null character will be ignored.
//If the prefix of one of the supplied plusargs matches all characters in the provided string, 
//the function will return a non-zero integer, and otherwise zero.

module tb;
  initial begin
    if ($test$plusargs ("STANDBY"))
      $display ("STANDBY argument is found ...");

    if ($test$plusargs ("Standby"))
      $display ("Standby argument is also found ...");

    if ($test$plusargs ("STAND"))
      $display ("STAND substring is found ...");

    if ($test$plusargs ("S"))
      $display ("Some string starting with S found ...");

    if ($test$plusargs ("T"))
      $display ("Some string containing T found ...");

    if ($test$plusargs ("STAND_AT_EASE"))
      $display ("Can't stand any longer ...");

    if ($test$plusargs ("SUNSHADE"))
      $display ("It's too hot today ...");

    if ($test$plusargs ("WINTER"))
      $display ("No match.. ");
  end
endmodule

// excution command: /Users/qingjie/github/Verilog_Learning/SystemVerilog/MISC/obj_dir/Vcommand_line_input +STANDBY
//output
/*
STANDBY argument is found ...
STAND substring is found ...
Some string starting with S found ...
*/

//When the code shown above is compiled and simulated with a run-time argument +STANDBY,
// where STANDBY is the string plusarg provided to the simulation tool, 
//we get an output like shown above. 
//Notice that the plusarg is case-sensitive, 
//and matches both "S" and "STAND" even though the string provided is "STANDBY".

//====$value$plusargs

//The $value$plusargs system function also searches the list of plusargs like $test$plusargs, 
//but it has the capability to get a value for a specified user string.
//If the prefix of one of the supplied plusargs matches all characters in the given user string,
//the function will return a non-zero value and store the resulting value in the variable provided.
//If the user string is not found, then the function returns a zero value and the variable will not be modified.

//The user_string shall be of the form "plusarg_string format_string" where format strings are the same as $display tasks.
//These format identifiers are used to convert the value provided via command line to the given format and store in a variable
/*
Format Specifier	Description
%d	Decimal conversion
%o	Octal conversion
%h, %x	Hexadecimal conversion
%b	Binary conversion
%e	Real exponential conversion
%f	Real decimal conversion
%g	Real decimal or exponential conversion
%s	String (no conversion)
*/

module tb2;
  initial begin
  	string  	var1, var2;
    bit [31:0] 	data;

    if ($value$plusargs ("STRING=%s", var1))
      $display ("STRING with FS has a value %s", var1);

    if ($value$plusargs ("NUMBER=%0d", data))
      $display ("NUMBER with %%0d has a value %0d", data);

    if ($value$plusargs ("NUMBER=%0h", data))
      $display ("NUMBER with %%0h has a value %0d", data);

    if ($value$plusargs ("NUMBER=%s", data))
      $display ("NUMBER with %%s has a value %0d", data);

    if ($value$plusargs ("STRING=", var1))
      $display ("STRING without FS has a value %s", var1);

    if ($value$plusargs ("+STRING=%s", var1))
      $display ("STRING with + char has a value %s", var1);

`ifdef RUNTIME_ERR
    if ($value$plusargs ("STRING=%0d", var2))
      $display ("STRING with %%0d has a value %s", var2);
`endif
  end
endmodule

//note that there should not be any space between the user string, = and the value in the command-line expression.
//+STRING=Joey or +STRING="Joey"
//"Joey" can be passed with or without double-quotes.

//execute command: Users/qingjie/github/Verilog_Learning/SystemVerilog/MISC/obj_dir/Vcommand_line_input +STRING=Joey
//output
/*
STRING with FS has a value Joey
STRING without FS has a value Joey
*/

//command: /Users/qingjie/github/Verilog_Learning/SystemVerilog/MISC/obj_dir/Vcommand_line_input +NUMBER=asdfdfghsa
//output
/*
NUMBER with %0d has a value 0
NUMBER with %0h has a value 11402746
NUMBER with %s has a value 1734898529
*/

//first, find plusargs "NUMBER=%0d", asdfdfghsa is not decimal, so data still retain original 0
//second, find plusargs "NUMBER=%0h", data is 32bit, trunc asdfdfghsa to 0x00adfdfa (from LSB to MSB, ignore non-valid hex), then data = 0x00adfdfa, which is 11402746 in decimal
//third, find plusargs "NUMBER=%s", data is 32bit, a char is 1 byte, 8bit, so data can contain 4 char, from LSB to MSB trunc to 'ghsa' in ASCII, 0x67687361 in hex, which is 1734898529 in decimal

//command: +STRING
//The = symbol is missing, and hence failed to be recognized.

//If the user string matches, 
//but the format specifier is wrong for the kind of data that is being passed in as an argument, 
//you'll get a runtime error. For the above example, use +define+RUNTIME_ERR as a compile time argument and +STRING=Joey.

//command: Vcommand_line_input +define+RUNTIME_ERR +STRING=Joey
//output
/*
STRING with FS has a value Joey
STRING without FS has a value Joey
*/
//some simulator will output more like
/*
STRING with FS has a value Joey
STRING without FS has a value Joey
    if ($value$plusargs ("STRING=%0d", var2))
                      |
ncsim: *E,SYSFMT (./testbench.sv,27|22): $value$plusargs --  value found 'Joey' for plusarg 'STRING=' does not match specified format.
STRING with %0d has a value 
*/