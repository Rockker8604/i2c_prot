class coverage extends uvm_subscriber #(seq_item);
  `uvm_component_utils(coverage)
  
  uvm_analysis_imp #(seq_item,coverage) cvport;
  seq_item sq[$];
  seq_item s;
  
  covergroup i2c_cov;
    addr: 		coverpoint s.slv_addr {bins slv[] = {`bit7,`bit10};}
    mode:		coverpoint s.bit_10   {bins modes[] = {0,1};}
    registers:  coverpoint s.int_addr {bins registr[] = {[0:15]};}
    read_write: coverpoint s.rd_wr	  {bins rw[] = {0,1};}
    full_rw:	cross addr,registers,read_write;
    
    data:		coverpoint s.wdata    {bins data[] = {[1:$]};
                                       bins data0s={0};
                                       bins data1s={255};}
    stuck:      cross addr,registers,data  {bins zeros=binsof(data.data0s);
                                            bins ones=binsof(data.data1s);
                                            ignore_bins ignore=binsof(data.data);}
    acknowledge:coverpoint {s.a_ack,s.i_ack} {bins ack[] = {[0:2]};
                                              illegal_bins ack_err = {3};}
  endgroup
  
  function new(string name="coverage", uvm_component parent);
    super.new(name,parent);
    i2c_cov=new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    cvport=new("Coverage port",this);
  endfunction
  
  function void write(seq_item t);
    sq.push_back(t);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
//       seq_item s;
      wait(sq.size()>0);
      s=sq.pop_front();
      i2c_cov.sample();
    end
  endtask
  
  function void extract_phase(uvm_phase phase);
    $display("\n\n\t|-----------------------Coverage Report-----------------------");
    $display("\t| Slaves covered................ %f", i2c_cov. addr       .get_coverage);
    $display("\t| Address modes covered......... %f", i2c_cov. mode       .get_coverage);
    $display("\t| Reda & Write covered.......... %f", i2c_cov. read_write .get_coverage);
    $display("\t| Ack & Nack covered............ %f", i2c_cov. acknowledge.get_coverage);
    $display("\t| Internal registers covered.... %f", i2c_cov. registers  .get_coverage);
    $display("\t| Data covered.................. %f", i2c_cov. data       .get_coverage);
    $display("\t| Cross coverage of registers, read & write...... %f",i2c_cov.full_rw.get_coverage);
    $display("\t| Walking 1's & 0's............. %f",i2c_cov.stuck.get_coverage);
    $display("\t| Total Coverage................ %f",$get_coverage);
    $display("\t|------------------------------------------------------------\n\n");
  endfunction
  
endclass