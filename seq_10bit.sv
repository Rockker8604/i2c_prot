class seq_10bit extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_10bit)
  
  function new(string name="10 bit address");
    super.new(name);
  endfunction
  
  byte i;
  bit [9:0]s;
  task body();
    repeat(10) begin
      `uvm_info("10-bit","10 bit slave sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr inside {`bit10}; rd_wr==0; bit_10==1; rpt==0;})
      s=req.slv_addr;
      i=req.int_addr;
      `uvm_do_with(req,{slv_addr==s; rd_wr==1; bit_10==1; rpt==0; req.int_addr==i;})
    end
  endtask
  
endclass