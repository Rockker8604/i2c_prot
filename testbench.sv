import uvm_pkg::*;
`include "uvm_macros.svh"

`define bit7 4,14
`define bit10 8,18 

`include "interface.sv"
`include "tb_pkg.sv"

module top;
  
  intface intf();
  Slave_7b#(4) sl7_1(intf.sda, intf.scl);
  Slave_7b#(14) sl7_2(intf.sda, intf.scl);
  Slave_10b#(8) sl10_1(intf.sda, intf.scl);
  Slave_10b#(18) sl10_2(intf.sda, intf.scl);
  assign intf.sda=1;
  assign intf.scl=1;
  initial begin
    uvm_config_db#(virtual intface)::set(uvm_root::get(),"*","driver",intf);
    uvm_config_db#(virtual intface)::set(uvm_root::get(),"*","monitor",intf);
  end
  
  initial run_test("test");
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
//     #5000 $finish;
  end
  
  // To check clock streching
//   initial begin
//     #62 @(negedge intf.scl);
//     force intf.scl=0;
//     #11 release intf.scl;
//     #185 @(negedge intf.scl);
//     force intf.scl=0;
//     #16 release intf.scl;
//   end
  
endmodule