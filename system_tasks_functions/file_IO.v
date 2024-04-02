//Verilog File IO Operations

//Verilog has system tasks and functions that can open files, output values into files, read values from files and load into other variables and close files.

module tb;
	// Declare a variable to store the file handler
	integer fd;

	initial begin
		// Open a new file by the name "my_file.txt"
		// with "write" permissions, and store the file
		// handler pointer in variable "fd"
		fd = $fopen("my_file.txt", "w");

		// Close the file handle pointed to by "fd"
		$fclose(fd);
	end
endmodule

//Opening file modes
/*
Argument	Description
"r" or "rb"	Open for reading
"w" or "wb"	Create a new file for writing. If the file exists, truncate it to zero length and overwrite it
"a" or "ab"	If file exists, append (open for writing at EOF), else create a new file
"r+", "r+b" or "rb+"	Open for both reading and writing
"w+", "w+b" or "wb+"	Truncate or create for update
"a+", "a+b", or "ab+"	Append, or create new file for update at EOF
*/

//========== How to write files
/*
Function	Description
$fdisplay	Similar to $display, writes out to file instead
$fwrite	Similar to $write, writes out to file instead
$fstrobe	Similar to $strobe, writes out to file instead
$fmonitor	Similar to $monitor, writes out to file instead
*/

//Each of the above system functions print values in radix decimal. 
//They also have three other versions to print values in binary, octal and hexadecimal.
/*
Function	Description
$fdisplay()	Prints in decimal by default
$fdisplayb()	Prints in binary
$fdisplayo()	Prints in octal
$fdisplayh()	Prints in hexadecimal
*/

module tb;
	integer  	fd;
	integer 	i;
	reg [7:0] 	my_var;

	initial begin
		// Create a new file
		fd = $fopen("my_file.txt", "w");
		my_var = 0;

      $fdisplay(fd, "Value displayed with $fdisplay");
		#10 my_var = 8'h1A;
		$fdisplay(fd, my_var);      // Displays in decimal
		$fdisplayb(fd, my_var); 	// Displays in binary
		$fdisplayo(fd, my_var); 	// Displays in octal
		$fdisplayh(fd, my_var); 	// Displays in hex

	  // $fwrite does not print the newline char '' automatically at
	  // the end of each line; So we can predict all the values printed
	  // below to appear on the same line
      $fdisplay(fd, "Value displayed with $fwrite");
		#10 my_var = 8'h2B;
		$fwrite(fd, my_var);
		$fwriteb(fd, my_var);
		$fwriteo(fd, my_var);
		$fwriteh(fd, my_var);


      // Jump to new line with '', and print with strobe which takes
      // the final value of the variable after non-blocking assignments
      // are done
      $fdisplay(fd, "\n Value displayed with $fstrobe");
		#10 my_var <= 8'h3C;
		$fstrobe(fd, my_var);
		$fstrobeb(fd, my_var);
		$fstrobeo(fd, my_var);
		$fstrobeh(fd, my_var);

      #10 $fdisplay(fd, "Value displayed with $fmonitor");
	  $fmonitor(fd, my_var);

		for(i = 0; i < 5; i= i+1) begin
			#5 my_var <= i;
		end

      #10 $fclose(fd);
	end
endmodule

//======== How to read files

//Reading a line

//The system function $fgets reads characters from the file specified by [hl]fd[/hd] into the variable str until str is filled, or a newline character is read and transferred to str, or an EOF condition is encountered.

//If an error occurs during the read, it returns code zero. otherwise it returns the number of characters read.

//Detecting EOF
//The system function $feof returns a non-zero value when EOF is found, and returns zero otherwise for a given file descriptor as argument.

module tb;
	reg[8*45:1] str;
	integer  	fd;

	initial begin
	  fd = $fopen("my_file.txt", "r");

	  // Keep reading lines until EOF is found
      while (! $feof(fd)) begin

      	// Get current line into the variable 'str'
        $fgets(str, fd);

        // Display contents of the variable
        $display("%0s", str);
      end
      $fclose(fd);
	end
endmodule


//Multiple arguments to fdisplay

//When multiple variables are given to $fdisplay, 
//it simply prints all variables in the given order one after the other 
//without a space.

module tb;
  reg [3:0] a, b, c, d;
  reg [8*30:0] str;
  integer fd;

  initial begin
    a = 4'ha;
    b = 4'hb;
    c = 4'hc;
    d = 4'hd;

    fd = $fopen("my_file.txt", "w");
    $fdisplay(fd, a, b, c, d);
    $fclose(fd);
  end
endmodule

//Formatting data to a string

//First argument in the $sformat system function is the variable name into which the result is placed. 
//The second argument is the format_string which tells how the following arguments should be formatted into a string.

module tb;
	reg [8*19:0] str;
	reg [3:0] a, b;


	initial begin
		a = 4'hA;
		b = 4'hB;

		// Format 'a' and 'b' into a string given
		// by the format, and store into 'str' variable
		$sformat(str, "a=%0d b=0x%0h", a, b);
		$display("%0s", str);
	end
endmodule

