// A number of dimensions specified after identifier
// array are allowed for reg, wire, integer and real data types

reg y1 [11:0]; // y1 is scalar
wire [7:0] y2 [0:3]; // y2 is an 8-bit vector net with depth of 4
reg [7:0] y3 [0:1][0:3] // y3 is 2D array, 2 rows, 4 columns, each element is an 8-bit widenvector


y1 = 0; // illegal, all elements can't be assigned in single 
y2[0] = 8'ha2; // assign 0xa2 to index = 0
y3[1][2] = 8'hdd;

module des();
    reg [15:0] mem3 [0:3][0:1];
    
    initial begin
        for(integer i = 0; i < 4; i = i + 1) begin
            for (integer j = 0; j < 2; j += 1) begin
                mem3[i][j] = i + j;
                $display("mem3[%0d][%0d] = 0x%0h", i, j, mem3[i][j]);
            end
        end
        mem3[0][0][15:8] = 8'haa;
        $display("mem3[0][0] = 0x%0h", mem3[0][0]); //0xaa00
    end
endmodule

/*
Output:
mem3[0][0] = 0x0
mem3[0][1] = 0x1
mem3[1][0] = 0x1
mem3[1][1] = 0x2
mem3[2][0] = 0x2
mem3[2][1] = 0x3
mem3[3][0] = 0x3
mem3[3][1] = 0x4
mem3[0][0] = 0xaa00
*/