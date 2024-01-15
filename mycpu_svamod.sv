`ifndef SYNTHESIS

`include "mycpu.svh"

module mycpu_svamod
  
  (
   input logic 	      clk,
   input logic 	      rst_n, 
   input logic [15:0] a_out, 
   input logic [15:0] d_in,
   input logic [15:0] d_out,
   input logic [15:0] io_in,
   input logic 	      wen_out,
   input logic 	      iom_out,
   input logic [1:0]  ps,
   input logic 	      il,
   input logic 	      mm,
   input logic [1:0]  md,
   input logic 	      mb,
   input logic 	      rw,
   input logic [11:0] rs,
   input logic [3:0]  fs,
   input logic [15:0] pca,
   input logic [15:0] ins,
   input logic [15:0] ia,
   input logic [15:0] iv,
   input logic [15:0] abus,
   input logic [15:0] bdat,
   input logic [15:0] fbus,
   input logic 	      z,
   input logic 	      n,
   input logic [15:0] dbus,
   input logic [15:0] bbus            
   );

   `xcheck(a_out);
   `xcheck(d_in);
   `xcheck(d_out);
   `xcheck(io_in);
   `xcheck(wen_out);
   `xcheck(iom_out);
   `xcheck(ps);
   `xcheck(il);
   `xcheck(mm);
   `xcheck(md);
   `xcheck(mb);
   `xcheck(rw);
   `xcheck(rs);
   `xcheck(fs);
   `xcheck(pca);
   `xcheck(ins);
   `xcheck(ia);
   `xcheck(iv);
   `xcheck(abus);
   `xcheck(bdat);
   `xcheck(fbus);
   `xcheck(z);
   `xcheck(n);
   `xcheck(dbus);
   `xcheck(bbus);
   
endmodule


`endif //  `ifndef SYNTHESIS
