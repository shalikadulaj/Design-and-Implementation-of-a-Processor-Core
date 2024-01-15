`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module cu_tb;
   logic 		 clk;
   logic 		 rst_n;
   logic [15:0] 	 ins_in;
   logic 		 z_in;
   logic 		 n_in;
   logic 		 il_out;
   logic [1:0] 		 ps_out;
   logic 		 rw_out;
   logic [11:0] 	 rs_out;
   logic 		 mm_out;
   logic [1:0] 		 md_out;
   logic 		 mb_out;
   logic [3:0] 		 fs_out;
   logic 		 wen_out;
   logic 		 iom_out;
     
   cu DUT (.*);
   cu_test TEST (.*);

   always
     begin : clock_generator
	if (clk === '0)
	  clk = '1;
	else
	  clk = '0;
	#CLK_PERIOD;
     end : clock_generator

`ifdef RTL_SIM
 `include "mycpu_svabind.svh"   
`endif 
   
   
endmodule

`endif
