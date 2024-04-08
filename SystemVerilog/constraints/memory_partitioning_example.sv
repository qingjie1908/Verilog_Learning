//====Memory block randomization

//Assume we have a 2KB SRAM in the design intended to store some data.
//Start address 0x0
//Stop address 0x7FF
//each address store 1 byte data, 0x7FF = 2047, total 2KB data

class MemoryBlock;

  bit [31:0] 		m_ram_start; 			// Start address of RAM
  bit [31:0] 		m_ram_end; 				// End address of RAM

  rand bit [31:0] 	m_start_addr; 			// Pointer to start address of block
  rand bit [31:0]   m_end_addr; 			// Pointer to last addr of block
  rand int 			m_block_size; 			// Block size in Byte

  constraint c_addr { m_start_addr >= m_ram_start; 	// Block addr should be more than RAM start
                      m_start_addr < m_ram_end; 	// Block addr should be less than RAM end
                      m_start_addr % 4 == 0;  		// Block addr should be aligned to 4-byte boundary
                      m_end_addr == m_start_addr + m_block_size - 1; };

  constraint c_blk_size { m_block_size inside {64, 128, 512 }; }; 	// Block's size should be either 64/128/512 bytes

  function void display();
    $display ("------ Memory Block --------");
    $display ("RAM StartAddr   = 0x%0h", m_ram_start);
    $display ("RAM EndAddr     = 0x%0h", m_ram_end);
	$display ("Block StartAddr = 0x%0h", m_start_addr);
    $display ("Block EndAddr   = 0x%0h", m_end_addr);
    $display ("Block Size      = %0d bytes", m_block_size);
  endfunction
endclass

module tb;
  initial begin
    MemoryBlock mb = new;
    mb.m_ram_start = 32'h0;
    mb.m_ram_end   = 32'h7FF; 		// 2KB RAM
    mb.randomize();
    mb.display();
  end
endmodule
//output
/*
# KERNEL: ------ Memory Block --------
# KERNEL: RAM StartAddr   = 0x0
# KERNEL: RAM EndAddr     = 0x7ff
# KERNEL: Block StartAddr = 0x1cc
# KERNEL: Block EndAddr   = 0x20b
# KERNEL: Block Size      = 64 bytes
*/


//====Equal partitions of memory

//In this example, we'll try to partition the 2KB SRAM into N partitions 
//with each parititon having equal size.