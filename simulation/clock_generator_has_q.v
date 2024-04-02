//Simulations are required to operate on a given timescale that has a limited precision as specified by the timescale directive.
//it is important that the precision of timescale is good enough to represent a clock period.
//For example, if the frequency of the clock is set to 640000 kHz, then its clock period will be 1.5625 ns for which a timescale precision of 1ps will not suffice because there is an extra point to be represented.
//Hence simulation will round off the last digit to fit into the 3 point timescale precision. This will bump up the clock period to 1.563 which actually represents 639795 kHz !

//The following Verilog clock generator module has three parameters to tweak the three different properties as discussed above.(Period, duty cycle, phase) 
//The module has an input enable that allows the clock to be disabled and enabled as required. 
//When multiple clocks are controlled by a common enable signal, they can be relatively phased easily.

`timescale 1ns/1ps

module clock_gen (	input      enable,
  					output reg clk);

  parameter FREQ = 100000;  // in kHZ
  parameter PHASE = 0; 		// in degrees
  parameter DUTY = 50;  	// in percentage

  real clk_pd  		= 1.0/(FREQ * 1e3) * 1e9; 	// convert to ns
  real clk_on  		= DUTY/100.0 * clk_pd;
  real clk_off 		= (100.0 - DUTY)/100.0 * clk_pd;
  real quarter 		= clk_pd/4;
  real start_dly     = quarter * PHASE/90;

  reg start_clk;

  initial begin
    $display("FREQ      = %0d kHz", FREQ);
    $display("PHASE     = %0d deg", PHASE);
    $display("DUTY      = %0d %%",  DUTY);

    $display("PERIOD    = %0.3f ns", clk_pd);
    $display("CLK_ON    = %0.3f ns", clk_on);
    $display("CLK_OFF   = %0.3f ns", clk_off);
    $display("QUARTER   = %0.3f ns", quarter);
    $display("START_DLY = %0.3f ns", start_dly);
  end

  // Initialize variables to zero
  initial begin
    clk <= 0;
    start_clk <= 0;
  end

  // When clock is enabled, delay driving the clock to one in order
  // to achieve the phase effect. start_dly is configured to the
  // correct delay for the configured phase. When enable is 0,
  // allow enough time to complete the current clock period
  always @ (posedge enable or negedge enable) begin
    if (enable) begin
      #(start_dly) start_clk = 1;
    end else begin
      #(start_dly) start_clk = 0;
    end
  end

  // Achieve duty cycle by a skewed clock on/off time and let this
  // run as long as the clocks are turned on.
  always @(posedge start_clk) begin
    if (start_clk) begin
      	clk = 1;

      	while (start_clk) begin
      		#(clk_on)  clk = 0;
    		#(clk_off) clk = 1;
        end

        //question here, even if start_clk set to 0; it has to finish the while block just before start_clk = 1
        //so for example when enable = 0 at 100ns
        //start_clk = 0 imediately at 100ns
        //but previous condition check start_clk is 1
        //so if will advance clk_on with clk = 1
        // then clk = 0
        // then advance clk_off with clk = 0
        // then clk = 1, at this time, realtime maybe 150ns
        // at 150ns, check while conditon, start_clk already = 0 since 100ns
        // so exit while loop and then clk set 0 at 150ns
        // so we have clk = 1 and clk = 0 both at 150 ns
        // since clk = 0 is last statement, it will take effect
        // so no matter enable = 0 occure at what time and start_clk = 0 at what time
        // clk will always finish clk = 0 with time duration clk_off in previous while loop
        // then at last clk will become to 0, and we will always have full clk_on durantion with clk = 1

        // so start_dly does not matter since it will not truncate the clk_on (clk = 1) and clk_off (clk = 0) duration

      	clk = 0;
    end
  end
endmodule


//========Testbench with different clock frequencies

module tb;
  wire clk1;
  wire clk2;
  wire clk3;
  wire clk4;
  reg  enable;
  reg [7:0] dly;

  clock_gen u0(enable, clk1);
  clock_gen #(.FREQ(200000)) u1(enable, clk2);
  clock_gen #(.FREQ(400000)) u2(enable, clk3);
  clock_gen #(.FREQ(800000)) u3(enable, clk4);

  initial begin
    enable <= 0;

    for (integer i = 0; i < 10; i= i+1) begin
      dly = $random;
      #(dly) enable <= ~enable;
      $display("i=%0d dly=%0d", i, dly);
      #50;
    end

    #50 $finish;
  end
endmodule


//Testbench with different clock phases

module tb;
  wire clk1;
  wire clk2;
  reg  enable;
  reg [7:0] dly;

  clock_gen u0(enable, clk1);
  clock_gen #(.FREQ(50000), .PHASE(90)) u1(enable, clk2);

  initial begin
    enable <= 0;

    for (int i = 0; i < 10; i=i+1) begin
      dly = $random;
      #(dly) enable <= ~enable;
      $display("i=%0d dly=%0d", i, dly);
    end

    #50 $finish;
  end

endmodule


//Testbench with different duty cycles

module tb;
  wire clk1;
  wire clk2;
  wire clk3;
  wire clk4;
  reg  enable;
  reg [7:0] dly;

  clock_gen u0(enable, clk1);
  clock_gen #(.DUTY(25)) u1(enable, clk2);
  clock_gen #(.DUTY(75)) u2(enable, clk3);
  clock_gen #(.DUTY(90)) u3(enable, clk4);

  initial begin
    enable <= 0;

    for (int i = 0; i < 10; i= i+1) begin
      dly = $random;
      #(dly) enable <= ~enable;
      $display("i=%0d dly=%0d", i, dly);
      #50;
    end

    #50 $finish;
  end
endmodule