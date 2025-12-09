class apb_driver extends uvm_driver#(apb_seq_item);
	  `uvm_component_utils(apb_driver)
	  virtual intf vif;
	  apb_seq_item req;
	  function new(string name = "apb_driver",uvm_component parent);
			    super.new(name,parent);
			  endfunction
				  
				  function void build_phase(uvm_phase phase);
						    super.build_phase(phase);
						    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
									      `uvm_fatal("DRV", "Virtual Interface not found in Config DB");
						  endfunction
							  
							  task run_phase(uvm_phase phase);
									    vif.drv_cb.PSEL <=0;
									    vif.drv_cb.PENABLE <=0;
									    vif.drv_cb.PSTRB <=0;
									    vif.drv_cb.PWRITE <=0;
									    vif.drv_cb.PADDR <=0;
									    vif.drv_cb.PWDATA <=0;
									    
									    forever begin
												      seq_item_port.get_next_item(req);
												      drive(req);
												      seq_item_port.item_done();
												    end
									  endtask
										  
										  task drive(apb_seq_item req);
												    vif.drv_cb.PADDR <= req.PADDR;
												    vif.drv_cb.PWRITE <= req.PWRITE;
												    vif.drv_cb.PSEL <= 1;
												    vif.drv_cb.PENABLE <=0;
												    
												    if(req.PWRITE)begin
															      vif.drv_cb.PWDATA <= req.PWDATA;
															      vif.drv_cb.PSTRB <= req.PSTRB;
															    end else begin
																		      vif.drv_cb.PWDATA <= 0;
																		      vif.drv_cb.PSTRB <= 0;
																		    end
												    @(vif.drv_cb);
												     vif.drv_cb.PENABLE <=1;
												    @(vif.drv_cb);
												    while(vif.drv_cb.PREADY == 0)begin
															       `uvm_info("DRV", $sformatf("Waiting for PREADY... Addr: %0h",
																			                                         req.PADDR), UVM_HIGH)
															       @(vif.drv_cb); 
															    end
												    vif.drv_cb.PSEL    <= 0;
												    vif.drv_cb.PENABLE <= 0;
												    vif.drv_cb.PSTRB   <= 0;    
												  endtask
endclass
