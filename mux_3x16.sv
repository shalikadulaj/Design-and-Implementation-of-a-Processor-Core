`include "mycpu.svh"

import mycpu_pkg::*;

module mux_3x16
  (input logic [1:0] sel_in,
   input logic [15:0]  d0_in,
   input logic [15:0]  d1_in,
   input logic [15:0]  d2_in,   
   output logic [15:0] m_out);


	always_comb
		begin : mux_logic
			case(sel_in)
				2'b00:m_out=d0_in;
				2'b01:m_out=d1_in;
				2'b10:m_out=d2_in;
				2'b11:m_out='0;
			endcase
		end : mux_logic
endmodule
