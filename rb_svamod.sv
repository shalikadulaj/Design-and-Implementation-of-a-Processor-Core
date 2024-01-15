`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module rb_svamod
  (
   input logic 		   clk,
   input logic 		   rst_n,
   input logic [15:0] 	   d_in,
   input logic 		   rw_in,
   input logic [11:0] 	   rs_in,
   input logic [15:0] 	   a_out,
   input logic [15:0] 	   b_out,
   input logic [15:0][15:0] rb_r

   );

   `xcheck(d_in);
   `xcheck(rw_in);
   `xcheck(rs_in);      
   `xcheck(a_out);
   `xcheck(b_out);
   `xcheck(rb_r);            
   `resetcheck(rb_r, 0);
   
endmodule

`endif
