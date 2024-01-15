`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module cu_svamod
  (
   input logic 		clk,
   input logic 		rst_n,
   input logic [15:0] ins_in,
   input logic 		z_in,
   input logic 		n_in,
   input logic 		il_out,
   input logic [1:0] 	ps_out,
   input logic 		rw_out,
   input logic [11:0] 	rs_out,
   input logic 		mm_out,
   input logic [1:0] 	md_out,
   input logic 		mb_out,
   input logic [3:0] 	fs_out,
   input logic 		wen_out,
   input logic 		iom_out,   
   input cu_state_t     st_r,
   input cu_state_t     ns   
   );

   `xcheck(ins_in);
   `xcheck(z_in);
   `xcheck(n_in);
   `xcheck(il_out);
   `xcheck(ps_out);
   `xcheck(rw_out);
   `xcheck(rs_out);
   `xcheck(mm_out);
   `xcheck(md_out);
   `xcheck(mb_out);
   `xcheck(fs_out);
   `xcheck(wen_out);
   `xcheck(iom_out);
   `xcheck(st_r);
   `xcheck(ns);
   `resetcheck(st_r, RST);

   //////////////////////////////////////////////////////////////////   
   // Blackbox assertions
   //////////////////////////////////////////////////////////////////   

   property f_il_fall;
     @(posedge clk ) disable iff (rst_n == '0)
       il_out |=> !il_out;
   endproperty

   af_il_fall: assert property(f_il_fall) else $error("il_out in state '1 for two clock cycles.");
   cf_il_fall: cover property(f_il_fall);

   property f_il_rise;
     @(posedge clk ) disable iff (rst_n == '0)
       il_out ##1 (!il_out && opcode_t'(ins_in[15:9]) inside { MOVA, INC , ADD , MUL , SRA , SUB , DEC , SLA , AND , OR  , XOR , NOT , 
							       MOVB, SHR , SHL , CLR , LDI , ADI , LD  , ST  , BRZ , BRN , JMP , IOR }) |=> il_out;
   endproperty

   af_il_rise: assert property(f_il_rise) else $error("il_out did not rise in two clock cycles.");
   cf_il_rise: cover property(f_il_rise);

   //////////////////////////////////////////////////////////////////   
   // Whitebox assertions
   //////////////////////////////////////////////////////////////////   
   
   property r_start;
     @(posedge clk ) disable iff (rst_n == '0)
       (st_r == RST) |=> (st_r == INF);
   endproperty

   ar_start: assert property(r_start) else $error("st_r did not move to INF after reset.");
   cr_start: cover property(r_start);

   property r_tofetch;
     @(posedge clk ) disable iff (rst_n == '0)
       (st_r == INF) |=> (st_r == EX0);
   endproperty

   ar_tofetch: assert property(r_tofetch) else $error("st_r did not move to EX0 from INF.");
   cr_tofetch: cover property(r_tofetch);

   property r_toinf;
     @(posedge clk ) disable iff (rst_n == '0)
       (st_r == EX0) && (opcode_t'(ins_in[15:9]) inside { MOVA, INC , ADD , MUL , SRA , SUB , DEC , SLA , AND , OR  , XOR , NOT , 
							 MOVB, SHR , SHL , CLR , LDI , ADI , LD  , ST  , BRZ , BRN , JMP , IOR, IOW }) |=> (st_r == INF);
   endproperty

   ar_toinf: assert property(r_toinf) else $error("st_r did not move to EX0 from INF.");
   cr_toinf: cover property(r_toinf);

   property r_tohlt;
     @(posedge clk ) disable iff (rst_n == '0)
       (st_r == EX0) && !(opcode_t'(ins_in[15:9]) inside { MOVA, INC , ADD , MUL , SRA , SUB , DEC , SLA , AND , OR  , XOR , NOT , 
							   MOVB, SHR , SHL , CLR , LDI , ADI , LD  , ST  , BRZ , BRN , JMP , IOR, IOW, XXL } ) |=> (st_r == HLT);
   endproperty

   ar_tohlt: assert property(r_tohlt) else $error("st_r did not move to HLT from EX0 on HAL or illegal instruction.");
   cr_tohlt: cover property(r_tohlt);

   property r_hlt;
     @(posedge clk ) disable iff (rst_n == '0)
       (st_r == HLT) |=> (st_r == HLT);
   endproperty

   ar_hlt: assert property(r_hlt) else $error("st_r did stay in HLT.");
   cr_hlt: cover property(r_hlt);
   
endmodule

`endif
