`include "mycpu.svh"

import mycpu_pkg::*;

program rb_test
  (
   input logic 		 clk,
   input logic 		 rst_n,
   output logic [15:0] d_in,
   output logic 	 rw_in,
   output logic [11:0] 	 rs_in,
   input logic [15:0]  a_out,
   input logic [15:0]  b_out
   );

   logic [15:0] 	 patterns [16];
   
 task checkRegisterBank(logic [15:0] dataOut, logic [3:0] addr);
	    if (dataOut == patterns[addr]) 
		begin
		$display("Read-Write Test: Value %16b at address %4b matches the expected value %16b.", dataOut, addr, patterns[addr]);
		end 
	   else 
		begin
		$display("Read-Write Test: Mismatch at address %4b. Read value: %16b, Expected value: %16b.", addr, dataOut, patterns[addr]);
		
        end
endtask
   
 

 initial
     begin
	///////////////////////////////////////////////////////////////////////
	$info("T1: Reset Test");
	///////////////////////////////////////////////////////////////////////	
	d_in = '0;
	rw_in = '0;
	rs_in = '0;
	wait (rst_n);

	///////////////////////////////////////////////////////////////////////	
	$info("T2: Read-Write Test");
	///////////////////////////////////////////////////////////////////////


 

for (int i = 0; i < 16; i++) 
	begin
	   // Write operation
	   @(posedge clk);
	   rw_in = '1;
	   rs_in = {i, 8'b00000000};
	   patterns[i] = $urandom();
	   d_in = patterns[i];
	   @(negedge clk);
	end

for (int i = 0; i < 16; i++) 
	begin
	   // Read operation after the write
	   @(posedge clk);
	   rw_in = '0;
	   rs_in = {4'b0000, i, 4'b0000};
	   #(CLK_PERIOD * 0.5);
	   checkRegisterBank(a_out, i);
	   @(negedge clk);
	end

for (int i = 0; i < 16; i++) 
	begin
	   // Another read operation after the write
	   @(posedge clk);
	   rw_in = '0;
	   rs_in = {8'b00000000, i};
	   #(CLK_PERIOD * 0.5);
	   checkRegisterBank(b_out, i);
	   @(negedge clk);
	end

	     
	$finish;
     end
endprogram
