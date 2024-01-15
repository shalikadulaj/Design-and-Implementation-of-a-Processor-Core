`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

program ir_test
  (
   input logic 	 clk,
   input logic 	 rst_n,
   output logic 	 il_in,
   output logic [15:0] ins_in,
   input logic [15:0]  ia_out,
   input logic [15:0]  ins_out,
   input logic [15:0]  iv_out   
   );

   initial
     begin

	///////////////////////////////////////////////////////////////////////
	$info("T1: Reset Test");
	///////////////////////////////////////////////////////////////////////	
	il_in = '0;
	ins_in = 16'b00000000_00000000;
	wait (rst_n);
	@(negedge clk);

	///////////////////////////////////////////////////////////////////////	
	$info("T2: Load test");
	///////////////////////////////////////////////////////////////////////	
	il_in = '1;
	ins_in = 16'b11111111_11111111;
	@(posedge clk);
	assert (ins_in == ins_out) else $error("Load test: %16b != %16b", ins_in, ins_out);
	@(negedge clk);

	///////////////////////////////////////////////////////////////////////	
	$info("T3: Hold test");
	///////////////////////////////////////////////////////////////////////		
	il_in = '0;
	ins_in = 16'b00000000_00000000;
	@(posedge clk);
	assert (ins_out == 16'b11111111_11111111) else $error("Hold test: ins_out changed while il_in == '0");
	@(negedge clk);

	///////////////////////////////////////////////////////////////////////		
	$info("T4: Immeadiate value test");	
	///////////////////////////////////////////////////////////////////////
	for (int i=0; i < 8; ++i)
	  begin
	     il_in = '1;
	     ins_in[15:3] = '0;
	     ins_in[2:0] = i;
	     @(posedge clk);
	     assert( iv_out == { 13'b0000000000000, ins_out[2:0] } ) 
	       else $error("iv_out value %16b wrong for ins_out code %16b", iv_out, ins_out);
	     @(negedge clk);
	  end

	///////////////////////////////////////////////////////////////////////	
	$info("T5: Immeadiate address test");		
	/////////////////////////////////////////////////////////////////////// 	
	for (int i=0; i < 63; ++i)
	  begin
	     logic [5:0] ad;
	     ad = i;
	     il_in = '1;
	     ins_in[15:3] = '0;
	     ins_in[8:6] = ad[5:3];
	     ins_in[2:0] = ad[2:0];	     
	     @(posedge clk);
	     assert( { ia_out == {10{ins_out[8]}} , ins_out[8:6], ins_out[2:0] } ) 
	       else $error("ia_out value %16b wrong for ins_out code %16b", ia_out, ins_out);
	     @(negedge clk);
	  end
	
     end

endprogram 
   
`endif
