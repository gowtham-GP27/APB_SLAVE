class apb_environment extends uvm_env;
  `uvm_component_utils(apb_environment)
  function new(string name = "",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  apb_coverage cov;
  apb_scoreboard scb;
  apb_act_agent act_agt;
  apb_pass_agent pass_agt;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov = apb_coverage::type_id::create("cov",this);
    scb = apb_scoreboard::type_id::create("scb",this);
    act_agt=apb_act_agent::type_id::create("act_agt",this);
    pass_agt=apb_pass_agent::type_id::create("pass_agt",this);
    set_config_int("pass_agt","is_active",UVM_PASSIVE);
    set_config_int("act_agt","is_active",UVM_ACTIVE);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    act_agt.mon.act_mon_port.connect(scb.act_mon_imp);
    pass_agt.pass_mon.mon_pass_port.connect(scb.pass_mon_imp);
    act_agt.mon.act_mon_port.connect(cov.a_mon_cov_imp);
    pass_agt.pass_mon.mon_pass_port.connect(cov.p_mon_cov_imp);
  endfunction
endclass
    
    
    
    
    
