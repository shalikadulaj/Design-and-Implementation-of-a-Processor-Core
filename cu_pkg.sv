`ifndef SYNTHESIS

`include "mycpu.svh"

package cu_pkg;

   import mycpu_pkg::*;

   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Function that prints state table column headers
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   function void print_st_header;
      $write("--------------------------------------------------------------------------------------------------------------\n");
      $write("            INPUTS              |                               OUTPUTS                                      |\n");
      $write("--------------------------------------------------------------------------------------------------------------\n");      
      $write("%21s %2s %4s | ", "ins_in", "z_in", "n_in");
      $write("%6s %6s %6s %12s %6s %6s %6s %6s %7s %7s |\n", "ps_out", "il_out", "rw_out", "rs_out", "mm_out", "md_out", "mb_out", "fs_out", "wen_out", "iom_out");
      $write("--------------------------------------------------------------------------------------------------------------\n");
   endfunction

   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Function that prints state table column values aligned with headers
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   function void print_st_row
     (
      logic [15:0] ins_in,
      logic 	   z_in,
      logic 	   n_in,
      logic [1:0]  ps_out,
      logic 	   il_out,
      logic 	   rw_out,
      logic [8:0]  rs_out,
      logic 	   mm_out,
      logic [1:0]  md_out,
      logic 	   mb_out,
      logic [3:0]  fs_out,
      logic 	   wen_out,
      logic 	   iom_out   
      );
      opcode_t     opcode;
      opcode  = opcode_t'(ins_in[15:9]);
      $write("%4s %16b    %b    %b |     %b      %b      %b %b      %b     %b      %b   %b       %b       %b |\n", 
	     opcode.name(), ins_in, z_in, n_in, ps_out, il_out, rw_out, rs_out, mm_out, md_out, mb_out, fs_out, wen_out, iom_out);
   endfunction
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Data structure for state table inputs
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   typedef
     struct packed {
	cu_state_t st;
	opcode_t   opcode;
	logic [8:0] ops;
	logic z;
	logic n;
     } st_inputs_t;

   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Data structure for state table outputs
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   typedef
     struct packed {
	cu_state_t ns;
	logic [1:0] ps;
	logic 	    il;
	logic 	    rw;
	logic [11:0] rs;	
	logic 	    mm;
	logic [1:0] md;
	logic 	    mb;
	logic [3:0] fs;
	logic 	    wen;
	logic 	    iom;
     } st_outputs_t;

   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Data structure for state table
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   typedef
     struct packed {
	st_inputs_t inputs;
	st_outputs_t outputs;
     } st_t;


   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Initialized constant array for state table
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   localparam int 	    STATE_TABLE_SIZE = 33;
   
   const st_t st[STATE_TABLE_SIZE] = {
		  { { RST, 7'bxxxxxxx, 9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b00, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'bxxxx, '1, '0 } },
		  { { INF, 7'bxxxxxxx, 9'bxxxxxxxxx, 'x, 'x}, { EX0, 2'b00, '1, '0, 12'b0xxx0xxx0xxx, '1, 2'bxx, 'x, 4'bxxxx, '1, '0 } },
		  { { EX0, MOVA,       9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, 'x, 4'b0000, '1, '0 } },
		  { { EX0, INC,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, 'x, 4'b0001, '1, '0 } },
		  { { EX0, ADD,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b0010, '1, '0 } },
		  { { EX0, MUL,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b0011, '1, '0 } },
		  { { EX0, SRA,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b0100, '1, '0 } },
		  { { EX0, SUB,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b0101, '1, '0 } },
		  { { EX0, DEC,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, 'x, 4'b0110, '1, '0 } },
		  { { EX0, SLA,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b0111, '1, '0 } },
		  { { EX0, AND,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b1000, '1, '0 } },
		  { { EX0, OR,         9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b1001, '1, '0 } },
		  { { EX0, XOR,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b1010, '1, '0 } },
		  { { EX0, NOT,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, 'x, 4'b1011, '1, '0 } },
		  { { EX0, MOVB,       9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b1100, '1, '0 } },
		  { { EX0, SHR,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b1101, '1, '0 } },
		  { { EX0, SHL,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b1110, '1, '0 } },
		  { { EX0, CLR,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '0, 4'b1111, '1, '0 } },
		  { { EX0, LD,         9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, '0, 2'b01, 'x, 4'bxxxx, '1, '0 } },
		  { { EX0, ST,         9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '0, 12'b0xxx0xxx0xxx, '0, 2'bxx, '0, 4'bxxxx, '0, '0 } },
		  { { EX0, LDI,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '1, 4'b1100, '1, '0 } },
		  { { EX0, ADI,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, 'x, 2'b00, '1, 4'b0010, '1, '0 } },
		  { { EX0, BRZ,        9'bxxxxxxxxx, '1, 'x}, { INF, 2'b10, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'b0000, '1, '0 } },
		  { { EX0, BRZ,        9'bxxxxxxxxx, '0, 'x}, { INF, 2'b01, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'b0000, '1, '0 } },
		  { { EX0, BRN,        9'bxxxxxxxxx, 'x, '1}, { INF, 2'b10, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'b0000, '1, '0 } },
		  { { EX0, BRN,        9'bxxxxxxxxx, 'x, '0}, { INF, 2'b01, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'b0000, '1, '0 } },
		  { { EX0, JMP,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b11, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'b0000, '1, '0 } },
		  { { EX0, IOR,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx0xxx, '0, 2'b10, 'x, 4'bxxxx, '1, '1 } },
		  { { EX0, IOW,        9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '0, 12'b0xxx0xxx0xxx, '0, 2'bxx, '0, 4'bxxxx, '0, '1 } },
		  { { EX0, HAL,        9'bxxxxxxxxx, 'x, 'x}, { HLT, 2'b00, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'bxxxx, '1, '0 } },
		  { { EX0, XXL,        9'bxxxxxxxxx, 'x, 'x}, { XL1, 2'b01, '0, '1, 12'b1xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'b0011, '1, '0 } },  				  
		  { { HLT, 7'bxxxxxxx, 9'bxxxxxxxxx, 'x, 'x}, { HLT, 2'b00, '0, '0, 12'b0xxx0xxx0xxx, 'x, 2'bxx, 'x, 4'bxxxx, '1, '0 } },
		  { { XL1, 7'bxxxxxxx, 9'bxxxxxxxxx, 'x, 'x}, { INF, 2'b01, '0, '1, 12'b0xxx0xxx1xxx, 'x, 2'bxx, 'x, 4'b0010, '1, '0 } }
		};


		

   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //
   // Function for checking if outputs ate correct for a specific input vector-
   //
   // Usage example:
   //   logic result;
   //	result = st_match( { EX0, ins_in, z_in, n_in}, 
   //                      { INF, ps_out, il_out, rw_out, rs_out, mm_out, md_out, mb_out, fs_out, wen_out, iom_out}
   //                    );   
   //
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
   
   function logic st_match( st_inputs_t inputs, st_outputs_t outputs);
      for (int i=0; i < STATE_TABLE_SIZE; ++i)
	begin
	   if (inputs ==? st[i].inputs )
	     begin
		if (outputs ==? st[i].outputs)
		  begin
		     return '1;
		  end
		else
		  begin
		     return '0;
		  end
	     end
	end

      $display("Error; no match for input vector: %b", inputs);
      return '0;      
   endfunction
      
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // List of opcodes.
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   localparam int OPCODE_COUNT = 27;
   const opcode_t opcodetable[27] =  { MOVA, INC , ADD , MUL , SRA , SUB , DEC , SLA , AND , OR  , XOR , NOT , 
				       MOVB, SHR , SHL , CLR , LDI , ADI , LD  , ST  , BRZ , BRN , JMP , IOR , 
				       IOW , XXL , HAL }; 

   
endpackage


`endif
