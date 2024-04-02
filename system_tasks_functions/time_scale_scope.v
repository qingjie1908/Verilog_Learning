//Verilog Timescale Scope

//Default timescale

//Although Verilog modules are expected to have a timescale defined before the module, 
//simulators may insert a default timescale.
//The actual timescale that gets applied at any scope in a Verilog elaborated hierarchy can be printed using the system task $printtimescale which accepts the scope as an argument.

module tb;
	initial begin
		// Print timescale of this module
		$printtimescale(tb);
		// $printtimescale($root);
	end
endmodule

//output, can be change with different simulator
//Time scale of (tb) is 1s / 1s

//Standard timescale scope

//By default a timescale directive placed in a file is applied to all modules that follow the directive until the definition of another timescale directive.

`timescale 1ns/1ps

module tb;
  des m_des();
  alu m_alu();

  initial begin
    $printtimescale(tb);
    $printtimescale(tb.m_alu);
	$printtimescale(tb.m_des);
  end
endmodule

module alu;

endmodule

`timescale 1ns/10ps

module des;

endmodule

//output
/*
Time scale of (tb) is 1ns / 1ps
Time scale of (tb.m_alu) is 1ns / 1ps
Time scale of (tb.m_des) is 1ns / 10ps
*/