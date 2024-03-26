module full_adder(input a,
                        b,
                        cin,
                output reg cout,
                        sum);
    always @ (a or b or cin) begin // evaluate whenever a or b or cin change
        {cout, sum} = a + b + cin;
    end
endmodule

//test bench for full adder
module tb();
    reg a, b, cin;
    wire cout, sum;
    integer i;

    // instantiation
    full_adder fd0(.a(a), .b(b), .cin(cin), .cout(cout), .sum(sum));

    //initial
    initial begin
        // at begginng of time, initialize all inputs
        a = 0;
        b = 0;
        cin = 0;

        // use a $monitor to print any change in the signal to
        // the simulation console
        $monitor("a=%0b b=%0b cin=%0b cout=%0b sum=%0b", a, b, cin, cout, sum);

        // total 3 inputs, has 8 different input combination has
        for(i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i;
            #10; //with a delay statement of 10 time units so that the new value is applied to the inputs after some time.
        end
    end

endmodule

// output
/*
a=0 b=0 cin=0 cout=0 sum=0
a=0 b=0 cin=1 cout=0 sum=1
a=0 b=1 cin=0 cout=0 sum=1
a=0 b=1 cin=1 cout=1 sum=0
a=1 b=0 cin=0 cout=0 sum=1
a=1 b=0 cin=1 cout=1 sum=0
a=1 b=1 cin=0 cout=1 sum=0
a=1 b=1 cin=1 cout=1 sum=1
*/