//Verilog math functions can be used in place of constant expressions and supports both integer and real maths.

//Integer Math Functions
//The function $clog2 returns the ceiling of log2 of the given argument. 
//This is typically used to calculate the minimum width required to address a memory of given size.

//For example, if the design has 7 parallel adders, then the minimum number of bits required to represent all 7 adders is $clog2 of 7 that yields 3.

module des
  #(parameter NUM_UNITS = 7)

  // Use of this system function helps to reduce the
  // number of input wires to this module
  (input [$clog2(NUM_UNITS)-1:0] active_unit);

  initial
    $monitor("active_unit = %d", active_unit);
endmodule

`define NUM_UNITS 5

module tb;
  integer i;
  reg [`NUM_UNITS-1:0] 	active_unit;

  des #(.NUM_UNITS(`NUM_UNITS)) u0(active_unit);

  initial begin
    active_unit     = 1;
	#10 active_unit = 7;
    #10 active_unit = 8;
  end
endmodule

//output
/*
active_unit = 001
active_unit = 111
active_unit = 000

main.v:18: warning: Port 1 (active_unit) of des expects 3 bits, got 5.
main.v:18:        : Pruning 2 high bits of the expression.
*/

//real math Functions
//These system functions accept real arguments and return a real number.

/*
Function	Description
$ln(x)	Natural logarithm log(x)
$log10(x)	Decimal Logarithm log10(x)
exp(x)	Exponential of x (ex) where e=2.718281828...
sqrt(x)	Square root of x
$pow(x, y)	xy
$floor(x)	Floor x
$ceil(x)	Ceiling x
$sin(x)	Sine of x where x is in radians
$cos(x)	Cosine of x where x is in radians
$tan(x)	Tangent of x where x is in radians
$asin(x)	Arc-Sine of x
$acos(x)	Arc-Cosine of x
$atan(x)	Arc-tangent of x
$atan2(x, y)	Arc-tangent of x/y
$hypot(x, y)	Hypotenuse of x and y : sqrt(xx + yy)
$sinh(x)	Hyperbolic Sine of x
$cosh(x)	Hyperbolic-Cosine of x
$tanh(x)	Hyperbolic-Tangent of x
$asinh(x)	Arc-hyperbolic Sine of x
$acosh(x)	Arc-hyperbolic Cosine of x
$atanh(x)	Arc-hyperbolic tangent of x
*/

module tb;
  real x, y;

  initial begin
    x = 10000;
    $display("$log10(%0.3f) = %0.3f", x, $log10(x));

    x = 1;
    $display("$ln(%0.3f) = %0.3f", x, $ln(x));

    x = 2;
    $display("$exp(%0.3f) = %0.3f", x, $exp(x));

    x = 25;
    $display("$sqrt(%0.3f) = %0.3f", x, $sqrt(x));

    x = 5;
    y = 3;
    $display("$pow(%0.3f, %0.3f) = %0.3f", x, y, $pow(x, y));

    x = 2.7813;
    $display("$floor(%0.3f) = %0.3f", x, $floor(x));

    x = 7.1111;
    $display("$ceil(%0.3f) = %0.3f", x, $ceil(x));

    x = 30 * (22.0/7.0) / 180;   // convert 30 degrees to radians
    $display("$sin(%0.3f) = %0.3f", x, $sin(x));

    x = 90 * (22.0/7.0) / 180;
    $display("$cos(%0.3f) = %0.3f", x, $cos(x));

    x = 45 * (22.0/7.0) / 180;
    $display("$tan(%0.3f) = %0.3f", x, $tan(x));

    x = 0.5;
    $display("$asin(%0.3f) = %0.3f rad, %0.3f deg", x, $asin(x), $asin(x) * 7.0/22.0 * 180);

    x = 0;
    $display("$acos(%0.3f) = %0.3f rad, %0.3f deg", x, $acos(x), $acos(x) * 7.0/22.0 * 180);

    x = 1;
    $display("$atan(%0.3f) = %0.3f rad, %f deg", x, $atan(x), $atan(x) * 7.0/22.0 * 180);
  end
endmodule

//output
/*
$log10(10000.000) = 4.000
$ln(1.000) = 0.000
$exp(2.000) = 7.389
$sqrt(25.000) = 5.000
$pow(5.000, 3.000) = 125.000
$floor(2.781) = 2.000
$ceil(7.111) = 8.000
$sin(0.524) = 0.500
$cos(1.571) = -0.001
$tan(0.786) = 1.001
$asin(0.500) = 0.524 rad, 29.988 deg
$acos(0.000) = 1.571 rad, 89.964 deg
$atan(1.000) = 0.785 rad, 44.981895 deg
*/
