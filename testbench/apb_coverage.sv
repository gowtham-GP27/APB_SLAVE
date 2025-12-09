`uvm_analysis_imp_decl(_active_mon_cg)
`uvm_analysis_imp_decl(_passive_mon_cg)

class apb_coverage extends uvm_component;
  `uvm_component_utils(apb_coverage)

  uvm_analysis_imp_active_mon_cg #(apb_seq_item, apb_coverage) a_mon_cov_imp;
  uvm_analysis_imp_passive_mon_cg #(apb_seq_item, apb_coverage) p_mon_cov_imp;

  apb_seq_item mon_inputs;
  apb_seq_item mon_outputs;

  covergroup cg_in;
    cp_addr: coverpoint mon_inputs.PADDR {
      bins low     = {[0:100]};
      bins medium1 = {[101:200]};
      bins high    = {[201:$]};
    }

    cp_wdata: coverpoint mon_inputs.PWDATA {
      bins low   = {[0:32'h2000]};
      bins other = {[32'h2001:$]};
    }

    cp_pwrite: coverpoint mon_inputs.PWRITE {
      bins write = {1};
      bins read  = {0};
    }

    cp_pstrb: coverpoint mon_inputs.PSTRB {
      bins patterns[] = {[0:15]};
    }
  endgroup

  covergroup cg_out;
    cp_slverr: coverpoint mon_outputs.PSELVERR {
      bins ok  = {0};
      bins err = {1};
    }
  endgroup

  covergroup cg_cross;
    cross_rw_err: cross 
        mon_inputs.PWRITE, 
        mon_outputs.PSELVERR;
  endgroup

  function new(string name="apb_coverage", uvm_component parent=null);
    super.new(name, parent);

    a_mon_cov_imp = new("a_mon_cov_imp", this);
    p_mon_cov_imp = new("p_mon_cov_imp", this);

    cg_in    = new();
    cg_out   = new();
    cg_cross = new();
  endfunction

  function void write_active_mon_cg(apb_seq_item req);
    if (req == null) return;

    mon_inputs = req;

    cg_in.sample();

    if (mon_outputs != null)
      cg_cross.sample();
  endfunction

  function void write_passive_mon_cg(apb_seq_item req);
    if (req == null) return;

    mon_outputs = req;

    cg_out.sample();

    if (mon_inputs != null)
      cg_cross.sample();
  endfunction

endclass

