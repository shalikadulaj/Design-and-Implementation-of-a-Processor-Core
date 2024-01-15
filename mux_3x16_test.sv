`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

program mux_3x16_test
  (
   input logic 	       clk,
   input logic 	       rst_n,
   output logic [1:0]  sel_in,
   output logic [15:0] d0_in,
   output logic [15:0] d1_in,
   output logic [15:0] d2_in, 
   input logic [15:0]  m_out
   );

   /////////////////////////////////////////////////////////////
   // Write a test program below
   /////////////////////////////////////////////////////////////


   initial
     begin : test_program

	////////////////////////////////////////////////////////////////
	// Initialization
	////////////////////////////////////////////////////////////////
	sel_in = '0;
	d0_in = '0;
	d1_in = '0;
	d2_in = '0;

	wait(rst_n);

	////////////////////////////////////////////////////////////////
	// Test loop
	////////////////////////////////////////////////////////////////	

	$info("T1");
	
	repeat (20) begin

	   // Generate random input data
	   @(negedge clk);
	   sel_in = $urandom;
	   d0_in = $urandom;
	   d1_in = $urandom;
	   d2_in = $urandom;

	   // After some time, check that outputs are ok.
	   @(posedge clk);
	   assert (((sel_in == 2'b11) && (m_out=='0)) || ((sel_in == 2'b10) && (d2_in == m_out)) || ((sel_in == 2'b01) && (d1_in == m_out)) || ((sel_in == 2'b00) && (d0_in == m_out)))
	     else $error("mux_3x16 output value is wrong!");
	end // repeat (20)
	
	$finish;

     end : test_program
   
////////////////////////////////////////////////////////////////////////////////////////////

endprogram

`endif
