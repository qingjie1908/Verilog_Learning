module fa (
    input a, b, cin,
    output sum, cout
);
    wire s1, net1, net2; ////Output of module has to be of type wire in order to connect with the output port of a primitive.

    xor(s1, a, b);
    and(net1, a, b);

    xor(sum, s1, cin);
    and(net2, s1, cin);

    xor(cout, net1, net2);
    
endmodule

module tb (
);
    reg a, b, cin;
    wire sum, cout;
    integer i;

    fa u0(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        {a, b, cin} <= 0;
        $monitor("[%0t] a=%0b b=%0b cin=%0b sum=%0b cout=%0b", $time, a, b, cin, cout, sum);

        for(i = 0; i < 8; i = i + 1)
            #1 {a, b, cin} <= i;
    end
    
endmodule

//output
/*
[0] a=0 b=0 cin=0 sum=0 cout=0
[2] a=0 b=0 cin=1 sum=0 cout=1
[3] a=0 b=1 cin=0 sum=0 cout=1
[4] a=0 b=1 cin=1 sum=1 cout=0
[5] a=1 b=0 cin=0 sum=0 cout=1
[6] a=1 b=0 cin=1 sum=1 cout=0
[7] a=1 b=1 cin=0 sum=1 cout=0
[8] a=1 b=1 cin=1 sum=1 cout=1
*/