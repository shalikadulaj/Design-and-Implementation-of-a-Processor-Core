`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module ir_tb;
   logic 		 clk;
   logic 		 rst_n;
   logic 		 il_in;
   logic [15:0] 	 ins_in;
   logic [15:0] 	 ia_out;
   logic [15:0] 	 ins_out;
   logic [15:0] 	 iv_out;
   
   ir DUT (.*);
   ir_test TEST (.*);
   
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

// Assertion module binding file inclusion
`ifdef RTL_SIM
 `include "mycpu_svabind.svh"   
`endif 

endmodule

`endif
