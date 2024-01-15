`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module mux_3x16_svamod
  (
   input logic 		clk,
   input logic 		rst_n,
   input logic [1:0] 	sel_in,
   input logic [15:0] d0_in,
   input logic [15:0] d1_in,
   input logic [15:0] d2_in, 
   input logic [15:0] m_out
   );
   
   `xcheck(sel_in);
   `xcheck(d0_in);
   `xcheck(d1_in);
   `xcheck(d2_in);
   `xcheck(m_out);
   
endmodule

`endif
