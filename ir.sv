`include "mycpu.svh"

import mycpu_pkg::*;

module ir
  (
   input logic 	       clk,
   input logic 	       rst_n,
   input logic 	       il_in,
   input logic [15:0]  ins_in,
   output logic [15:0] ins_out,
   output logic [15:0] ia_out,
   output logic [15:0] iv_out   
   );
   
   
	logic [15:0] ir_r;
	logic signed [15:0] ia;
	logic unsigned [15:0] iv;

	


	always_ff @(posedge clk or negedge rst_n)
		begin : ir_regs
		  if(rst_n == '0)
		    begin
			ir_r <= '0;
		    end
		  else
		    begin
			if(il_in == '1)
				ir_r <= ins_in;
		    end
		end : ir_regs
		

	always_comb
		begin : ia_logic
	       logic [5:0] concatenated_value;
	      logic signed [5:0] signed_value;
	      concatenated_value = {ir_r[8:6], ir_r[2:0]};
	      signed_value = $signed(concatenated_value);
	      ia = {{10{signed_value[5]}}, signed_value};
		end : ia_logic



	
	always_comb
		begin : iv_logic
	      reg [2:0] unsigned_value;
	      unsigned_value = ir_r[2:0];
	      iv = {{13'b0, unsigned_value}};
		end : iv_logic

	// ins_out driver
	assign ins_out = ir_r;
	// ia_out driver
	assign ia_out = $unsigned(ia);
	// iv_driver
	assign iv_out = iv;
		


endmodule


