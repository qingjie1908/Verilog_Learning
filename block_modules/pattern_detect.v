`timescale 1ns/1ns;

module det_110101 (
    input clk, rstn, in,
    output out
);

// total 7 states
parameter IDLE = 0; //any state that current state + in is not in part of the patter we want to detect
parameter S1 = 1;
parameter S11 = 2;
parameter S110 = 3;
parameter S1101 = 4;
parameter S11010 = 5;
parameter S110101 = 6;

reg [2:0] cur_state, next_state; // store 0 to 6 to represent the state parameter

// check cur_state, if match patter, out = 1
assign out = cur_state == S110101 ? 1 : 0; 

// update cur_state by clk
always @(posedge clk) begin
    if (!rstn) begin
        cur_state <= IDLE;
    end
    else begin
        cur_state <= next_state;
    end
    $display("[%0t] in=%0d out=%0d cur=%0d next=%0d", $time, in, out, cur_state, next_state);
end

// input new bit,
always @(cur_state or in) begin //why cur_state?
    case (cur_state)
        IDLE: begin
            if (in) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE;
            end
        end

        S1: begin
            if (in) begin
                next_state <= S11;
            end else begin
                next_state <= IDLE;
            end
        end

        S11: begin
            if (!in) begin
                next_state <= S110;
            end else begin
                next_state <= S11; // note, S11 add input 1, back to S11, not IDLE
            end
        end

        S110: begin
            if (in) begin
                next_state <= S1101;
            end else begin
                next_state <= IDLE; 
            end
        end

        S1101: begin
            if (!in) begin
                next_state <= S11010;
            end else begin
                next_state <= S11; // note, S1101 add input 1, back to S11, not IDLE
            end
        end

        S11010: begin
            if (in) begin
                next_state <= S110101;
            end else begin
                next_state <= IDLE; 
            end
        end

        S110101: begin
            if (in) begin
                next_state <= S1;
            end else begin
                next_state <= IDLE; 
            end
        end
    endcase
end
endmodule

module tb ();

    reg clk, rstn, in;
    wire out;

    always #10 clk = ~clk;

    det_110101 u0(.clk(clk), .rstn(rstn), .in(in), .out(out));


    initial begin
        {clk, rstn, in} <= 0;

        repeat (5) @(posedge clk);
        rstn <= 1;

        @(posedge clk) in <= 1;
        @(posedge clk) in <= 1;
        @(posedge clk) in <= 0;
        @(posedge clk) in <= 1;
        @(posedge clk) in <= 0;
        @(posedge clk) in <= 1;
        @(posedge clk) in <= 1;
        @(posedge clk) in <= 1;
        @(posedge clk) in <= 0;
        @(posedge clk) in <= 1;
        @(posedge clk) in <= 0;
        @(posedge clk) in <= 1;

        #100 $finish;

    end
    
endmodule

//output
/*
[10] in=0 out=x cur=x next=x
[30] in=0 out=0 cur=0 next=0
[50] in=0 out=0 cur=0 next=0
[70] in=0 out=0 cur=0 next=0
[90] in=0 out=0 cur=0 next=0
[110] in=0 out=0 cur=0 next=0
[130] in=1 out=0 cur=0 next=1
[150] in=1 out=0 cur=1 next=2
[170] in=0 out=0 cur=2 next=3
[190] in=1 out=0 cur=3 next=4
[210] in=0 out=0 cur=4 next=5
[230] in=1 out=0 cur=5 next=6
[250] in=1 out=1 cur=6 next=1
[270] in=1 out=0 cur=1 next=2
[290] in=0 out=0 cur=2 next=3
[310] in=1 out=0 cur=3 next=4
[330] in=0 out=0 cur=4 next=5
[350] in=1 out=0 cur=5 next=6
[370] in=1 out=1 cur=6 next=1
[390] in=1 out=0 cur=1 next=2
[410] in=1 out=0 cur=2 next=2
main.v:124: $finish called at 430 (1ns)
[430] in=1 out=0 cur=2 next=2
*/