`include "uvm_macros.svh"
`include "apb_pkg.sv"
`include "interface.sv"
`include "design.sv"
module top;
  import uvm_pkg::*;
  import apb_pkg::*;
  
  bit PCLK;
  bit PRESETN;
  
  always #5 PCLK = ~PCLK;
  initial begin
    PRESETN = 0;
    PCLK = 0;
    #10 PRESETN = 1;
  end
  intf vif(PCLK,PRESETN);
  
  apb_slave dut(
    .PCLK(PCLK),
    .PRESETn(PRESETN),
    .PSEL(vif.PSEL),
    .PENABLE(vif.PENABLE),
    .PSTRB(vif.PSTRB),
    .PREADY(vif.PREADY),
    .PWRITE(vif.PWRITE),
    .PADDR(vif.PADDR),
    .PWDATA(vif.PWDATA),
    .PSLVERR(vif.PSELVERR),
    .PRDATA(vif.PRDATA));
  
  initial begin
    uvm_config_db#(virtual intf)::set(null,"*","vif",vif);
  end
  initial begin
    run_test("apb_test");
    #50 $finish;
  end
endmodule
