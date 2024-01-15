`include "mycpu.svh"

import mycpu_pkg::*;

module mux_2x16
  (input logic sel_in,
   input logic [15:0] d0_in,
   input logic [15:0] d1_in,
   output logic [15:0] m_out);
   

	always_comb
		begin : mux_logic

			if (sel_in=='0)
				m_out=d0_in;
			else
				m_out=d1_in;

		end : mux_logic


endmodule

