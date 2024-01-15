`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;


module mux_3x16_tb  #(parameter DUT_VS_REF_SIMULATION = 0);
   logic clk;
   logic rst_n;   
   logic [1:0] sel_in;
   logic [15:0] d0_in;
   logic [15:0] d1_in;
   logic [15:0] d2_in;   
   logic [15:0] m_out;


  mux_3x16 DUT (.*);
   mux_3x16_test TEST (.*);  

   
`ifdef RTL_SIM
 `include "mycpu_svabind.svh"   
`endif 


 always
     begin : clock_generator
	if (clk === '0)
	  clk = '1;
	else
	  clk = '0;
	#CLK_PERIOD;
     end : clock_generator

   initial
     begin : reset_generator
	rst_n = '0;
	@(negedge clk);
	@(negedge clk);
	rst_n = '1;
     end : reset_generator
   
endmodule

`endif      
   
