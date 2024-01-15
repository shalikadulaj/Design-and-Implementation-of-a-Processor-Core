`include "mycpu.svh"

import mycpu_pkg::*;

module pc
  (
   input logic 		 clk,
   input logic 		 rst_n,
   input logic [1:0] 	 ps_in,
   input logic [15:0]  ia_in,
   input logic [15:0]  ra_in, 
   output logic [15:0] pc_out      
   );



logic [15:0] pc_r;


	always_ff @(posedge clk or negedge rst_n)
        
	  begin:pc_regs
     if(rst_n =='0)
      pc_r <= '0;
     else
      begin
	    case (ps_in)

	      2'b00: pc_r <= pc_r;
	      2'b01: pc_r <= pc_r + 1;
	      2'b10: pc_r <= $unsigned ($signed (pc_r) + $signed(ia_in));
              2'b11: pc_r <= ra_in;
       	     default: pc_r <= '0;
           endcase      
      end

	end : pc_regs

	// pc_out driver
	assign pc_out = pc_r;


endmodule 
   
