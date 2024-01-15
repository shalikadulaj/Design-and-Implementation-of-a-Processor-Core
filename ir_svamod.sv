`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module ir_svamod
  (
   input logic 	      clk,
   input logic 	      rst_n,
   input logic 	      il_in,
   input logic [15:0] ins_in,
   input logic [15:0] ins_out,
   input logic [15:0] ia_out,
   input logic [15:0] iv_out,
   input logic [15:0] ir_r     
   );

   `xcheck(il_in);
   `xcheck(ins_in);
   `xcheck(ins_out);
   `xcheck(ia_out);
   `xcheck(iv_out);
   `xcheck(ir_r);               
   `resetcheck(ir_r, 0);

   property f_ins_load;
     @(posedge clk ) disable iff (rst_n == '0)
       il_in |=> (ins_out == $past(ins_in));
   endproperty

   af_ins_load: assert property(f_ins_load) else $error("ins_out does not show ins_in after il_in == '1");
   cf_ins_load: cover property(f_ins_load);
   
   property f_iv_out;
     @(posedge clk ) disable iff (rst_n == '0)
       iv_out == { 13'b0000000000000, ins_out[2:0] };
   endproperty

   af_iv_out: assert property(f_iv_out) else $error("iv_out value incorrect.");
   cf_iv_out: cover property(f_iv_out);

   property f_ia_out;
     @(posedge clk ) disable iff (rst_n == '0)
       ia_out == { {10{ins_out[8]}} , ins_out[8:6], ins_out[2:0] };
   endproperty

   af_ia_out: assert property(f_ia_out) else $error("ia_out value incorrect.");
   cf_ia_out: cover property(f_ia_out);
   
   covergroup cg_iv @(posedge clk iff il_in);
      coverpoint ins_in[2:0]
	{ 
	 bins iv[] = { [0:7] };
      }
   endgroup
   cg_iv cg_iv_inst = new; 
   
   covergroup cg_ia @(posedge clk iff il_in);
      coverpoint { ins_in[8:6], ins_in[2:0] }
	{ 
	 bins ia[] = { [0:63] };
      }
   endgroup
   cg_ia cg_ia_inst = new; 

   covergroup cg_opcode @(posedge clk iff il_in);
      coverpoint ins_in[15:9]
	{ 
	 bins opcodes[] = {MOVA, INC, ADD, MUL, SRA, SUB, DEC, SLA, AND, OR, XOR, NOT, MOVB, SHR, SHL, CLR, LDI, ADI, LD, ST, BRZ, BRN, JMP, HAL, XXL};
      }
   endgroup
   cg_opcode cg_opcode_inst = new;    
 
endmodule


`endif
