//Verilog supports a few basic logic gates known as primitives as they can be instantiated like modules since they are already predefined.

//Most digital designs are done at a higher level of abstraction like RTL, 
//although at times it becomes intuitive to build smaller deterministic circuits at a lower level by using combinational elements like and and or. 
//Modeling done at this level is usually called gate level modeling as it involves gates and has a one to one relation between a hardware schematic and the Verilog code.

/*
Gate Types	Syntax	Description
and	and u0(out, i1, i2, …)	Performs AND operation on two or more inputs
or	or u0(out, i1, i2, …)	Performs OR operation on two or more inputs
xor	xor u0(out, i1, i2, …)	Performs XOR operation on two or more inputs
nand	nand u0(out, i1, i2, …)	Performs NAND operation on two or more inputs
nor	nor u0(out, i1, i2, …)	Performs NOR operation on two or more inputs
xnor	xnor u0(out, i1, i2, …)	Performs XNOR operation on two or more inputs
buf	buf u0(out, in)	The buffer (buf) passes input to the output as it is. It has only one scalar input and one or more scalar outputs.
not	not u0(out, in)	The not passes input to the output as an inverted version. It has only one scalar input and one or more scalar outputs.
bufif1	bufif1 u0(out, in, control)	It is the same as buf with additional control over the buf gate and drives input signal only when a control signal is 1.
notif1	notif1 u0(out, in, control)	It is the same as not having additional control over the not gate and drives input signal only when a control signal is 1.
bufif0	bufif0 u0(out, in, control)	It is the same as buf with additional inverted control over the buf gate and drives input signal only when a control signal is 0
notif0	notif0 u0(out, in, control)	It is the same as not with additional inverted control over the not gate and drives input signal only when a control signal is 0.
*/

