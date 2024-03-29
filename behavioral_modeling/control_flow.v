// if-else-if

/*
// if statement without else part
if (expression)
	[statement]

// if statment with an else part
if (expression)
	[statement]
else
	[statement]

// if else for multiple statements should be
// enclosed within "begin" and "end"
if (expression) begin
	[multiple statements]
end else begin
	[multiple statements]
end

// if-else-if statement
if (expression)
	[statement]
else if (expression)
	[statement]
else
	[statement]
*/

//forever loop
/*
forever
	[statement]

forever begin
	[multiple statements]
end
*/


module my_design1;
	initial begin
		forever begin
			$display ("This will be printed forever, simulation can hang ...");
		end
	end
endmodule


//repeat loop
//This will execute statements a fixed number of times. 
//If the expression evaluates to an X or Z, then it will be treated as zero and will not be executed at all.

/*
repeat ([num_of_times]) begin
	[statements]
end

repeat ([num_of_times]) @ ([some_event]) begin
	[statements]
end
*/
module my_design2;
	initial begin
		repeat(4) begin
			$display("This is a new iteration ...");
		end
	end
endmodule

/*
repeat (2) @ (posedge clk);
    rstn <= 1; // rstn will set to 1 right at the 2nd posedge
*/

//while loop
//If the condition is false from the start, statements will not be executed at all.
/*
while (expression) begin
	[statements]
end
*/

module my_design3;
  	integer i = 5;

	initial begin
      while (i > 0) begin
        $display ("Iteration#%0d", i);
        i = i - 1;
      end
	end
endmodule

//for loop
/*
for ( initial_assignment; condition; increment_variable) begin
	[statements]
end
*/

module my_design4;
  	integer i = 5;

	initial begin
      for (i = 0; i < 5; i = i + 1) begin
        $display ("Loop #%0d", i);
      end
    end
endmodule

//conditional operator
/*
<variable> = <condition> ? <expression_1> : <expression_2>;
*/

//case statement
//The expression is evaluated, and based on its value, the corresponding statement is executed. 
//If none of the values match the expression, the statement under default is executed.
//Execution will exit the case block without doing anything if none of the items match the expression and a default statement is not given.
/*
case (<expression>)
	case_item1 : 	<single statement>
	case_item2,
	case_item3 : 	<single statement>
	case_item4 : 	begin
	          			<multiple statements>
	        			end
	default 	 : <statement>
endcase
*/
