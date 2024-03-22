// Nets and variables are two main groups of data types which represent different hardware structures

// Nets ========:
// Nets are used to connect between hardware entities like logic gates
// hence do not store any value on its own
// input / output are connect to nets

wire [3:0] n0; // 4-bit wire -> this is a vector, n0[0] is the first wire (line) in this vector


// Variable ========:

// reg
reg [3:0] d0;
reg [7:0] d1;

// integer
// variable of 32 bits wide
integer count;

// time
// variable of unsigned, 64-bits wide, to store sumulation time quantities for debugging
time end_time; // end_time can be stored a time value like 50ns
realtime rtime; // rtime = 40.255ps, realtime store floating time value

// real
// real variable can store floating point values
real float = 12.344;


module tb_;
    integer int_a;
    real    real_b;
    time    time_c;

    reg [8*11:1] str1; // each char takes 1byte = 8bit
    reg [8*5:1] str2;
    reg [8*20:1] str3;

    initial begin
        int_a = 32'hcafe_1234; //_ just as deliminator for readablity
        real_b = 0.12345;

        str1 = "Hello world";
        str2 = "Hello world";
        str3 = "Hello world";

        #20;    // Advance simulation time by 20 units
        time_c = $time;
        
        // Print all varaibles using $display system task
        $display("init_a = 0x%h", int_a); //init_a = 0xcafe1234
        $display("real_b = %0.5f", real_b); //real_b = 0.12345
        $display("time_c = %t", time_c); //time_c =                   20
        $display("str1 = %s", str1); //str1 = Hello world
        $display("str2 = %s", str2); //str2 = world
        $display("str3 = %s", str3); //str3 =          Hello world
    end

endmodule


