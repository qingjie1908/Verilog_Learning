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
class MemoryBlock;

  bit [31:0] 		m_ram_start; 			// Start address of RAM
  bit [31:0] 		m_ram_end; 				// End address of RAM

  rand int			m_num_part; 			// Number of partitions
  rand bit [31:0] 	m_part_start []; 		// Partition start array
  rand int 			m_part_size; 		 	// Size of each partition
  rand int			m_tmp;

  // Constrain number of partitions RAM has to be divided into
  constraint c_parts { m_num_part > 4; m_num_part < 10; }

  // Constraint size of each partition
  constraint c_size { m_part_size == (m_ram_end - m_ram_start)/m_num_part; }

  // Constrain start addr of each partition
  constraint c_part { m_part_start.size() == m_num_part;
                      foreach (m_part_start[i]) {
                        if (i)
                          m_part_start[i] == m_part_start[i-1] + m_part_size;
                        else
                          m_part_start[i] == m_ram_start;
                      }
                    }

  function void display();
    $display ("------ Memory Block --------");
    $display ("RAM StartAddr   = 0x%0h", m_ram_start);
    $display ("RAM EndAddr     = 0x%0h", m_ram_end);
    $display ("# Partitions = %0d", m_num_part);
    $display ("Partition Size = %0d bytes", m_part_size);
    $display ("------ Partitions --------");
    foreach (m_part_start[i])
      $display ("Partition %0d start = 0x%0h", i, m_part_start[i]);
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
# KERNEL: # Partitions = 7
# KERNEL: Partition Size = 292 bytes
# KERNEL: ------ Partitions --------
# KERNEL: Partition 0 start = 0x0
# KERNEL: Partition 1 start = 0x124
# KERNEL: Partition 2 start = 0x248
# KERNEL: Partition 3 start = 0x36c
# KERNEL: Partition 4 start = 0x490
# KERNEL: Partition 5 start = 0x5b4
# KERNEL: Partition 6 start = 0x6d8
*/

//====Variable memory partitions
class MemoryBlock;

  bit [31:0] 		m_ram_start; 			// Start address of RAM
  bit [31:0] 		m_ram_end; 				// End address of RAM

  rand int			m_num_part; 			// Number of partitions
  rand bit [31:0] 	m_part_start []; 		// Partition start array
  rand int 			m_part_size [];		 	// Size of each partition
  rand int			m_tmp;

  // Constrain number of partitions RAM has to be divided into
  constraint c_parts { m_num_part > 4; m_num_part < 10; }

  // Constraint size of each partition
  constraint c_size { m_part_size.size() == m_num_part;
                     m_part_size.sum() == m_ram_end - m_ram_start + 1;
                     foreach (m_part_size[i])
                       m_part_size[i] inside {16, 32, 64, 128, 512, 1024};
                    }

  // Constrain start addr of each partition
  constraint c_part { m_part_start.size() == m_num_part;
                      foreach (m_part_start[i]) {
                        if (i)
                          m_part_start[i] == m_part_start[i-1] + m_part_size[i-1];
                        else
                          m_part_start[i] == m_ram_start;
                      }
                    }

  function void display();
    $display ("------ Memory Block --------");
    $display ("RAM StartAddr   = 0x%0h", m_ram_start);
    $display ("RAM EndAddr     = 0x%0h", m_ram_end);
    $display ("# Partitions = %0d", m_num_part);
    $display ("------ Partitions --------");
    foreach (m_part_start[i])
      $display ("Partition %0d start = 0x%0h, size = %0d bytes", i, m_part_start[i], m_part_size[i]);
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
# KERNEL: # Partitions = 7
# KERNEL: ------ Partitions --------
# KERNEL: Partition 0 start = 0x0, size = 128 bytes
# KERNEL: Partition 1 start = 0x80, size = 128 bytes
# KERNEL: Partition 2 start = 0x100, size = 512 bytes
# KERNEL: Partition 3 start = 0x300, size = 64 bytes
# KERNEL: Partition 4 start = 0x340, size = 1024 bytes
# KERNEL: Partition 5 start = 0x740, size = 128 bytes
# KERNEL: Partition 6 start = 0x7c0, size = 64 bytes
*/

