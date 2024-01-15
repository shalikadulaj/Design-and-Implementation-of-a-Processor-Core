`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module rb_tb;
   logic 		 clk;
   logic 		 rst_n;
   logic [15:0] 	 d_in;
   logic 		 rw_in;
   logic [11:0] 	 rs_in;
   logic [15:0] 	 a_out;
   logic [15:0] 	 b_out;
   
   rb DUT (.*);
   rb_test TEST (.*);

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
