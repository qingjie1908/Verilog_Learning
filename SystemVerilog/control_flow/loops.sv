//forever

//Syntax
/*
forever
	// Single statement

forever begin
	// Multiple statements
end
*/

//An always or forever block without a delay element will hang in simulation !

//an always block cannot be placed inside classes and other SystemVerilog procedural blocks. 
//Instead we can use a forever loop to achieve the same effect.

//while, do while
/*
while (<condition>) begin
	// Multiple statements
end

do begin
	// Multiple statements
end while (<condition>);
*/

//foreach
/*
foreach(<variable>[<iterator>])
	// Single statement

foreach(<variable>[<iterator>]) begin
	// Multiple statements
end
*/

//for
/*
for ( [initialization]; <condition>; [modifier])
	// Single statement

for ( [initialization]; <condition>; [modifier]) begin
	// Multiple statements
end
*/

//repeat
/*
repeat (<number>)
	// Single Statement

repeat (<number>) begin
	// Multiple Statements
end
*/



