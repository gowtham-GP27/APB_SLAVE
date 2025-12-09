class apb_act_monitor extends uvm_monitor;
	  `uvm_component_utils(apb_act_monitor)
	  virtual intf vif;
	  uvm_analysis_port#(apb_seq_item)act_mon_port;
	  
	  function new(string name="apb_act_monitor",uvm_component parent=null);
			    super.new(name,parent);
			    act_mon_port = new("act_mon_port",this);
			  endfunction
				  
				  function void build_phase(uvm_phase phase);
						    super.build_phase(phase);
						    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
									      `uvm_fatal("MON", "Virtual Interface not found in Config DB");
						  endfunction
							  
							  task run_phase(uvm_phase phase);
									    forever begin
												      @(vif.mon_cb);
												      if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY)begin
																        apb_seq_item req;
																        
																        req=apb_seq_item::type_id::create("req");
																        req.PADDR=vif.mon_cb.PADDR;
																        req.PWRITE=vif.mon_cb.PWRITE;
																        req.PWDATA=vif.mon_cb.PWDATA;
																        req.PSTRB=vif.mon_cb.PSTRB;
																        `uvm_info("APB_MON", $sformatf(" active monitor Collected: %s", req.convert2string()), UVM_HIGH);
																        act_mon_port.write(req);
																      end
												    end
									  endtask
endclass
class apb_pass_monitor extends uvm_monitor;
	  `uvm_component_utils(apb_pass_monitor)
	  virtual intf vif;
	  uvm_analysis_port#(apb_seq_item)mon_pass_port;
	  
	  function new(string name="apb_act_monitor",uvm_component parent=null);
			    super.new(name,parent);
			    mon_pass_port = new("mon_pass_port",this);
			  endfunction
				  
				  function void build_phase(uvm_phase phase);
						    super.build_phase(phase);
						    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
									      `uvm_fatal("MON", "Virtual Interface not found in Config DB");
						  endfunction
							  
							  task run_phase(uvm_phase phase);
									    forever begin
												      @(vif.mon_cb);
												      if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY)begin
																        apb_seq_item req;
																        
																        req=apb_seq_item::type_id::create("req");
																        req.PSELVERR=vif.mon_cb.PSELVERR;
																        req.PRDATA=vif.mon_cb.PRDATA;
																        `uvm_info("APB_MON", $sformatf(" active monitor Collected: %s", req.convert2string()), UVM_HIGH);
																        mon_pass_port.write(req);
																      end
												    end
									  endtask
endclass
