//Digital blocks typically communicate with each other using bus protocols, 
//a few examples of which includes AMBA AXI, WishBone, OCP, etc

//Bus masters that send out data adhering to a certain protocol provide control signals that tell the slave when the packet is valid,
//and whether it is a read or write, and how many bytes of data is sent.

//The master also sends out an address followed by the data to be stored at that address.

// Burst [ 0 -> 1 byte, 1 -> 2 bytes, 2 -> 3 bytes, 3 -> 4 bytes]
// Length -> max 8 transactions per burst
// Protocol expects to send only first addr, and slave should calculate all
// other addresses from burst and length properties

class BusTransaction;
  rand int 			m_addr;
  rand bit [31:0]	m_data;
  rand bit [1:0] 	m_burst; 	// Size of a single transaction in bytes (4 bytes max)
  rand bit [2:0] 	m_length; 	// Total number of transactions

  constraint c_addr { m_addr % 4 == 0; } // Always aligned to 4-byte boundary

  function void display(int idx = 0);
    $display ("------ Transaction %0d------", idx);
    $display (" Addr 	= 0x%0h", m_addr);
    $display (" Data 	= 0x%0h", m_data);
    $display (" Burst 	= %0d bytes/xfr", m_burst + 1);
    $display (" Length  = %0d", m_length + 1);
  endfunction
endclass

module tb;
  int 				slave_start;
  int  				slave_end;
  BusTransaction	bt;

  // Assume we are targeting a slave with addr range 0x200 to 0x800
  initial begin
  	slave_start = 32'h200;
    slave_end 	= 32'h800;
    bt = new;

    bt.randomize() with { m_addr >= slave_start;
                          m_addr < slave_end;
                         (m_burst + 1) * (m_length + 1) + m_addr < slave_end;
                        };
    bt.display();
  end
endmodule
//output
/*
# KERNEL: ------ Transaction 0------
# KERNEL:  Addr 	= 0x4cc
# KERNEL:  Data 	= 0x75928987
# KERNEL:  Burst 	= 2 bytes/xfr
# KERNEL:  Length  = 3
*/