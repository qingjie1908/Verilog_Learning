//Verilog timescale directive specifies time unit and precision for simulations.

//Verilog $timeformat system function specifies %t format specifier reporting style in display statements like $display and $strobe.

//Syntax
//$timeformat(<unit_number>, <precision>, <suffix_string>, <minimum field width>);
/*
unit_number is the smallest time precision out of all `timescale directives used in source code
precision represents the number of fractional digits for the current timescale
suffix_string is an option to display the scale alongside the real time values
Unit number	Time unit
-3	1ms
-6	1us
-9	1ns
-12	1ps
-15	1fs
*/


//Example #1: 1ns/1ps
`timescale 1ns/1ps

module tb;
  bit 	a;

  initial begin

    // Wait for some time - note that because precision is 1/1000 of
    // the main scale (1ns), this delay will be truncated by the 3rd
    // position
    #10.512351;

    // Display current time with default timeformat parameters
    $display("[T=%0t] a=%0b", $realtime, a);

    // Change timeformat parameters and display again
    $timeformat(-9, 2, " ns");
    $display("[T=%0t] a=%0b", $realtime, a);

    // Remove the space in suffix, and extend fractional digits to 5
    $timeformat(-9, 5, "ns");
    $display("[T=%0t] a=%0b", $realtime, a);

    // Here suffix is wrong, it should not be "ns" because we are
    // setting display in "ps" (-12)
    $timeformat(-12, 3, " ns");
    $display("[T=%0t] a=%0b", $realtime, a);

    // Correct the suffix to ps
    $timeformat(-12, 2, " ps");
    $display("[T=%0t] a=%0b", $realtime, a);
  end
endmodule

//output
/*
# KERNEL: [T=10512] a=0
# KERNEL: [T=10.51 ns] a=0
# KERNEL: [T=10.51200ns] a=0
# KERNEL: [T=10512.000 ns] a=0
# KERNEL: [T=10512.00 ps] a=0
*/