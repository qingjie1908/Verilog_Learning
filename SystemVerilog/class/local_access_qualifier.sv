//A member declared as local is available only to the methods of the same class, 
//and are not accessible by child classes. 
//However, nonlocal methods that access local members can be inherited and overridden by child class.

//====When accessed from outside the class

class ABC;
  // By default, all variables are public and for this example,
  // let's create two variables - one public and the other "local"
  byte  	  public_var;
  local byte local_var;

  // This function simply prints these variable contents
  function void display();
    $display ("public_var=0x%0h, local_var=0x%0h", public_var, local_var);
  endfunction
endclass

module tb;
  initial begin

    // Create a new class object, and call display method
    ABC abc = new();
    abc.display();

    // Public variables can be accessed via the class handle
    $display ("public_var = 0x%0h", abc.public_var);

    // However, local variables cannot be accessed from outside
    $display ("local_var = 0x%0h", abc.local_var);
  end
endmodule

//error occured, abc.local_var not allowed since local_var only available inside class by keyword local
//cannot access local/protected member ""abc.local_var"" from this scope.

//====When accessed by child classes

//In this example, let us try to access the local member from within a child class. We expect to see an error here also because local is not visible to child classes either.

// Define a base class and let the variable be "local" to this class
class ABC;
  local byte local_var;
endclass

// Define another class that extends ABC and have a function that tries
// to access the local variable in ABC
class DEF extends ABC;
  function show();
    $display ("local_var = 0x%0h", local_var);
  endfunction
endclass

module tb;
  initial begin

    // Create a new object of the child class, and call the show method
    // This will give a compile time error because child classes cannot access
    // base class "local" variables and methods
    DEF def = new();
    def.show();

  end
endmodule
//ERROR VCP5248 "Cannot access local/protected member ""local_var"" from this scope."

