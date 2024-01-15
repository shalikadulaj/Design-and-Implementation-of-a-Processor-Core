`include "mycpu.svh"

import mycpu_pkg::*;

module fu_test
  (
   input logic 		 clk,
   input logic 		 rst_n,
   output logic [15:0]   a_in,
   output logic [15:0]   b_in, 
   output logic [3:0] 	 fs_in,
   input logic [15:0]    f_out,
   input logic 		 z_out,
   input logic 		 n_out
   );
   
   initial
     begin : test_program
	a_in = '0;
	b_in = '0;
	fs_in = '0;

	wait(rst_n);
	

	$info("T1 FMOVA");

	a_in = 16'b00000000_00000000;
	b_in = 16'b11111111_11111111;
	fs_in =FMOVA;
	@(posedge clk);
	assert (f_out == a_in) else $error("T1: FMOVA, f_out");
	assert (z_out == '1) else $error("T1: FMOVA, z_out");		
	assert (n_out == '0) else $error("T1: FMOVA, n_out");
	@(negedge clk);
	$display("FMOVA %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);
	
	a_in = 16'b11111111_11111111;
	b_in = 16'b00000000_00000000;	
	fs_in =FMOVA;
	@(posedge clk);	
	assert (f_out == a_in) else $error("T1: FMOVA, f_out");
	assert (z_out == '0) else $error("T1: FMOVA, z_out");		
	assert (n_out == '1) else $error("T1: FMOVA, n_out");
	@(negedge clk);
	$display("FMOVA %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FINC");
	
	a_in = 16'b00000000_00000000;
	b_in = 16'b11111111_11111111;	
	fs_in =FINC;
	@(posedge clk);	
	assert (f_out == 16'b00000000_00000001) else $error("T1: FINC, f_out");
	@(negedge clk);
	$display("FINC  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);
	
	a_in = 16'b11111111_11111111;
	b_in = 16'b00000000_00000000;
	fs_in =FINC;
	@(posedge clk);	
	assert (f_out == 16'b00000000_00000000) else $error("T1: FINC, f_out");
	@(negedge clk);	
	$display("FINC  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FADD");
	
	a_in = 16'b01111111_11111111;
	b_in = 16'b10000000_00000001;	
	fs_in =FADD;
	@(posedge clk);	
	assert (f_out == 16'b00000000_00000000) else $error("T1: FADD, f_out");
	@(negedge clk);
	$display("FADD  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	a_in = 16'b01111111_11111111;
	b_in = 16'b00000000_00000010;	
	fs_in =FADD;
	@(posedge clk);	
	assert (f_out == 16'b10000000_00000001) else $error("T1: FADD, f_out");
	@(negedge clk);
	$display("FADD  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FMUL");
	
	a_in = 16'b00000000_00000001;
	b_in = 16'b10000000_00000000;	
	fs_in =FMUL;
	@(posedge clk);	
	assert (f_out == 16'b10000000_00000000) else $error("T1: FMUL, f_out");
	@(negedge clk);
	$display("FMUL  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);
	
	a_in = 16'b00000000_00000011; // 3
	b_in = 16'b11010101_01010101; // -10923
	fs_in =FMUL;
	@(posedge clk);	
	assert (f_out == 16'b10000000_00000000) else $error("T1: FMUL");
	@(negedge clk);
	$display("FMUL  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);
	
	a_in = 16'b00000000_00000011; // 3
	b_in = 16'b00101010_10101011; // 10923
	fs_in =FMUL;
	@(posedge clk);	
	assert (f_out == 16'b01111111_11111111) else $error("T1: FMUL");
	@(negedge clk);
	$display("FMUL  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);
	
	a_in = 16'b00000000_00000010;
	b_in = 16'b00000000_00000011;
	fs_in =FMUL;
	@(posedge clk);	
	assert (f_out == 16'b00000000_00000110) else $error("T1: FMUL");
	@(negedge clk);
	$display("FMUL  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);
	
	$info("T1 FSRA");
	
	a_in = 16'b00000000_00000000;
	b_in = 16'b01000000_00000000;
	fs_in =FSRA;
	@(posedge clk);	
	assert (f_out == 16'b00100000_00000000) else $error("T1: FSRA");
	@(negedge clk);
	$display("FSRA  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	a_in = 16'b00000000_00000000;
	b_in = 16'b11111111_11111110;
	fs_in =FSRA;
	@(posedge clk);	
	assert (f_out == 16'b11111111_11111111) else $error("T1: FSRA");
	@(negedge clk);
	$display("FSRA  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FSUB");
	
	a_in = 16'b00000000_11111111;
	b_in = 16'b00000000_10000000;
	fs_in =FSUB;
	@(posedge clk);	
	assert (f_out == 16'b00000000_01111111) else $error("T1: FSUB");
	@(negedge clk);
	$display("FSUB  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	a_in = 16'b10000000_00000000;
	b_in = 16'b10000000_00000000;
	fs_in =FSUB;
	@(posedge clk);	
	assert (f_out == 16'b00000000_00000000) else $error("T1: FSUB");
	@(negedge clk);
	$display("FSUB  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FDEC");
	
	a_in = 16'b10000000_00000000;
	b_in = 16'b11111111_00000000;
	fs_in =FDEC;
	@(posedge clk);	
	assert (f_out == 16'b01111111_11111111) else $error("T1: FDEC");
	@(negedge clk);
	$display("FDEC  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FSLA");
	
	a_in = 16'b00000000_00000000;
	b_in = 16'b01111111_11111111;
	fs_in =FSLA;
	@(posedge clk);	
	assert (f_out == 16'b11111111_11111110) else $error("T1: FSLA");
	@(negedge clk);
	$display("FSLA  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	a_in = 16'b00000000_00000000;
	b_in = 16'b10000000_00000000;
	fs_in =FSLA;
	@(posedge clk);	
	assert (f_out == 16'b00000000_00000000) else $error("T1: FSLA");
	@(negedge clk);
	$display("FSLA  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FAND");
	
	a_in = 16'b11111111_11111111;
	b_in = 16'b00000000_11111111;
	fs_in =FAND;
	@(posedge clk);	
	assert (f_out == 16'b00000000_11111111) else $error("T1: FAND");
	@(negedge clk);
	$display("FAND  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FOR");
	
	a_in = 16'b01010101_01010101;
	b_in = 16'b00000000_10101010;
	fs_in =FOR;
	@(posedge clk);	
	assert (f_out == 16'b01010101_11111111) else $error("T1: FOR");
	@(negedge clk);
	$display("FOR   %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FXOR");
	
	a_in = 16'b01010101_11111111;
	b_in = 16'b00000000_10101010;
	fs_in =FXOR;
	@(posedge clk);	
	assert (f_out == 16'b01010101_01010101) else $error("T1: FXOR");
	@(negedge clk);
	$display("FXOR  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FNOT");	
	
	a_in = 16'b00000000_11111111;
	b_in = 16'b10101010_10101010;
	fs_in =FNOT;
	@(posedge clk);	
	assert (f_out == 16'b11111111_00000000) else $error("T1: FNOT");
	@(negedge clk);
	$display("FNOT  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FMOVB");	
	
	a_in = 16'b00000000_00000000;
	b_in = 16'b11111111_11111111;
	fs_in =FMOVB;
	@(posedge clk);
	assert (f_out == b_in) else $error("T1: FMOVB");
	@(negedge clk);
	$display("FMOVB %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FSHR");	
	
	a_in = 16'b00000000_00000000;
	b_in = 16'b01000000_00000000;
	fs_in =FSHR;
	@(posedge clk);	
	assert (f_out == 16'b00100000_00000000) else $error("T1: FSHR");
	@(negedge clk);
	$display("FSHR  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FSRA");	
	
	a_in = 16'b00000000_00000000;
	b_in = 16'b11111111_11111110;
	fs_in =FSHR;
	@(posedge clk);	
	assert (f_out == 16'b01111111_11111111) else $error("T1: FSHR");
	@(negedge clk);
	$display("FSRA  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	$info("T1 FCLR");	
	
	a_in = 16'b11111111_11111111;
	b_in = 16'b11111111_11111111;
	fs_in =FCLR;
	@(posedge clk);	
	assert (f_out == 16'b00000000_00000000) else $error("T1: FCLR");
	@(negedge clk);
	$display("FSRA  %4b  %16b %16b => %16b %1b %1b", fs_in, a_in, b_in, f_out, z_out, n_out);

	#100ns;
	
	$info("T2 Random Tests");
	
	repeat(100)
	  begin
	     fs_t fs;
	     a_in = $urandom;
	     b_in = $urandom;
	     fs_in = $urandom;	     	     
	     fs = fs_t'(fs_in);
	     @(posedge clk);
	     
	     $display("     %5s  %16b %16b => %16b %1b %1b", fs.name(), a_in, b_in, f_out, z_out, n_out);
	     
	     @(negedge clk);	     
	  end

	$finish;
	
     end : test_program

endmodule
