//syntax
/*
struct {
	[list of variables]
} struct_name;
*/

//====Unpacked Structures

//A structure is unpacked by default 
//and can be defined using the struct keyword and a list of member declarations can be provided within the curly brackets followed by the name of the structure.

module tb;
  	// Create a structure called "st_fruit"
	// which to store the fruit's name, count and expiry date in days.
  	// Note: this structure declaration can also be placed outside the module
	struct {
  		string fruit;
  		int    count;
  		byte 	 expiry;
	} st_fruit;

  initial begin
    // st_fruit is a structure variable, so let's initialize it
    st_fruit = '{"apple", 4, 15};

    // Display the structure variable
    $display ("st_fruit = %p", st_fruit);

    // Change fruit to pineapple, and expiry to 7
    st_fruit.fruit = "pineapple";
    st_fruit.expiry = 7;
    $display ("st_fruit = %p", st_fruit);
  end
endmodule
//output
/*
# KERNEL: st_fruit = '{fruit:"apple", count:4, expiry:15}
# KERNEL: st_fruit = '{fruit:"pineapple", count:4, expiry:7}
*/

//====typedef a structure
module tb2;
  	// Create a structure called "st_fruit"
	// which to store the fruit's name, count and expiry date in days.
  	// Note: this structure declaration can also be placed outside the module
	typedef struct {
  		string fruit;
  		int    count;
  		byte 	 expiry;
	} st_fruit;

  initial begin
    // st_fruit is a data type, so we need to declare a variable of this data type
    st_fruit fruit1 = '{"apple", 4, 15};
    st_fruit fruit2;

    // Display the structure variable
    $display ("fruit1 = %p fruit2 = %p", fruit1, fruit2);

    // Assign one structure variable to another and print
    // Note that contents of this variable is copied into the other
   	fruit2 = fruit1;
    $display ("fruit1 = %p fruit2 = %p", fruit1, fruit2);

    // Change fruit1 to see if fruit2 is affected
    fruit1.fruit = "orange";
    $display ("fruit1 = %p fruit2 = %p", fruit1, fruit2);
  end
endmodule
//output
/*
# KERNEL: fruit1 = '{fruit:"apple", count:4, expiry:15} fruit2 = '{fruit:"", count:0, expiry:0}
# KERNEL: fruit1 = '{fruit:"apple", count:4, expiry:15} fruit2 = '{fruit:"apple", count:4, expiry:15}
# KERNEL: fruit1 = '{fruit:"orange", count:4, expiry:15} fruit2 = '{fruit:"apple", count:4, expiry:15}
*/

//====Packed Structures

//A packed structure is a mechanism for 
//subdividing a vector into fields that can be accessed as members 
//and are packed together in memory without gaps. 
//The first member in the structure is the most significant 
//and subsequent members follow in decreasing order of significance.

//A structure is declared packed using the 'packed' keyword which by default is unsigned.

// Create a "packed" structure data type which is similar to creating
// bit [7:0]  ctrl_reg;
// ctrl_reg [0]   represents en
// ctrl_reg [3:1] represents cfg
// ctrl_reg [7:4] represents mode
typedef struct packed {
  bit [3:0] mode;
  bit [2:0] cfg;
  bit       en;
} st_ctrl;

module tb3;
  st_ctrl    ctrl_reg;

  initial begin
    // Initialize packed structure variable
    ctrl_reg = '{4'ha, 3'h5, 1};
    $display ("ctrl_reg = %p", ctrl_reg);

    // Change packed structure member to something else
    ctrl_reg.mode = 4'h3;
    $display ("ctrl_reg = %p", ctrl_reg);

    // Assign a packed value to the structure variable
    ctrl_reg = 8'hfa;
    $display ("ctrl_reg = %p", ctrl_reg);
  end
endmodule
//output
/*
# KERNEL: ctrl_reg = '{mode:10, cfg:5, en:1}
# KERNEL: ctrl_reg = '{mode:3, cfg:5, en:1}
# KERNEL: ctrl_reg = '{mode:15, cfg:5, en:0}
*/