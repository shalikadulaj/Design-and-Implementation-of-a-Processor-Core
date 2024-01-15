`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module pc_tb;

 //////////////////////////////////  

   logic clk;
   logic rst_n;
   logic [1:0] 	 ps_in;
   logic [15:0]  ia_in;
   logic [15:0]  ra_in;
   logic [15:0] pc_out;     
   logic [15:0] pc_r;

 pc DUT (.*);
   pc_test TEST (.*);
   
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




////////////////////////////



`ifdef RTL_SIM
 `include "mycpu_svabind.svh"   
`endif 
   

endmodule

`endif
