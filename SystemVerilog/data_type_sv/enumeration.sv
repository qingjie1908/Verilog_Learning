//An enumerated type defines a set of named values

//enum          {RED, YELLOW, GREEN}         light_1;         // int type; RED = 0, YELLOW = 1, GREEN = 2
//enum bit[1:0] {RED, YELLOW, GREEN}         light_2;         // bit type; RED = 0, YELLOW = 1, GREEN = 2

/*
enum          {RED=3, YELLOW, GREEN}       light_3;         // RED = 3, YELLOW = 4, GREEN = 5
enum          {RED = 4, YELLOW = 9, GREEN} light_4;         // RED = 4, YELLOW = 9, GREEN = 10 (automatically assigned)
enum          {RED = 2, YELLOW, GREEN = 3} light_5;         // Error : YELLOW and GREEN are both assigned 3

enum bit[0:0] {RED, YELLOW, GREEN} light_6;  
*/

module tb;
	// "e_true_false" is a new data-type with two valid values: TRUE and FALSE
	typedef enum {TRUE, FALSE} e_true_false;

	initial begin
		// Declare a variable of type "e_true_false" that can store TRUE or FALSE
		e_true_false  answer;

		// Assign TRUE/FALSE to the enumerated variable
		answer = TRUE;

		// Display string value of the variable
		$display ("answer = %s", answer.name);
	end
endmodule
//output
//# KERNEL: answer = TRUE

module tb2;
  // name : The next number will be associated with name starting from 0
  // GREEN = 0, YELLOW = 1, RED = 2, BLUE = 3
  typedef enum {GREEN, YELLOW, RED, BLUE} color_set_1;

  // name = C : Associates the constant C to name
  // MAGENTA = 2, VIOLET = 7, PURPLE = 8, PINK = 9
  typedef enum {MAGENTA=2, VIOLET=7, PURPLE, PINK} color_set_2;

  // name[N] : Generates N named constants : name0, name1, ..., nameN-1
  // BLACK0 = 0, BLACK1 = 1, BLACK2 = 2, BLACK3 = 3
  typedef enum {BLACK[4]} color_set_3;

  // name[N] = C : First named constant gets value C and subsequent ones
  // are associated to consecutive values
  // RED0 = 5, RED1 = 6, RED2 = 7
  typedef enum {RED[3] = 5} color_set_4;

  // name[N:M] : First named constant will be nameN and last named
  // constant nameM, where N and M are integers
  // YELLOW3 = 0, YELLOW4 = 1, YELLOW5 = 2
  typedef enum {YELLOW[3:5]} color_set_5;

  // name[N:M] = C : First named constant, nameN will get C and
  // subsequent ones are associated to consecutive values until nameM
  // WHITE3 = 4, WHITE4 = 5, WHITE5 = 6
  typedef enum {WHITE[3:5] = 4} color_set_6;

  initial begin
    // Create new variables for each enumeration style
  	color_set_1 color1;
    color_set_2 color2;
    color_set_3 color3;
    color_set_4 color4;
    color_set_5 color5;
    color_set_6 color6;

    color1 = YELLOW; $display ("color1 = %0d, name = %s", color1, color1.name());
    color2 = PURPLE; $display ("color2 = %0d, name = %s", color2, color2.name());
    color3 = BLACK3; $display ("color3 = %0d, name = %s", color3, color3.name());
    color4 = RED1;   $display ("color4 = %0d, name = %s", color4, color4.name());
    color5 = YELLOW3;$display ("color5 = %0d, name = %s", color5, color5.name());
    color6 = WHITE4; $display ("color6 = %0d, name = %s", color6, color6.name());

  end
endmodule

//output
/*
# KERNEL: color1 = 1, name = YELLOW
# KERNEL: color2 = 8, name = PURPLE
# KERNEL: color3 = 3, name = BLACK3
# KERNEL: color4 = 6, name = RED1
# KERNEL: color5 = 0, name = YELLOW3
# KERNEL: color6 = 5, name = WHITE4
*/

//Enumerated-Type Methods
/*
first()	function enum first();	Returns the value of the first member of the enumeration
last()	function enum last();	Returns the value of the last member of the enumeration
next()	function enum next (int unsigned N = 1);	Returns the Nth next enumeration value starting from the current value of the given variable
prev()	function enum prev (int unsigned N = 1);	Returns the Nth previous enumeration value starting from the current value of the given variable
num()	function int num();	Returns the number of elements in the given enumeration
name()	function string name();	Returns the string representation of the given enumeration value
*/

//GREEN = 0, YELLOW = 1, RED = 2, BLUE = 3
typedef enum {GREEN, YELLOW, RED, BLUE} colors;

module tb3;
	initial begin
      colors color;

      // Assign current value of color to YELLOW
      color = YELLOW;

      $display ("color.first() = %0d", color.first());  // First value is GREEN = 0
      $display ("color.last()  = %0d", color.last());	// Last value is BLUE = 3
      $display ("color.next()  = %0d", color.next()); 	// Next value is RED = 2
      $display ("color.prev()  = %0d", color.prev()); 	// Previous value is GREEN = 0
      $display ("color.num()   = %0d", color.num()); 	// Total number of enum = 4
      $display ("color.name()  = %s" , color.name()); 	// Name of the current enum
    end
endmodule

//output
/*
# KERNEL: color.first() = 0
# KERNEL: color.last()  = 3
# KERNEL: color.next()  = 2
# KERNEL: color.prev()  = 0
# KERNEL: color.num()   = 4
# KERNEL: color.name()  = YELLOW
*/



module tb4;

  typedef enum bit [1:0] {RED, YELLOW, GREEN} e_light;
  e_light light;

  initial begin
  	light = GREEN;
  	$display ("light = %s", light.name());

  	// Invalid because of strict typing rules
  	//light = 0;
  	//$display ("light = %s", light.name());

  	// OK when explicitly cast
    light = e_light'(1);
  	$display ("light = %s", light.name());

  	// OK. light is auto-cast to integer
    if (light == RED | light == 2)
    	$display ("light is now %s", light.name());

  end
endmodule

//output
/*
# KERNEL: light = GREEN
# KERNEL: light = YELLOW
*/