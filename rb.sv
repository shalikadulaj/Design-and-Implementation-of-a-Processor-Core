`include "mycpu.svh"

import mycpu_pkg::*;

module rb
  (
   input logic 	       clk,
   input logic 	       rst_n,
   input logic [15:0]  d_in,
   input logic 	       rw_in,
   input logic [11:0]   rs_in,
   output logic [15:0] a_out,
   output logic [15:0] b_out
   );

logic [15:0][15:0] rb_r;
always_ff @(posedge clk or negedge rst_n)
	begin : rb_regs

	  if(rst_n == '0)
	    begin
		rb_r<='0;
	    end
	  

	else
	    begin
		if(rw_in=='1)
			rb_r[rs_in[11:8]]<=d_in;		
	    end
end : rb_regs



always_comb
	begin : amux_logic
		
			a_out=rb_r[rs_in[7:4]];
		
	end : amux_logic



always_comb
	begin : bmux_logic
		
		b_out=rb_r[rs_in[3:0]];
		
	end : bmux_logic


endmodule

