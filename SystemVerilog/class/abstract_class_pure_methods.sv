//SystemVerilog prohibits a class declared as virtual to be directly instantiated 
//and is called an abstract class.

Syntax

virtual class <class_name>
	// class definition
endclass

//However, this class can be extended to form other sub-classes which can then be instantiated. 
//This is useful to enforce testcase developers to always extend a base class to form another class for their needs. 
//So base classes are usually declared asvirtual although it is not mandatory.

//====Normal Class Example

class BaseClass;
	int data;

	function new();
		data = 32'hc0de_c0de;
	endfunction
endclass

module tb;
	BaseClass base;
	initial begin
		base = new();
		$display ("data=0x%0h", base.data);
	end
endmodule
//output
/*
# KERNEL: data=0xc0dec0de
*/

//====Abstract Class Example

virtual class BaseClass;
	int data;

	function new();
		data = 32'hc0de_c0de;
	endfunction
endclass

module tb;
	BaseClass base;
	initial begin
		base = new();//ERROR VCP2937 "Cannot instantiate abstract class: BaseClass."
		$display ("data=0x%0h", base.data);
	end
endmodule
//output
//ERROR VCP2937 "Cannot instantiate abstract class: BaseClass."

//====Extending Abstract Classes

//Abstract classes can be extended just like any other SystemVerilog class using the extends keyword like shown below.

virtual class BaseClass;
	int data;

	function new();
		data = 32'hc0de_c0de;
	endfunction
endclass

class ChildClass extends BaseClass;
	function new();
		data = 32'hfade_fade;
	endfunction
endclass

module tb;
	ChildClass child;
	initial begin
		child = new();
		$display ("data=0x%0h", child.data);
	end
endmodule
//output
/*
# KERNEL: data=0xfadefade
*/

//====Pure Virtual Methods

//A virtual method inside an abstract class can be declared with the keyword pure 
//and is called a pure virtual method. 
//Such methods only require a prototype to be specified within the abstract class 
//and the implementation is left to defined within the sub-classes.

virtual class BaseClass;
	int data;

	pure virtual function int getData();
endclass

class ChildClass extends BaseClass;
	virtual function int getData();
		data = 32'hcafe_cafe;
		return data;
	endfunction
endclass

module tb;
	ChildClass child;
	initial begin
		child = new();
		$display ("data = 0x%0h", child.getData());
	end
endmodule
//output
/*
# KERNEL: data = 0xcafecafe
*/

//The pure virtual method prototype and its implementation should have the same arguments and return type.