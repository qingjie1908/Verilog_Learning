//====typedef
//Normal declaration may turn out to be quite long
/*
unsigned shortint  			my_data;
enum {RED, YELLOW, GREEN} 	e_light;
bit [7:0]  					my_byte;
*/

// Declare an alias for this long definition
/*
typedef unsigned shortint 			u_shorti;
typedef enum {RED, YELLOW, GREEN} 	e_light;
typedef bit [7:0]  					ubyte;
*/

// Use these new data-types to create variables
/*
u_shorti    my_data;
e_light     light1;
ubyte       my_byte;
*/

//Syntax
/*
typedef data_type type_name [range];
*/
module tb;
  typedef shortint unsigned u_shorti;
  typedef enum {RED, YELLOW, GREEN} e_light;
  typedef bit [7:0] ubyte;

  initial begin
    u_shorti 	data = 32'hface_cafe;
    e_light 	light = GREEN;
    ubyte 		cnt = 8'hFF;

    $display ("light=%s data=0x%0h cnt=%0d", light.name(), data, cnt);
  end
endmodule
//output
/*
# KERNEL: light=GREEN data=0xcafe cnt=255
*/

//alias
/*
logic [7:0] data;
alias mydata = data; // alias "mydata" for signal "data"

initial begin
  mydata = 8'hFF; // assign the value to "data" using the alias "mydata"
end
*/