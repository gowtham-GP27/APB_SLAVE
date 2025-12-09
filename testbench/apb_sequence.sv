class apb_seq1 extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_seq1)
  rand bit[7:0] test_addr;
  
  function new(string name = "apb_seq1");
    super.new(name);
  endfunction
  
  task body();
    `uvm_do_with(req,{PWRITE ==1;PADDR == test_addr;})
  endtask
endclass

class apb_seq2 extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_seq2)
  rand bit [7:0] test_addr; 
  function new(string name = "apb_seq2");
    super.new(name);
  endfunction
  
  task body();
    `uvm_do_with(req,{PWRITE ==0;PADDR == test_addr;})
  endtask
endclass

class apb_seq3 extends uvm_sequence#(apb_seq_item);
	`uvm_object_utils(apb_seq3)
	task body();
		`uvm_do_with(req,{PADDR == 257;})
	endtask
endclass
class virtual_sequence extends uvm_sequence #(apb_seq_item);  
  `uvm_object_utils(virtual_sequence)
  
  rand bit [7:0] addr3; 
  
  apb_seq1 seq1;
  apb_seq2 seq2;
	apb_seq3 seq3;
  apb_sequencer seqr;
  
  function new(string name = "virtual_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    void'(std::randomize(addr3) with { addr3 inside {[0:255]}; });
    
    `uvm_info("VSEQ", $sformatf(" Address: %0d", addr3), UVM_LOW)

    `uvm_info("VSEQ", "Starting Write Sequence", UVM_LOW)
    seq1 = apb_seq1::type_id::create("seq1");
    
    seq1.test_addr = addr3; 
    
    seq1.start(seqr);

    `uvm_info("VSEQ", "Starting Read Sequence", UVM_LOW)
    seq2 = apb_seq2::type_id::create("seq2");
    seq2.test_addr = addr3; 
    seq2.start(seqr);
    
		seq3 = apb_seq3::type_id::create("seq3");
		seq3.start(seqr);
    
  endtask
endclass