//====Variable memory partitions with space in between
class MemoryBlock;

  bit [31:0] 		m_ram_start; 			// Start address of RAM
  bit [31:0] 		m_ram_end; 				// End address of RAM

  rand int			m_num_part; 			// Number of partitions
  rand bit [31:0] 	m_part_start []; 		// Partition start array
  rand int 			m_part_size [];		 	// Size of each partition
  rand int 			m_space[]; 	 			// Space between each partition
  rand int			m_tmp;

  // Constrain number of partitions RAM has to be divided into
  constraint c_parts { m_num_part > 4; m_num_part < 10; }

  // Constraint size of each partition
  constraint c_size { m_part_size.size() == m_num_part;
                     m_space.size() == m_num_part - 1;
                     m_space.sum() + m_part_size.sum() == m_ram_end - m_ram_start + 1;
                     foreach (m_part_size[i]) {
                       m_part_size[i] inside {16, 32, 64, 128, 512, 1024};
                       if (i < m_space.size())
                       	 m_space[i] inside {0, 16, 32, 64, 128, 512, 1024};
                     }
                    }

  // Constrain start addr of each partition
  constraint c_part { m_part_start.size() == m_num_part;
                      foreach (m_part_start[i]) {
                        if (i)
                          m_part_start[i] == m_part_start[i-1] + m_part_size[i-1] +  m_space[i-1];
                        else
                          m_part_start[i] == m_ram_start;
                      }
                    }

  function void display();
    $display ("------ Memory Block --------");
    $display ("RAM StartAddr   = 0x%0h", m_ram_start);
    $display ("RAM EndAddr     = 0x%0h", m_ram_end);
    $display ("# Partitions = %0d", m_num_part);
    $display ("------ Partitions --------");
    foreach (m_part_start[i])
      $display ("Partition %0d start = 0x%0h, size = %0d bytes, space = %0d bytes", i, m_part_start[i], m_part_size[i], m_space[i]);
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
# KERNEL: # Partitions = 7
# KERNEL: ------ Partitions --------
# KERNEL: Partition 0 start = 0x0, size = 16 bytes, space = 0 bytes
# KERNEL: Partition 1 start = 0x10, size = 32 bytes, space = 1024 bytes
# KERNEL: Partition 2 start = 0x430, size = 16 bytes, space = 16 bytes
# KERNEL: Partition 3 start = 0x450, size = 128 bytes, space = 512 bytes
# KERNEL: Partition 4 start = 0x6d0, size = 128 bytes, space = 32 bytes
# KERNEL: Partition 5 start = 0x770, size = 128 bytes, space = 0 bytes
*/

//====Partition for Programs and Data
//In this example, memory is partitioned into regions for program, data and empty spaces.
//A dynamic array is used to store the size for each program, data and empty space. 
//The code shown below randomizes the total number of programs, data, and space regions.

typedef struct {
  int start_addr;
  int end_addr;
} e_range;

class Space;
  rand int num_pgm;  		// Total number of programs required
  rand int num_data; 		// Total number of data blocks required
  rand int num_space; 		// Total number of empty spaces required

  rand int max_pgm_size; 	// Maximum program size
  rand int max_data_size; 	// Maximum data size

  rand int num_max_pgm; 	// Maximum number of programs

  rand int pgm_size[]; 		// Size of each program region
  rand int data_size[]; 	// Size of each data region
  rand int space_size[]; 	// Size of each empty space region

  int total_ram; 			// Total RAM space

  // Constrain maximum individual program region size to be 512 bytes
  // data region size to be 128 bytes and maximum number of programs in
  // this memory region to be 100
  constraint c_num_size { 	max_pgm_size 	== 512;
                            max_data_size 	== 128;
                         	num_max_pgm 	== 100;
                         }

  // Constrain total number of programs, data and space regions
  constraint c_num { 	num_pgm inside {[1:num_max_pgm]};
                    	num_data inside {[1:50]};
                    	num_space inside {[1:50]};
                   }

  // Constrain the array for program, data and space to equal the number
  // decided by the above constraints.
  constraint c_size { 	pgm_size.size() 	== num_pgm;
                    	data_size.size() 	== num_data;
                     	space_size.size() 	== num_space;
                   }

  // Size of each program/data/space is stored into indices of the corresponding
  // arrays. So, total size of RAM should be the sum of all programs + data + space
  constraint c_ram { foreach (pgm_size[i]) {
//    					pgm_size[i] inside {4, 8, 32, 64, 128, 512};
    					pgm_size[i] dist {[128:512]:/75, [32:64]:/20, [4:8]:/10};
    					pgm_size[i] % 4 == 0;
  					}
    				foreach (data_size[i]) {
                    	data_size[i] inside {64, 128, 512, 1024};
  					}
                      foreach (space_size[i]) {
                        space_size[i] inside {4, 8, 32, 64, 128, 512, 1024};
  					}
                      total_ram == pgm_size.sum() + data_size.sum() + space_size.sum();
                   }

  	// Function to display the partitioning
	function void display();
		$display("#pgms=%0d #data=%0d, #space=%0d", num_pgm, num_data, num_space);
		$display("#pgms.size=%0d #data.size=%0d, #space.size=%0d total=%0d", pgm_size.sum(), data_size.sum(), space_size.sum(), total_ram);
		foreach(pgm_size[i])
        	$display("pgm#%0d size=%0d bytes", i, pgm_size[i]);
		foreach(data_size[i])
            $display("data#%0d size=%0d bytes", i, data_size[i]);
		foreach(space_size[i])
        	$display("space#%0d size=%0d bytes", i, space_size[i]);
    endfunction
