// a ** b,	a to the power of b
// If the second operand of a division or modulus operator is zero, then the result will be X. If either operand of the power operator is real, then the result will also be real.

module des;
  reg [7:0]  data1;
  reg [7:0]  data2;

  initial begin
    data1 = 45;
    data2 = 9;

    $display ("Add + = %d", data1 + data2);
    $display ("Sub - = %d", data1 - data2);
    $display ("Mul * = %d", data1 * data2);
    $display ("Div / = %d", data1 / data2);
    $display ("Mod %% = %d", data1 % data2);
    $display ("Pow ** = %d", data2 ** 2);

  end
endmodule

/*
Output:
Add + =  54
Sub - =  36
Mul * = 149 // 405 with 9bits will be trucated to 8bits 149
Div / =   5
Mod % =   0
Pow ** =  81
ncsim: *W,RNQUIE: Simulation is complete.
*/

// An expression with the relational operator will result in a 1 if the expression is evaluated to be true, and 0 if it is false. If either of the operands is X or Z, then the result will be X. 

// Verilog Equality Operators
// Equality operators have the same precedence amongst them and are lower in precedence than relational operators.
// The result is 1 if true, and 0 if false. If either of the operands of logical-equality (==) or logical-inequality (!=) is X or Z, then the result will be X. 
// You may use case-equality operator (===) or case-inequality operator (!==) to match including X and Z and will always have a known value.

// a === b	a equal to b, including x and z
// a !== b	a not equal to b, including x and z
// a == b	a equal to b, result can be unknown
// a != b	a not equal to b, result can be unknown

// logical shift operator: << , >> empty bits filled with 0

// arithmetic shift operators: <<<. >>>
// arithmetic shift right >>>: A right arithmetic shift of a binary number by 1. The empty position in the most significant bit is filled with a copy of the original MSB.
// arithmetic shift left <<<: A left arithmetic shift of a binary number by 1. The empty position in the least significant bit is filled with a zero.
// arithmetic shift used for sign extention, for example, add a 4-bit and 8-bit number, 4-bit will expand to 8 bit, expand bit filled with 1 or 0 depends on the orginal MSB signed bit, which is arithmetic shift