class seq_stuck0 extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_stuck0)
  
  function new(string name="Stuck at 0");
    super.new(name);
  endfunction
  
  byte i=0;
  bit [6:0]bit7[$];
  bit [9:0]bit10[$];
  
  task body();
    bit7={`bit7};
    bit10={`bit10};
    repeat(17) begin
      `uvm_info("Stuck 0","Stuck at 0 Sequence",UVM_LOW);
      foreach (bit7[j]) begin
        `uvm_do_with(req,{slv_addr==bit7[j]; bit_10==0; rd_wr==0; int_addr==i; rpt==1; wdata==8'b11111111;})
        `uvm_do_with(req,{slv_addr==bit7[j]; bit_10==0; rd_wr==1; int_addr==i; rpt==0;})
      end
      foreach (bit10[j]) begin
        `uvm_do_with(req,{slv_addr==bit10[j]; bit_10==1; rd_wr==0; int_addr==i; rpt==1; wdata==8'b11111111;})
        `uvm_do_with(req,{slv_addr==bit10[j]; bit_10==1; rd_wr==1; int_addr==i; rpt==0;})
      end
      i++;
    end
  endtask
  
endclass

class seq_stuck1 extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_stuck1)
  
  function new(string name="Stuck at 1");
    super.new(name);
  endfunction
  
  byte i=0;
  bit [6:0]bit7[$];
  bit [9:0]bit10[$];
  
  task body();
    bit7={`bit7};
    bit10={`bit10};
    repeat(17) begin
      `uvm_info("Stuck 1","Stuck at 1 Sequence",UVM_LOW);
      foreach (bit7[j]) begin			
        `uvm_do_with(req,{slv_addr==bit7[j]; bit_10==0; rd_wr==0; int_addr==i; rpt==1; wdata==0;})
        `uvm_do_with(req,{slv_addr==bit7[j]; bit_10==0; rd_wr==1; int_addr==i; rpt==0;})
      end
      foreach (bit10[j]) begin
        `uvm_do_with(req,{slv_addr==bit10[j]; bit_10==1; rd_wr==0; int_addr==i; rpt==1; wdata==0;})
        `uvm_do_with(req,{slv_addr==bit10[j]; bit_10==1; rd_wr==1; int_addr==i; rpt==0;})
      end
      i++;
    end
  endtask
  
endclass