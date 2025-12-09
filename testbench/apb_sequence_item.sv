`include "uvm_macros.svh"
import uvm_pkg::*;
class apb_seq_item extends uvm_sequence_item;
	  rand bit [31:0]PADDR;
	  rand bit [31:0]PWDATA;
	  rand bit PWRITE;
	  rand bit [3:0]PSTRB;
	  rand bit PSEL;
	  rand bit PENABLE;
	  bit[31:0] PRDATA;
	  bit PREADY;
	  bit PSELVERR;
	  `uvm_object_utils_begin(apb_seq_item)
	  `uvm_field_int(PADDR,UVM_ALL_ON)
	  `uvm_field_int(PWDATA,UVM_ALL_ON)
	  `uvm_field_int(PWRITE,UVM_ALL_ON)
	  `uvm_field_int(PSTRB,UVM_ALL_ON)
	  `uvm_field_int(PSEL,UVM_ALL_ON)
	  `uvm_field_int(PENABLE,UVM_ALL_ON)
	  `uvm_field_int(PRDATA,UVM_ALL_ON)
	  `uvm_field_int(PREADY,UVM_ALL_ON)
	  `uvm_field_int(PSELVERR,UVM_ALL_ON)
	  `uvm_object_utils_end

	  function new(string name="apb_seq_item");
			    super.new(name);
			  endfunction
endclass
