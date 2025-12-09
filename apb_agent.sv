class apb_act_agent extends uvm_agent;
	  apb_sequencer seqr;
	  apb_act_monitor mon;
	  apb_driver drv;
	  `uvm_component_utils(apb_act_agent);
	  function new(string name = "apb_act_agent",uvm_component parent);
			    super.new(name,parent);
			  endfunction
				  
				  virtual function void build_phase(uvm_phase phase);
						    super.build_phase(phase);
						    if(get_is_active()==UVM_ACTIVE)begin
									      drv=apb_driver::type_id::create("drv",this);
									      seqr=apb_sequencer::type_id::create("seqr",this);
									    end
						    mon=apb_act_monitor::type_id::create("mon",this);
						  endfunction
							  
							  virtual function void connect_phase(uvm_phase phase);
									    super.connect_phase(phase);
									    if(get_is_active()==UVM_ACTIVE)begin
												      drv.seq_item_port.connect(seqr.seq_item_export);
												    end
									  endfunction
endclass
class apb_pass_agent extends uvm_agent;
	  apb_pass_monitor pass_mon;
	  apb_sequencer seqr;
	  apb_driver drv;
	  `uvm_component_utils(apb_pass_agent);
	  function new(string name = "apb_pass_agent",uvm_component parent);
			    super.new(name,parent);
			  endfunction
				  
				  virtual function void build_phase(uvm_phase phase);
						    super.build_phase(phase);
						    if(get_is_active() == UVM_ACTIVE) begin
									    drv=apb_driver::type_id::create("drv",this);
									    seqr=apb_sequencer::type_id::create("seqr",this);
									    end
						    pass_mon=apb_pass_monitor::type_id::create("pass_mon",this);

						  endfunction
endclass
