//A file can be opened for either read or write using the $fopen() system task.
//This task will return a 32-bit integer handle called a file descriptor
//This handle should be used to read and write into that file until it is closed. 
//The file descriptor can be closed with the $fclose() system task.
//No further reads or writes to the file descriptor is allowed once it is closed.

module tb;
  initial begin
  	// 1. Declare an integer variable to hold the file descriptor
    //fd is initially zero
    //and gets a valid value from $fopen()
  	int fd;

  	// 2. Open a file called "note.txt" in the current folder with a "read" permission
  	// If the file does not exist, then fd will be zero
    fd = $fopen ("./note.txt", "r");
    if (fd != 0)  $display("File was opened successfully : %0d", fd);
    else     $display("File was NOT opened successfully : %0d", fd);

    // 2. Open a file called "note.txt" in the current folder with a "write" permission
    //    "fd" now points to the same file, but in write mode
    fd = $fopen ("./note.txt", "w"); //note that if file not exist, this step will create a file if in write mode
    if (fd != 0)  $display("File was opened successfully : %0d", fd);
    else     $display("File was NOT opened successfully : %0d", fd);

    // 3. Close the file descriptor
    $fclose(fd);
  end
endmodule

//output
/*
File was NOT opened successfully : 0
File was opened successfully : -2147483604
*/

//It is important to close all open files before end of simulation to completely write contents into the file

//====How to open in read and append modes ?

//By default a file is opened in the write w mode. 
//The file can also be opened in other modes by providing the correct mode type. 
//The following table shows all the different modes a file can be opened in.
/*
Argument	Description
"r"	Open for reading
"w"	Create for writing, overwrite if it exists
"a"	Create if file does not exist, else append; open for writing at end of file
"r+"	Open for update (reading and writing)
"w+"	Truncate or create for update
"a+"	Append, open or create for update at EOF
*/

module tb;
  initial begin
  	int fd_w, fd_r, fd_a, fd_wp, fd_rp, fd_ap;

    fd_w = $fopen ("./todo.txt", "w"); 	// Open a new file in write mode and store file descriptor in fd_w
    fd_r = $fopen ("./todo.txt", "r"); 	// Open in read mode
    fd_a = $fopen ("./todo.txt", "a"); 	// Open in append mode


    if (fd_w)     $display("File was opened successfully : %0d", fd_w);
    else      	  $display("File was NOT opened successfully : %0d", fd_w);

    if (fd_r)     $display("File was opened successfully : %0d", fd_r);
    else      	  $display("File was NOT opened successfully : %0d", fd_r);

    if (fd_a)     $display("File was opened successfully : %0d", fd_a);
    else      	  $display("File was NOT opened successfully : %0d", fd_a);

    // Close the file descriptor
    $fclose(fd_w);
    $fclose(fd_r);
    $fclose(fd_a);
  end
endmodule
//all three variables have a different value and each one points to the same file, but with different access permissions.
//output
/*
# KERNEL: File was opened successfully : -2147483645
# KERNEL: File was opened successfully : -2147483644
# KERNEL: File was opened successfully : -2147483643
*/

//====How to read and write to a file ?

//Files should be opened in the write w mode, or append a mode. 
//System tasks like $fdisplay() and $fwrite() can be used to write a formatted string into the file. 
//The first argument of these tasks is the file descriptor handle and the second will be the data to be stored.

//To read a file, it has to be opened in either read r mode or read-write r+ mode. 
//$fgets() is a system task that will read a single line from the file. 
//If this task is called 10 times, then it will read 10 lines.

module tb;
  int 	 fd; 			// Variable for file descriptor handle
  string line; 			// String value read from the file

  initial begin

    // 1. Lets first open a new file and write some contents into it
    fd = $fopen ("trial", "w");

    // Write each index in the for loop to the file using $fdisplay
    // File handle should be the first argument
    for (int i = 0; i < 5; i++) begin
      $fdisplay (fd, "Iteration = %0d", i);
    end

    // Close this file handle
    $fclose(fd);


    // 2. Let us now read back the data we wrote in the previous step
    fd = $fopen ("trial", "r");

    // Use $fgets to read a single line into variable "line"
    $fgets(line, fd);
    $display ("Line read : %s", line);

    // Get the next line and display
    $fgets(line, fd);
    $display ("Line read : %s", line);

    // Close this file handle
    $fclose(fd);
  end
endmodule
//note $display will add newline 
//output
/*
# KERNEL: Line read : Iteration = 0
# KERNEL: 
# KERNEL: Line read : Iteration = 1
# KERNEL: 
*/

//====How to read until end of file ?

//In the previous example, we used $fgets() system task twice to read two lines from the file. 
//SystemVerilog has another task called $feof() that returns true when end of the file has reached. 
//This can be used in a loop as follows to read the entire contents of a file.

module tb;
  int 	 fd; 			// Variable for file descriptor handle
  string line; 			// String value read from the file

  initial begin
    // 1. Lets first open a new file and write some contents into it
    fd = $fopen ("trial", "w");
    for (int i = 0; i < 5; i++) begin
      $fdisplay (fd, "Iteration = %0d", i);
    end
    $fclose(fd);


    // 2. Let us now read back the data we wrote in the previous step
    fd = $fopen ("trial", "r");

    while (!$feof(fd)) begin
      $fgets(line, fd);
      $display ("Line: %s", line);
    end

    // Close this file handle
    $fclose(fd);
  end
endmodule
//output one more since file has newline '\n' at last line
//output
/*
# KERNEL: Line: Iteration = 0
# KERNEL: 
# KERNEL: Line: Iteration = 1
# KERNEL: 
# KERNEL: Line: Iteration = 2
# KERNEL: 
# KERNEL: Line: Iteration = 3
# KERNEL: 
# KERNEL: Line: Iteration = 4
# KERNEL: 
# KERNEL: Line: 
*/

//====How to parse a line for values ?

//SystemVerilog has another system task called $fscanf() 
//that allows us to scan and get certain values.

module tb;
  int 	 fd; 			// Variable for file descriptor handle
  int 	 idx;
  string str;

  initial begin
    // 1. Lets first open a new file and write some contents into it
    fd = $fopen ("trial", "w");
    for (int i = 0; i < 5; i++)
      $fdisplay (fd, "Iteration = %0d", i);
    $fclose(fd);


    // 2. Let us now read back the data we wrote in the previous step
    fd = $fopen ("trial", "r");

    // fscanf returns the number of matches
    while ($fscanf (fd, "%s = %0d", str, idx) == 2) begin
      $display ("Line: %s = %0d", str, idx);
    end

    // Close this file handle
    $fclose(fd);
  end
endmodule
//output
/*
# KERNEL: Line: Iteration = 0
# KERNEL: Line: Iteration = 1
# KERNEL: Line: Iteration = 2
# KERNEL: Line: Iteration = 3
# KERNEL: Line: Iteration = 4
*/