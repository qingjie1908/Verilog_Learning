// scalar and vector

// scalar
// a net or reg declaration without range specification is 1-bit wide and is salar
wire o_nor;
reg parity;

// vector
// net or reg has range specified
// msb is in left of range
// msb and lsb should be constant expressions
wire [7:0] o_flop;
reg [31:0] addr;

// bit select
reg [31:0] addr;
addr [23:16] = 8'h23; // 00100011

// [<start_bit> +: <width>]
// [<start_bit> -: <width>]

module des;
    reg [31:0] data;
    integer i;

    initial begin
        data = 32'hFACE_CAFE;
        for(i = 0; i < 4; i++) begin
            $display("data[8*%0d +: 8] = 0x%0h", i, data[8*i +: 8]);
        end
    end
endmodule

/* Output:
data[8*0 +: 8] = 0xfe
data[8*1 +: 8] = 0xca
data[8*2 +: 8] = 0xce
data[8*3 +: 8] = 0xfa
*/


