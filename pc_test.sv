`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

program pc_test
  (
   input logic 		 clk,
   input logic 		 rst_n,

   output logic [1:0] 	 ps_in,
   output logic [15:0] ia_in,
   output logic [15:0] ra_in,
 
   input logic [15:0]  pc_out      
   );

   initial
     begin


	///////////////////////////////////////////////////////////////////////
	$info("T1: Reset Test");
	///////////////////////////////////////////////////////////////////////	
	ps_in = '0;
	ia_in = 16'b00000000_00000000;
	ra_in = 16'b00000000_00000000;
	wait (rst_n);
	@(negedge clk);


	///////////////////////////////////////////////////////////////////////	
	$info("T2: Load test");
	///////////////////////////////////////////////////////////////////////	
	ps_in = 2'b11;
	ia_in = 16'b11111111_11111111;
	ra_in = 16'b11111111_11111111;
	@(posedge clk);
	assert (ra_in == pc_out) else $error("Load test: %16b != %16b", ra_in, pc_out);
	@(negedge clk);

	///////////////////////////////////////////////////////////////////////	
	$info("T3: No change Test");
	///////////////////////////////////////////////////////////////////////	
	ps_in = 2'b00;
	ia_in = 16'b11111111_11111111;
	ra_in = 16'b11111111_11111111;
	@(posedge clk);
	assert (pc_out == 16'b00000000_00000000) else $error("No change Test- %16b should not change the value", pc_out);
	@(negedge clk);


	///////////////////////////////////////////////////////////////////////	
	$info("T4:  Counter incremented by one Test");
	///////////////////////////////////////////////////////////////////////		
	ps_in = 2'b01;
	ia_in = 16'b00000000_00000000;
	ra_in = 16'b00000000_00000000;
	@(posedge clk);
	assert (pc_out == 16'b00000000_00000001) else $error("Counter incremented by one Test - should increase by one");
	@(negedge clk);
	
	@(posedge clk);
	assert (pc_out == 16'b00000000_00000010) else $error("Counter incremented by one Test - should increse by one");
	@(negedge clk);

	///////////////////////////////////////////////////////////////////////		
	$info("T5: add from ia_in test");	
	///////////////////////////////////////////////////////////////////////
	ps_in = 2'b10;
	for (int i=5; i > -5; i--)
	  begin
	     logic signed [15:0] tmp_ia, tmp_pcout;
	     tmp_ia = i;
	     tmp_pcout = pc_out;
	     ia_in = unsigned'(tmp_ia);
	     @(posedge clk);
	     assert( pc_out == unsigned'(signed'(tmp_pcout) + signed'(ia_in))) 
	       else $error("pc_out value %16b wrong %16b", pc_out, ia_in);
	     @(negedge clk);
	  end

	///////////////////////////////////////////////////////////////////////	
	$info("T6: Jump address loaded from ra_in test");		
	/////////////////////////////////////////////////////////////////////// 	
	for (int i=0; i < 63; ++i)
	  begin
	     ps_in = 2'b11;
	     ra_in = i;	     
	     @(posedge clk);
	     assert( pc_out == ra_in ) 
	       else $error("pc_out value %16b wrong %16b", pc_out, ra_in);
	     @(negedge clk);
	  end

	
	$finish;	
     end   
   
endprogram


`endif
