//Variables that are declared as rand or randc inside a class are randomized using the built-in randomize() method.
//The method returns 1 if randomization was successful, and 0 if it failed.
//It can fail due to a variety of reasons like conflicting constraints, solver could not come up with a value that meets all constraints and such.
//Class objects are not randomized automatically,
//and hence we should always call the randomize() method to do randomization.

//Syntax
/*
virtual function int randomize ();
Let's look at a simple example to see how randomize() can be called.
*/

class Beverage;
  rand bit [7:0]	beer_id;

  constraint c_beer_id { beer_id >= 10;
                        beer_id <= 50; };

endclass

module tb;
   Beverage b;

    initial begin
      b = new ();
      $display ("Initial beerId = %0d", b.beer_id);
      if (b.randomize ())
      	$display ("Randomization successful !");
      $display ("After randomization beerId = %0d", b.beer_id);
    end
endmodule
//output
/*
# KERNEL: Initial beerId = 0
# KERNEL: Randomization successful !
# KERNEL: After randomization beerId = 25
*/

//There are a couple of callback functions that are automatically called by randomize() 
//before and after computing random values.

//====pre_randomize()

//This function is defined within the same class whose object will be randomized and called before randomization().

//function void pre_randomize();

class Beverage;
  rand bit [7:0]	beer_id;

  constraint c_beer_id { beer_id >= 10;
                        beer_id <= 50; };

  function void pre_randomize ();
  	$display ("This will be called just before randomization");
  endfunction

endclass

module tb;
   Beverage b;

    initial begin
      b = new ();
      $display ("Initial beerId = %0d", b.beer_id);
      if (b.randomize ())
      	$display ("Randomization successful !");
      $display ("After randomization beerId = %0d", b.beer_id);
    end
endmodule
//output
/*
# KERNEL: Initial beerId = 0
# KERNEL: This will be called just before randomization
# KERNEL: Randomization successful !
# KERNEL: After randomization beerId = 25
*/

//====post_randomize()

//This function is also defined within the same class whose object will be randomized and called after randomization().

//function void post_randomize();

//Example

class Beverage;
  rand bit [7:0]	beer_id;

  constraint c_beer_id { beer_id >= 10;
                        beer_id <= 50; };

  function void pre_randomize ();
  	$display ("This will be called just before randomization");
  endfunction

  function void post_randomize ();
  	$display ("This will be called just after randomization");
  endfunction

endclass

module tb;
   Beverage b;

    initial begin
      b = new ();
      $display ("Initial beerId = %0d", b.beer_id);
      if (b.randomize ())
      	$display ("Randomization successful !");
      $display ("After randomization beerId = %0d", b.beer_id);
    end
endmodule
//output
/*
# KERNEL: Initial beerId = 0
# KERNEL: This will be called just before randomization
# KERNEL: This will be called just after randomization
# KERNEL: Randomization successful !
# KERNEL: After randomization beerId = 25
*/

//====Override
//What we did before is to override existing empty pre_randomize() and post_randomize() methods with our own definition.
//This is a neat way to change randomization characteristics of an object.
//If the class is a derived class and no user-defined implementation of the two methods exist, then both methods will automatically call its super function.

//Note that pre_randomize() and post_randomize() are not virtual, 
//but behave as virtual methods.
//In case you try to manually make them virtual, you'll probably hit a compiler error

//Also note the following points:

//If randomize() fails, then post_randomize() is not called
//randomize() method is built-in and cannot be overriden
//If randomization fails, then the variables retain their original values and are not modified