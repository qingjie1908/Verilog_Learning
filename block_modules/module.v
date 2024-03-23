// module

// A module should be enclosed within module and endmodule keywords. 
// Name of the module should be given right after the module keyword and an optional list of ports may be declared as well. 
// Note that ports declared in the list of port declarations cannot be redeclared within the body of the module.
/*
    module <name> ([port_list]);
		// Contents of the module
	endmodule
	
	// A module can have an empty portlist
	module name;
		// Contents of the module
	endmodule
*/

// All variable declarations, dataflow statements, functions or tasks and lower module instances if any, must be defined within the module and endmodule keywords. 
// There can be multiple modules with different names in the same file and can be defined in any order.
// cannot have any code written outside of module !!!

module dff(input d, clk, rstn, output reg q);
    always@(posedge clk) begin
        if(!rstn)
            q <= 0;
        else
            q <= d;
    end

endmodule

module shift_reg(input d, clk, rstn, output q);
    wire [2:0] q_net;
    dff u0(.d(d), .clk(clk), .rstn(rstn), .q(q_net[0]));
    dff u1(.d(q_net[0]), .clk(clk), .rstn(rstn), .q(q_net[1])); // wire, create tem q_net[x] to connect between different dff q out to next d input
    dff u2(.d(q_net[1]), .clk(clk), .rstn(rstn), .q(q_net[2]));
    dff u3(.d(q_net[2]), .clk(clk), .rstn(rstn), .q(q));
endmodule

// top-level module
// contain all other module, not instantiated 
//---------------------------------
//  Design code
//---------------------------------
/*
    module mod3 ( [port_list] );
        reg c;
        // Design code
    endmodule

    module mod4 ( [port_list] );
        wire a;
        // Design code
    endmodule

    module mod1 ( [port_list] );	 	// This module called "mod1" contains two instances
        wire 	y;

        mod3 	mod_inst1 ( ... ); 	 		// First instance is of module called "mod3" with name "mod_inst1"
        mod3 	mod_inst2 ( ... );	 		// Second instance is also of module "mod3" with name "mod_inst2"
    endmodule

    module mod2 ( [port_list] ); 		// This module called "mod2" contains two instances
        mod4 	mod_inst1 ( ... );			// First instance is of module called "mod4" with name "mod_inst1"
        mod4 	mod_inst2 ( ... );			// Second instance is also of module "mod4" with name "mod_inst2"
    endmodule

    // Top-level module
    module design ( [port_list]); 		// From design perspective, this is the top-level module
        wire 	_net;
        mod1 	mod_inst1 	( ... ); 			// since it contains all other modules and sub-modules
        mod2 	mod_inst2 	( ... );
    endmodule
*/

// From a simulator perspective, testbench is the top level module
/*
    module testbench;
        design d0 ( [port_list_connections] );

        // Rest of the testbench code
    endmodule
*/

// the top level module is called the root. 
// Since each lower module instantiations within a given module is required to have different identifier names, 
// there will not be any ambiguity in accessing signals.

// Take the example shown above in top level modules
/*
    design.mod_inst1 					// Access to module instance mod_inst1
    design.mod_inst1.y 					// Access signal "y" inside mod_inst1
    design.mod_inst2.mod_inst2.a		// Access signal "a" within mod4 module

    testbench.d0._net; 					// Top level signal _net within design module accessed from testbench
*/