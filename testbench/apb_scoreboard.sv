`include "uvm_macros.svh"
import uvm_pkg::*;

`uvm_analysis_imp_decl(_act_mon)
`uvm_analysis_imp_decl(_pass_mon)

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp_act_mon#(apb_seq_item, apb_scoreboard) act_mon_imp;
  uvm_analysis_imp_pass_mon#(apb_seq_item, apb_scoreboard) pass_mon_imp;

  apb_seq_item act_mon_queue[$];
  apb_seq_item pass_mon_queue[$];

  bit [31:0] mem[int];

  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name, parent);
    act_mon_imp  = new("act_mon_imp",  this);
    pass_mon_imp = new("pass_mon_imp", this);
  endfunction

  function void write_act_mon(apb_seq_item req);
    act_mon_queue.push_back(req);
  endfunction

  function void write_pass_mon(apb_seq_item req);
    pass_mon_queue.push_back(req);
  endfunction

  task run_phase(uvm_phase phase);

    apb_seq_item active_seq;
    apb_seq_item passive_seq;
    bit [31:0] exp_data;
    bit [31:0] current_mem_val;

    forever begin

      fork
        begin : ACT_MON_THREAD
          wait (act_mon_queue.size() > 0);
          active_seq = act_mon_queue.pop_front();
        end

        begin : PASS_MON_THREAD
          wait (pass_mon_queue.size() > 0);
          passive_seq = pass_mon_queue.pop_front();
        end
      join  
      if (active_seq.PADDR === 'bx ||
          (active_seq.PWRITE && active_seq.PWDATA === 'bx)) begin

        if (passive_seq.PSELVERR != 1'b1) begin
          `uvm_error("APB_SCB",
                     $sformatf("Addr/Data is X. Expected PSLVERR=1 but got=%0b",
                               passive_seq.PSELVERR))
        end else begin
          `uvm_info("APB_SCB",
                    "Input was X and PSLVERR is correctly asserted",
                    UVM_LOW)
        end

        continue;
      end

      if (passive_seq.PSELVERR) begin
        `uvm_info("APB_SCB",
                  "PSLVERR asserted. Skipping memory update.",
                  UVM_MEDIUM)
        continue;
      end

      if (active_seq.PWRITE) begin
        current_mem_val = mem[active_seq.PADDR];
        if (active_seq.PSTRB[0])
          current_mem_val[7:0]	 = active_seq.PWDATA[7:0];

        if (active_seq.PSTRB[1])
          current_mem_val[15:8] = active_seq.PWDATA[15:8];

        if (active_seq.PSTRB[2])
          current_mem_val[23:16] = active_seq.PWDATA[23:16];

        if (active_seq.PSTRB[3])
          current_mem_val[31:24] = active_seq.PWDATA[31:24];

        mem[active_seq.PADDR] = current_mem_val;

        `uvm_info("APB_SCB",
                  $sformatf("WRITE Addr=%0d Data=%0d Strobe=%b",
                             active_seq.PADDR,
                             current_mem_val,
                             active_seq.PSTRB),
                  UVM_LOW)

      end

      else begin

        exp_data = mem[active_seq.PADDR];

        if (passive_seq.PRDATA != exp_data) begin
          `uvm_error("APB_SCB",
                     $sformatf("READ MISMATCH Addr=%0d Exp=%0d Got=%0d",
                               active_seq.PADDR,
                               exp_data,
                               passive_seq.PRDATA))
        end else begin
          `uvm_info("APB_SCB",
                    $sformatf("READ MATCH Addr=%0d Data=%0d",
                              active_seq.PADDR,
                              passive_seq.PRDATA),
                    UVM_LOW)
        end
      end

    end

  endtask

endclass

         
         
         
    
    
  
  
  


  
  
  
  
