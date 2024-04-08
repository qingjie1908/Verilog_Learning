//Just like static variables in a class, constraints can be declared as static. 
//A static constraint is shared across all the class instances.

//Constraints are affected by the static keyword only if they are turned on and off using constraint_mode() method
//When a non-static constraint is turned off using this method, the constraint is turned off in that particular instance of the class which calls the method.
//But, when a static constraint is turned off and on using this method, the constraint is turned off and on in all the instances of the class.

//A constraint block can be declared as static by including the static keyword in its definition.

//Syntax

class [class_name];
	...

	static constraint [constraint_name] [definition]
endclass

//====Non-static Constraints

//Constraints are by default non-static 
//and hence a separate copy exists for each class instance.

class ABC;
  rand bit [3:0]  a;

  // Both are non-static constraints
  constraint c1 { a > 5; }
  constraint c2 { a < 12; }
endclass

module tb;
  initial begin
    ABC obj1 = new;
    ABC obj2 = new;
    for (int i = 0; i < 5; i++) begin
      obj1.randomize();
      obj2.randomize();
      $display ("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
    end
  end
endmodule
//See that both constraints are active in both the class instances obj1 and obj2.
//output
/*
# KERNEL: obj1.a = 7, obj2.a = 8
# KERNEL: obj1.a = 6, obj2.a = 9
# KERNEL: obj1.a = 10, obj2.a = 10
# KERNEL: obj1.a = 10, obj2.a = 9
# KERNEL: obj1.a = 8, obj2.a = 11
*/

//====Static Constraints

//Let us turn off a non-static constraint and compare it with the results when a static constraint is turned off.

//====Turn off non-static constraint

//In this case, we'll set the second constraint called c2 as static.

class ABC;
  rand bit [3:0]  a;

  // "c1" is non-static, but "c2" is static
  constraint c1 { a > 5; }
  static constraint c2 { a < 12; }
endclass

module tb;
  initial begin
    ABC obj1 = new;
    ABC obj2 = new;

    // Turn off non-static constraint
    obj1.c1.constraint_mode(0);

    for (int i = 0; i < 5; i++) begin
      obj1.randomize();
      obj2.randomize();
      $display ("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
    end
  end
endmodule
//When the non-static constraint c1 was turned off using constraint_mode()
//obj1 produced values outside the range specified by c1 constraint
//obj2 still has constraint a > 5
//output
/*
# KERNEL: obj1.a = 5, obj2.a = 8
# KERNEL: obj1.a = 5, obj2.a = 9
# KERNEL: obj1.a = 9, obj2.a = 10
# KERNEL: obj1.a = 10, obj2.a = 9
# KERNEL: obj1.a = 4, obj2.a = 11
*/

//Turn off static constraint

//In this case, the static constraint called c2 will be turned off. 
//We expect both the object instances obj1 and obj2 to be affected by this.

class ABC;
  rand bit [3:0]  a;

  // "c1" is non-static, but "c2" is static
  constraint c1 { a > 5; }
  static constraint c2 { a < 12; }
endclass

module tb;
  initial begin
    ABC obj1 = new;
    ABC obj2 = new;

    // Turn static constraint
    obj1.c2.constraint_mode(0);

    for (int i = 0; i < 5; i++) begin
      obj1.randomize();
      obj2.randomize();
      $display ("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
    end
  end
endmodule
//output
/*
# KERNEL: obj1.a = 7, obj2.a = 8
# KERNEL: obj1.a = 6, obj2.a = 9
# KERNEL: obj1.a = 14, obj2.a = 12
# KERNEL: obj1.a = 10, obj2.a = 11
# KERNEL: obj1.a = 8, obj2.a = 7
*/