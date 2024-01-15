`include "mycpu.svh"

`include "mycpu.svh"

`ifndef SYNTHESIS

import mycpu_pkg::*;

program mycpu_test
  
  (
   input logic 	       clk,
   input logic 	       rst_n,
   input logic 	       wen_out,
   input logic [15:0]  a_out, 
   output logic [15:0] d_in,
   input logic [15:0]  d_out,
   input logic 	       iom_out,
   output logic [15:0] io_in
   );

   localparam int 	 MEMORY_SIZE       = 256;    // Size of memory model in test program
   localparam int 	 IOBUFFER_SIZE     = 4;      // I/O buffer size in mycpu_test program
   localparam realtime 	 MEMORY_READ_DELAY = 100.0ps;
   
   /////////////////////////////////////////////////////////////////
   // Include program code from file
   /////////////////////////////////////////////////////////////////

   logic [15:0] 	 code[] = {
`include "input/machinecode.inc"			   
		                  };
				   
   /////////////////////////////////////////////////////////////////   
   // Other variables
   /////////////////////////////////////////////////////////////////
   
   logic [15:0] 	 memory[MEMORY_SIZE];        // CPU's memory
   logic [17:0] 	 in_buffer[IOBUFFER_SIZE];   // Input port buffer
   logic [17:0] 	 out_buffer[IOBUFFER_SIZE];  // Output port buffer
   int 			 in_ptr;                     // Input buffer pointer
   int 			 out_ptr;                    // Output buffer pointer


   ////////////////////////////////////////////////////////////////
   // Clocking block
   ////////////////////////////////////////////////////////////////

   default clocking cb @(posedge clk);
      input 		 wen_out;
      input 		 a_out;
      input 		 d_out;      
      input 		 iom_out;
      output 		 d_in;
      output 		 io_in;
   endclocking
   
   initial
     begin : test_program

	$info("T1: RESET");
	
	////////////////////////////////////////////////////////////////////
	// Initialization
	////////////////////////////////////////////////////////////////////	

	d_in = '0;
	io_in = '0;

	for(int i=0; i < IOBUFFER_SIZE; ++i)
	  in_buffer[i] = mynumber[i];
	
	for(int i=0; i < MEMORY_SIZE; ++i)
	  begin
	     if (i < code.size())
	       memory[i] = code[i];
	     else
	       memory[i] = 16'b00000000_00000000;
	  end
	$display("Info: Code size = %d instructions", code.size());

	////////////////////////////////////////////////////////////////////
	// Wait for reset
	////////////////////////////////////////////////////////////////////	
	
	wait(rst_n);

	$info("T2: PROGRAM EXECUTION");	

	fork

	   ////////////////////////////////////////////////////////////////////
	   // Memory port processes
	   ////////////////////////////////////////////////////////////////////	
	   
	   begin : memory_write_port
	      forever
		begin : memory_write_loop
		   @(posedge clk iff (!wen_out && !iom_out))
		     begin
			if (a_out < MEMORY_SIZE)
			  memory[a_out] = d_out;		  
		     	else
			  begin
//			     $error("Memory bus error (write): a_out %16b > %d", a_out, MEMORY_SIZE);
			  end
		     end
		end : memory_write_loop
	   end : memory_write_port

	   begin : memory_read_port
	      forever
		begin : memory_read_loop
		   if (a_out < MEMORY_SIZE)
		      #(MEMORY_READ_DELAY) d_in = memory[a_out];
		   @(a_out);
		end : memory_read_loop
	   end : memory_read_port
	   
	   ////////////////////////////////////////////////////////////////////
	   // I/O port processes
	   ////////////////////////////////////////////////////////////////////	
	   
	   begin : io_write_port
	      out_ptr = 0;
	      forever
		begin : io_write_loop
		   if (!cb.wen_out && cb.iom_out && cb.a_out == 0)
		     begin
			out_buffer[out_ptr] = cb.d_out;
			$display("I/O write: %16b (%d)", cb.d_out, $signed(cb.d_out));
			if (out_ptr < IOBUFFER_SIZE)
			  out_ptr = out_ptr + 1;
			else
			  out_ptr = 0;
		     end
		   ##1;
		end : io_write_loop
	   end : io_write_port

	   begin : io_read_port
	      in_ptr = 0;
	      forever
		begin : io_read_loop
		   #(MEMORY_READ_DELAY) io_in = in_buffer[in_ptr];
		   @(a_out or iom_out);		   
		end : io_read_loop
	   end : io_read_port
	   
	   begin : io_read_detect
	      in_ptr = 0;
	      forever
		begin : io_read_detect_loop
		   if (cb.iom_out && cb.wen_out && cb.a_out == 0)
		     begin
			$display("I/O read:  %16b (%d)", io_in, $signed(io_in));
			if (in_ptr < IOBUFFER_SIZE-1)
			  in_ptr = in_ptr + 1;
			else
			  in_ptr = 0;
		     end
		   ##1;
		end : io_read_detect_loop
	   end : io_read_detect

	join

     end : test_program

   final
     begin
	int file;
	file = $fopen("reports/mycpu_memory.txt", "w");
	for(int i=0; i < MEMORY_SIZE; ++i)
	  begin
	     $fdisplay(file, "%4d: %16b %6d", i, memory[i], $signed(memory[i]));
	  end
	$fclose(file);
     end

endprogram
   
`endif
