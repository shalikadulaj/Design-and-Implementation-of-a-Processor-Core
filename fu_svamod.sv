`ifndef SYNTHESIS

`include "mycpu.svh"

import mycpu_pkg::*;

module fu_svamod
  (
   input logic 		clk,
   input logic 		rst_n,
   input logic [15:0] a_in,
   input logic [15:0] b_in, 
   input logic [3:0] 	fs_in,
   input logic [15:0] f_out,
   input logic 		z_out,
   input logic 		n_out
   );
   
   `xcheck(a_in);
   `xcheck(b_in);
   `xcheck(fs_in);
   `xcheck(f_out);
   `xcheck(z_out);
   `xcheck(n_out);               
   
   property f_fu_mova;
     @(posedge clk) disable iff (rst_n == '0)
      (fs_in == FMOVA) |-> (f_out == a_in);
   endproperty

   property f_fu_inc;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FINC) |-> (f_out == a_in + 16'b00000000_00000001);
   endproperty		 

   property f_fu_add;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FADD) |-> (f_out == a_in + b_in);
   endproperty		 		 

   property f_fu_mul;
      logic signed [31:0] tmp = $signed(a_in) * $signed(b_in);
      @(posedge clk) disable iff (rst_n == '0)
	(fs_in == FMUL) |-> 	
	  (if ( tmp > 16'sb01111111_11111111)
	    (f_out == 16'b01111111_11111111)
	    else if (tmp < 16'sb10000000_00000000)
	      (f_out == 16'b10000000_00000000)
	      else
		(f_out == tmp[15:0]));
   endproperty

   property f_fu_sra;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FSRA) |-> (f_out == $unsigned(($signed(b_in) >>> 1)));
   endproperty

   property f_fu_sub;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FSUB) |-> (f_out == (a_in - b_in));
   endproperty

   property f_fu_dec;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FDEC) |-> (f_out == (a_in - 16'b00000000_00000001));
   endproperty

   property f_fu_sla;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FSLA) |-> (f_out == $unsigned(($signed(b_in) <<< 1)));
   endproperty

   property f_fu_and;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FAND) |-> (f_out == (a_in & b_in));
   endproperty	      	      

   property f_fu_or;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FOR) |-> (f_out == (a_in | b_in));
   endproperty
   
   property f_fu_xor;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FXOR) |-> (f_out == (a_in ^ b_in));
   endproperty	      	      

   property f_fu_not;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FNOT) |-> (f_out == ~a_in);
   endproperty

   property f_fu_movb;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FMOVB) |-> (f_out == b_in);
   endproperty

   property f_fu_shr;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FSHR) |-> (f_out == (b_in >> 1));
   endproperty	    

   property f_fu_shl;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FSHL) |-> (f_out == (b_in << 1));
   endproperty

   property f_fu_clr;
     @(posedge clk) disable iff (rst_n == '0)
       (fs_in == FCLR) |-> (f_out == 16'b00000000_00000000);
   endproperty

   property f_fu_n_unset;
     @(posedge clk) disable iff (rst_n == '0)
       (f_out[15] == '0) |-> !n_out;
   endproperty

   property f_fu_n_set;
     @(posedge clk) disable iff (rst_n == '0)
       (f_out[15] == '1) |-> n_out;
   endproperty

   property f_fu_z_unset;
     @(posedge clk) disable iff (rst_n == '0)
       (f_out != 16'b00000000_00000000) |-> !z_out;
   endproperty

   property f_fu_z_set;
     @(posedge clk) disable iff (rst_n == '0)
       (f_out == 16'b00000000_00000000) |-> z_out;
   endproperty
   

   af_fu_mova: assert property(f_fu_mova) else $error("FMOVA");
   af_fu_inc: assert property(f_fu_inc) else $error("FINC");
   af_fu_add: assert property(f_fu_add) else $error("FADD");
   af_fu_mul: assert property(f_fu_mul) else $error("FMUL");
   af_fu_sra: assert property(f_fu_sra) else $error("FSRA");
   af_fu_sub: assert property(f_fu_sub) else $error("FSUB");
   af_fu_dec: assert property(f_fu_dec) else $error("FDEC");
   af_fu_sla: assert property(f_fu_sla) else $error("FSLA");
   af_fu_and: assert property(f_fu_and) else $error("FAND");
   af_fu_or: assert property(f_fu_or) else $error("FOR");
   af_fu_xor: assert property(f_fu_xor) else $error("FXOR");
   af_fu_not: assert property(f_fu_not) else $error("FNOT");
   af_fu_movb: assert property(f_fu_movb) else $error("FMOVB");
   af_fu_shr: assert property(f_fu_shr) else $error("FSHR");
   af_fu_shl: assert property(f_fu_shl) else $error("FSHL");
   af_fu_clr: assert property(f_fu_clr) else $error("FCLR");
   af_fu_n_unset: assert property(f_fu_n_unset) else $error("n_out should be '0");
   af_fu_n_set: assert property(f_fu_n_set) else $error("n_out should be '1");   
   af_fu_z_unset: assert property(f_fu_z_unset) else $error("z_out should be '0");
   af_fu_z_set: assert property(f_fu_z_set) else $error("z_out should be '1");   

   covergroup cg_fs @(fs_in);
      coverpoint fs_in
	{
	 bins fs[] = { [0:15] };
      }
   endgroup

   cg_fs cg_fs_inst = new;

endmodule

`endif //  `ifndef SYNTHESIS
