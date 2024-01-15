`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module pc_svamod
  (
   input logic 	      clk,
   input logic 	      rst_n,
   input logic [1:0]  ps_in,
   input logic [15:0] ia_in,
   input logic [15:0] ra_in, 
   input logic [15:0] pc_out,
   input logic [15:0] pc_r         
   );
   
   `xcheck(ps_in);
   `xcheck(ia_in);
   `xcheck(ra_in);
   `xcheck(pc_out);
   `xcheck(pc_r);   
   `resetcheck(pc_r, 0);

   property f_pc_nop;
     @(posedge clk ) disable iff (rst_n == '0)
       (ps_in == 2'b00) |=> (pc_out == $past(pc_out));
   endproperty

   af_pc_nop: assert property(f_pc_nop) else $error("Program counter changed changed when ps_in == PC_NOP");
   cf_pc_nop: cover property(f_pc_nop);

   property f_pc_inc;
     @(posedge clk ) disable iff (rst_n == '0)
       (ps_in == 2'b01) |=> (pc_out == ($past(pc_out) + 16'b00000000_00000001));
   endproperty

   af_pc_inc: assert property(f_pc_inc) else $error("Program counter was not incremented correctly when ps_in == PC_INC");
   cf_pc_inc: cover property(f_pc_inc);

   property f_pc_bra;
     @(posedge clk ) disable iff (rst_n == '0)
       (ps_in == 2'b10) |=> (pc_out == ($past(pc_out) + $signed($past(ia_in))));
   endproperty

   af_pc_bra: assert property(f_pc_bra) else $error("Program counter was not adjusted correctly when ps_in == PC_BRA");
   cf_pc_bra: cover property(f_pc_bra);

   property f_pc_jmp;
      @(posedge clk ) disable iff (rst_n == '0)
	(ps_in == 2'b11) |=> (pc_out == $past(ra_in));
   endproperty

   af_pc_jmp: assert property(f_pc_jmp) else $error("Program counter was not set correctly when ps_in == PC_JMP");
   cf_pc_jmp: cover property(f_pc_jmp);
   
endmodule


`endif
