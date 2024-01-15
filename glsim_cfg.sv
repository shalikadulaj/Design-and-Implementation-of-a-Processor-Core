config mycpu_hier_cfg;
   design glib.mycpu;
   default liblist glib;
endconfig

config glsim_cfg;   
   design work.mycpu_tb;
   default liblist work glib;
   instance mycpu_tb.DUT use work.mycpu_hier_cfg:config;
   instance mycpu_tb.REF use work.mycpu;
endconfig


