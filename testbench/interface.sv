interface intf(input logic PCLK,PRESETn);
  logic [31:0]PADDR;
  logic PENABLE;
  logic PWRITE;
  logic [31:0]PWDATA;
  logic [31:0]PRDATA;
  logic PSEL;
  logic [3:0]PSTRB;
  logic PREADY;
  logic PSELVERR;
  
  clocking drv_cb @(posedge PCLK);
    default input #0 output #0;
    output PADDR,PENABLE,PWRITE,PWDATA,PSEL,PSTRB;
    input PREADY,PRDATA,PSELVERR;
  endclocking
  
  clocking mon_cb @(posedge PCLK);
    default input #0 output #0;
    input PADDR,PENABLE,PWRITE,PWDATA,PSTRB,PRDATA,PREADY,PSELVERR,PSEL;
  endclocking
  
  modport drv(clocking drv_cb, input PCLK,PRESETn);
  modport mon(clocking mon_cb, input PCLK,PRESETn);
    
endinterface
  
