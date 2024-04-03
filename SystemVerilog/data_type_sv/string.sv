//The string data-type is an ordered collection of characters. 
//The length of a string variable is the number of characters in the collection 
//which can have dynamic length and vary during the course of a simulation. 
//A string variable does not represent a string in the same way as a string literal. 
//No truncation occurs when using the string variable.

//Syntax
//string  variable_name [= initial_value];

module tb;
  // Declare a string variable called "dialog" to store string literals
  // Initialize the variable to "Hello!"
  string dialog = "Hello!";

  initial begin
    // Display the string using %s string format
    $display ("%s", dialog);

    // Iterate through the string variable to identify individual characters and print
    foreach (dialog[i]) begin
      $display ("%s", dialog[i]); // why wrong?
    end
  end
endmodule

module tb2;
  string firstname = "Joey";
  string lastname  = "Tribbiani";

  initial begin
    // String Equality : Check if firstname equals or not equals lastname
    if (firstname == lastname)
      $display ("firstname=%s is EQUAL to lastname=%s", firstname, lastname);

    if (firstname != lastname)
      $display ("firstname=%s is NOT EQUAL to lastname=%s", firstname, lastname);

    // String comparison : Check if length of firstname < length of lastname
    if (firstname < lastname)
      $display ("firstname=%s is LESS THAN lastname=%s", firstname, lastname);

    // String comparison : Check if length of firstname > length of lastname
    if (firstname > lastname)
      $display ("firstname=%s is GREATER THAN lastname=%s", firstname, lastname);

    // String concatenation : Join first and last names into a single string
    $display ("Full Name = %s", {firstname, " ", lastname});

    // String Replication
    $display ("%s", {3{firstname}});

    // String Indexing : Get the ASCII character at index number 2 of both first and last names
    $display ("firstname[2]=%s lastname[2]=%s", firstname[2], lastname[2]);

  end
endmodule

//output
/*
firstname=Joey is NOT EQUAL to lastname=Tribbiani
firstname=Joey is LESS THAN lastname=Tribbiani
Full Name = Joey Tribbiani
JoeyJoeyJoey
firstname[2]=e lastname[2]=i
*/

//Basic String Methods

//SystemVerilog also includes a number of special methods to work with strings, which use built-in method notation.

/*
Usage	Definition	Comments
str.len()	function int len()	Returns the number of characters in the string
str.putc()	function void putc (int i, byte c);	Replaces the ith character in the string with the given character
str.getc()	function byte getc (int i);	Returns the ASCII code of the ith character in str
str.tolower()	function string tolower();	Returns a string with characters in str converted to lowercase
str.compare(s)	function int compare (string s);	Compares str and s, as in the ANSI C strcmp function
str.icompare(s)	function int icompare (string s);	Compares str and s, like the ANSI C strcmp function
str.substr (i, j)	function string substr (int i, int j);	Returns a new string that is a substring formed by characters in position i through j of str
*/

module tb3;
   string str = "Hello World!";

   initial begin
   	  string tmp;

	  // Print length of string "str"
      $display ("str.len() = %0d", str.len());

      // Assign to tmp variable and put char "d" at index 3
      tmp = str;
      tmp.putc (3,"d");
      $display ("str.putc(3, d) = %s", tmp);

      // Get the character at index 2
      $display ("str.getc(2) = %s (%0d)", str.getc(2), str.getc(2));

      // Convert all characters to lower case
      $display ("str.tolower() = %s", str.tolower());

      // Comparison
      tmp = "Hello World!";
      $display ("[tmp,str are same] str.compare(tmp) = %0d", str.compare(tmp));
      tmp = "How are you ?";
      $display ("[tmp,str are diff] str.compare(tmp) = %0d", str.compare(tmp));

      // Ignore case comparison
      tmp = "hello world!";
      $display ("[tmp is in lowercase] str.compare(tmp) = %0d", str.compare(tmp));
      tmp = "Hello World!";
      $display ("[tmp,str are same] str.compare(tmp) = %0d", str.compare(tmp));

      // Extract new string from i to j
      $display ("str.substr(4,8) = %s", str.substr (4,8));

   end
endmodule

//output
/*
# KERNEL: str.len() = 12
# KERNEL: str.putc(3, d) = Heldo World!
# KERNEL: str.getc(2) = l (108)
# KERNEL: str.tolower() = hello world!
# KERNEL: [tmp,str are same] str.compare(tmp) = 0
# KERNEL: [tmp,str are diff] str.compare(tmp) = -1
# KERNEL: [tmp is in lowercase] str.compare(tmp) = -1
# KERNEL: [tmp,str are same] str.compare(tmp) = 0
# KERNEL: str.substr(4,8) = o Wor
*/

/*
String Conversion Methods

str.atoi()	function integer atoi();	Returns the integer corresponding to the ASCII decimal representation in str
str.atohex()	function integer atohex();	Interprets the string as hexadecimal
str.atooct()	function integer atooct();	Interprets the string as octal
str.atobin()	function integer atobin();	Interprets the string as binary
str.atoreal()	function real atoreal();	Returns the real number corresponding to the ASCII decimal representation in str
str.itoa(i)	function void itoa (integer i);	Stores the ASCII decimal representation of i into str
str.hextoa(i)	function void hextoa (integer i);	Stores the ASCII hexadecimal representation of i into str
str.octtoa(i)	function void octtoa (integer i);	Stores the ASCII octal representation of i into str
str.bintoa(i)	function void bintoa (integer i);	Stores the ASCII binary representation of i into str
str.realtoa(r)	function void realtoa (real r);	Stores the ASCII real representation of r into str
*/