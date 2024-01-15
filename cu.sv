`include "mycpu.svh"

import mycpu_pkg::*;

module cu
  (
   input logic 		clk,
   input logic 		rst_n,
   input logic [15:0] ins_in,
   input logic 		z_in,
   input logic 		n_in,
   output logic 	il_out,
   output logic [1:0] 	ps_out,
   output logic 	rw_out,
   output logic [11:0] 	rs_out,
   output logic 	mm_out,
   output logic [1:0] 	md_out,
   output logic 	mb_out,
   output logic [3:0] 	fs_out,
   output logic 	wen_out,
   output logic 	iom_out   
   );

   // Type cu_state_t is defined in mycpu_pkg.sv
   cu_state_t          st_r;
   cu_state_t          ns;   
   // Type opcode_t is defined in mycpu_pkg.sv
   opcode_t 	       opcode;

   // Cast opcode from ins_in[15:9] to opocde_t type
   assign opcode = opcode_t'(ins_in[15:9]);

  always_ff @(posedge clk or negedge rst_n)
     begin : st_regs
	if (rst_n == '0)
	  
	     st_r <= RST;
	 
	else
	  
	     st_r <= ns;
	  
     end : st_regs

  always_comb
    begin : idecoder
  
	ns = st_r;
	ps_out = '0;
	fs_out = '0;
	il_out = 0;
	iom_out = 0;
	rw_out = 0;
	rs_out = '0;
	wen_out = 1;
	mb_out = 0;
	md_out = '0;
	mm_out = '0;
               
     
       
       case (st_r)
	 RST: ns = INF;
	   
	 INF:
	   begin
	      ns = EX0;
	      il_out = 1;
	      mm_out = 1;
	   end
	 EX0:
	   begin
	      fs_out = opcode[3:0];
	      rs_out = {1'b0, ins_in[8:6], 1'b0, ins_in[5:3], 1'b0, ins_in[2:0]};	      
	      case (opcode)
		MOVA:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		INC:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		ADD:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		MUL:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		SRA:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		SUB:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		DEC:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		SLA:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		AND:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		OR:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		XOR:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		NOT:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		MOVB:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		SHR:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		SHL:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		CLR:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		  end
		LD:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		     md_out = 1;
		  end
		ST:
		  begin
		     ns = INF;
		     ps_out = 1;
		     wen_out = 0;
		  end
		LDI:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		     mb_out = 1;
		  end
		ADI:
		  begin
		     ns = INF;
		     rw_out = 1;
		     ps_out = 1;
		     mb_out = 1;
		  end
		BRZ:
		  begin
		     if (z_in)
		       begin
			  ns = INF;
			  ps_out = 2;
		       end
		     else
		       begin
			  ns = INF;
			  ps_out = 1;
		       end
		  end
		BRN:
		  begin
		     if (n_in)
		       begin
			  ns = INF;
			  ps_out = 2;
			  fs_out = '0;
		       end
		     else
		       begin
			  ns = INF;
			  ps_out = 1;
			  fs_out = '0;
		       end
		  end
		JMP:
		  begin
		     ns = INF;
		     ps_out = '1;
		     fs_out = '0;
		  end
		IOR:
		  begin
		     ns = INF;
		     ps_out = 1;
		     rw_out = 1;
		     md_out = 2;
		     iom_out = 1;
		     fs_out = '0;
		  end
		IOW:
		  begin
		     ns = INF;
		     ps_out = 1;
		     wen_out = 0;
		     iom_out = 1;
		     fs_out = '0;
		  end
		HAL:
		  begin
		     ns = HLT;
		     fs_out = '0;
		  end
		XXL:
		  begin
		     ns = XL1;
		     rw_out = 1;
		     ps_out = 1;
		     fs_out = 4'b0011;
		     rs_out = {4'b1111, 4'b0001, 4'b0010};
		  end
		default:
		  begin
		     ns = HLT;
		     fs_out = '0;
		  end
	      endcase
	   end
	
	   
	 XL1:
	   begin
	      ns = INF;
	      rw_out = 1;
	      ps_out = 1;
	      fs_out = 4'b0010;
	      rs_out = {4'b0000, 4'b0000, 4'b1111};
	   end
	 default: ns = RST;
       endcase
    end : idecoder

   
endmodule
               
   