endclass

module tb;
  initial begin
    Space sp = new();
    sp.total_ram = 6 * 1024; 	// Assuem total 6KB memory space
    assert(sp.randomize());
    sp.display();
  end
endmodule
//output
/*
# KERNEL: #pgms=39 #data=8, #space=33
# KERNEL: #pgms.size=960 #data.size=960, #space.size=4224 total=6144
# KERNEL: pgm#0 size=4 bytes
# KERNEL: pgm#1 size=4 bytes
# KERNEL: pgm#2 size=4 bytes
# KERNEL: pgm#3 size=4 bytes
# KERNEL: pgm#4 size=4 bytes
# KERNEL: pgm#5 size=4 bytes
# KERNEL: pgm#6 size=4 bytes
# KERNEL: pgm#7 size=4 bytes
# KERNEL: pgm#8 size=4 bytes
# KERNEL: pgm#9 size=4 bytes
# KERNEL: pgm#10 size=4 bytes
# KERNEL: pgm#11 size=4 bytes
# KERNEL: pgm#12 size=4 bytes
# KERNEL: pgm#13 size=4 bytes
# KERNEL: pgm#14 size=4 bytes
# KERNEL: pgm#15 size=4 bytes
# KERNEL: pgm#16 size=4 bytes
# KERNEL: pgm#17 size=4 bytes
# KERNEL: pgm#18 size=4 bytes
# KERNEL: pgm#19 size=132 bytes
# KERNEL: pgm#20 size=4 bytes
# KERNEL: pgm#21 size=4 bytes
# KERNEL: pgm#22 size=4 bytes
# KERNEL: pgm#23 size=4 bytes
# KERNEL: pgm#24 size=4 bytes
# KERNEL: pgm#25 size=4 bytes
# KERNEL: pgm#26 size=4 bytes
# KERNEL: pgm#27 size=4 bytes
# KERNEL: pgm#28 size=4 bytes
# KERNEL: pgm#29 size=4 bytes
# KERNEL: pgm#30 size=56 bytes
# KERNEL: pgm#31 size=36 bytes
# KERNEL: pgm#32 size=4 bytes
# KERNEL: pgm#33 size=260 bytes
# KERNEL: pgm#34 size=172 bytes
# KERNEL: pgm#35 size=4 bytes
# KERNEL: pgm#36 size=64 bytes
# KERNEL: pgm#37 size=52 bytes
# KERNEL: pgm#38 size=64 bytes
# KERNEL: data#0 size=64 bytes
# KERNEL: data#1 size=512 bytes
# KERNEL: data#2 size=64 bytes
# KERNEL: data#3 size=64 bytes
# KERNEL: data#4 size=64 bytes
# KERNEL: data#5 size=64 bytes
# KERNEL: data#6 size=64 bytes
# KERNEL: data#7 size=64 bytes
# KERNEL: space#0 size=4 bytes
# KERNEL: space#1 size=4 bytes
# KERNEL: space#2 size=4 bytes
# KERNEL: space#3 size=4 bytes
# KERNEL: space#4 size=4 bytes
# KERNEL: space#5 size=4 bytes
# KERNEL: space#6 size=64 bytes
# KERNEL: space#7 size=4 bytes
# KERNEL: space#8 size=4 bytes
# KERNEL: space#9 size=4 bytes
# KERNEL: space#10 size=1024 bytes
# KERNEL: space#11 size=4 bytes
# KERNEL: space#12 size=8 bytes
# KERNEL: space#13 size=4 bytes
# KERNEL: space#14 size=4 bytes
# KERNEL: space#15 size=4 bytes
# KERNEL: space#16 size=32 bytes
# KERNEL: space#17 size=512 bytes
# KERNEL: space#18 size=512 bytes
# KERNEL: space#19 size=64 bytes
# KERNEL: space#20 size=32 bytes
# KERNEL: space#21 size=8 bytes
# KERNEL: space#22 size=512 bytes
# KERNEL: space#23 size=4 bytes
# KERNEL: space#24 size=128 bytes
# KERNEL: space#25 size=8 bytes
# KERNEL: space#26 size=1024 bytes
# KERNEL: space#27 size=64 bytes
# KERNEL: space#28 size=4 bytes
# KERNEL: space#29 size=128 bytes
# KERNEL: space#30 size=32 bytes
# KERNEL: space#31 size=4 bytes
# KERNEL: space#32 size=8 bytes
*/