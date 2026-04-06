class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  seq_item mon_item;
  virtual intface vif;
  uvm_analysis_port #(seq_item) mnport;
  
  function new(string name="Monitor", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual intface)::get(this,"","monitor",vif))
      `uvm_fatal("No_Vif","Virtual interface not found");
    mnport=new("Monitor port",this);
  endfunction
  
  byte byte_1;
  virtual task run_phase(uvm_phase phase);
    forever begin
      `uvm_info(get_full_name,"Monitor started",UVM_MEDIUM)
      mon_item=new();
//       start condition
      forever begin
        @(negedge vif.m.sda);
        if(vif.m.scl) break;
      end
//       $display("Start",$time,"ns");
      
/*    addr   */ read_byte(byte_1);
      if(byte_1[7:3]==5'b11110)
      {mon_item.slv_addr[9:8],mon_item.rd_wr}=byte_1[2:0];
      else
          {mon_item.slv_addr[6:0],mon_item.rd_wr}=byte_1;
      
/* addr ack  */ get_ack(mon_item.a_ack);
//                 $display($time,"ns Ack",mon_item.a_ack);
                if(mon_item.a_ack) begin 
                  mnport.write(mon_item);
                  continue;
                end
//       $display($time,"ns Got addr_Ack");
      
        if(byte_1[7:3]==5'b11110) begin
          mon_item.bit_10=1;
/*    addr   */ read_byte(mon_item.slv_addr[7:0]);
/* addr ack  */ get_ack(mon_item.a_ack);
//                 $display($time,"ns Ack",mon_item.a_ack);
                if(mon_item.a_ack) begin 
                  mnport.write(mon_item);
                  continue;
                end
        end
        
/*  int_addr */ read_byte(mon_item.int_addr);
/*  int_ack  */ get_ack(mon_item.i_ack);
//                 $display($time,"ns int_Ack",mon_item.i_ack);
                if(mon_item.i_ack) begin 
                  mnport.write(mon_item);
                  continue;
                end
//       $display($time,"ns Got int_addr_Ack");
      
                if(mon_item.rd_wr) begin
/*   rdata   */ read_byte(mon_item.rdata);
/* rdata ack */ get_ack(mon_item.m_ack); end
            
                else begin
/*   wdata   */ read_byte(mon_item.wdata);
/* wdata ack */ get_ack(mon_item.s_ack); end
            
// /*   stop    */ @(negedge vif.m.scl); vif.m.sda=0;
//                @(posedge vif.m.scl); #1 vif.m.sda=1;
      mnport.write(mon_item);
    end
  endtask
  
  task read_byte(output logic [7:0]dr);
    repeat(8) begin
      dr=dr<<1;
      @(posedge vif.m.scl); dr[0]=vif.m.sda;
    end
  endtask
  
  task get_ack(output logic ack);
    @(posedge vif.m.scl); ack=vif.m.sda;
  endtask
        
endclass