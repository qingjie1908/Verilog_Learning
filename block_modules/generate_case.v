// Design #1: Half adder
module ha (input a, b,
           output reg sum, cout);
  always @ (a or b)
  {cout, sum} = a + b;

  initial
    $display ("Half adder instantiation");
endmodule

// Design #2: Full adder
module fa (input a, b, cin,
           output reg sum, cout);
  always @ (a or b or cin)
  {cout, sum} = a + b + cin;

    initial
      $display ("Full adder instantiation");
endmodule

// Top level design: Choose between half adder and full adder
module my_adder (input a, b, cin,
                 output sum, cout);
  parameter ADDER_TYPE = 1;

  generate
    case(ADDER_TYPE)
      0 : ha u0 (.a(a), .b(b), .sum(sum), .cout(cout));
      1 : fa u1 (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
    endcase
  endgenerate
endmodule

module tb;
  reg a, b, cin;
  wire sum, cout;

  my_adder #(.ADDER_TYPE(0)) u0 (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  initial begin
    a <= 0;
    b <= 0;
    cin <= 0;

    $monitor("monitor: time=%0t a=0x%0h b=0x%0h cin=0x%0h cout=0x%0h sum=0x%0h",
             $time, a, b, cin, cout, sum);

    for (integer i = 0; i < 5; i = i + 1) begin
      #10 a <= $random;
      b <= $random;
      cin <= $random;
      // at this time(10 time units), a, b, cin has still contain its original value
      // so display is display their original value at 10 time units
      // but monitor will show their updated value at 10 time units
      // after end, a, b, cin will updated
      // and next time, time units 20, display will have its value same as last monitor at time units 10, which is updated
      $display("display: i=%0d time=%0t a=0x%0h b=0x%0h cin=0x%0h cout=0x%0h sum=0x%0h", i, $time, a, b, cin, cout, sum );
    end
  end
endmodule

//output: (if in tb code $display("display: i=%0d time=%0t a=0x%0h b=0x%0h cin=0x%0h cout=0x%0h sum=0x%0h", i, $time, a, b, cin, cout, sum );)
//output only four monitor since when i=3 and i=4, the parameter value in monitor did not change
/*
Half adder instantiation
monitor: time=0 a=0x0 b=0x0 cin=0x0 cout=0x0 sum=0x0
display: i=0 time=10 a=0x0 b=0x0 cin=0x0 cout=0x0 sum=0x0
monitor: time=10 a=0x0 b=0x1 cin=0x1 cout=0x0 sum=0x1
display: i=1 time=20 a=0x0 b=0x1 cin=0x1 cout=0x0 sum=0x1
monitor: time=20 a=0x1 b=0x1 cin=0x1 cout=0x1 sum=0x0
display: i=2 time=30 a=0x1 b=0x1 cin=0x1 cout=0x1 sum=0x0
monitor: time=30 a=0x1 b=0x0 cin=0x1 cout=0x0 sum=0x1
display: i=3 time=40 a=0x1 b=0x0 cin=0x1 cout=0x0 sum=0x1
display: i=4 time=50 a=0x1 b=0x0 cin=0x1 cout=0x0 sum=0x1
*/

//output: (if in tb code #10 $display("display: i=%0d time=%0t a=0x%0h b=0x%0h cin=0x%0h cout=0x%0h sum=0x%0h", i, $time, a, b, cin, cout, sum );)
/*
Half adder instantiation
monitor: time=0 a=0x0 b=0x0 cin=0x0 cout=0x0 sum=0x0
monitor: time=10 a=0x0 b=0x1 cin=0x1 cout=0x0 sum=0x1
display: i=0 time=20 a=0x0 b=0x1 cin=0x1 cout=0x0 sum=0x1
monitor: time=30 a=0x1 b=0x1 cin=0x1 cout=0x1 sum=0x0
display: i=1 time=40 a=0x1 b=0x1 cin=0x1 cout=0x1 sum=0x0
monitor: time=50 a=0x1 b=0x0 cin=0x1 cout=0x0 sum=0x1
display: i=2 time=60 a=0x1 b=0x0 cin=0x1 cout=0x0 sum=0x1
display: i=3 time=80 a=0x1 b=0x0 cin=0x1 cout=0x0 sum=0x1
display: i=4 time=100 a=0x1 b=0x0 cin=0x1 cout=0x0 sum=0x1
*/