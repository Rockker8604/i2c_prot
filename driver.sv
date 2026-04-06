class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)
  
  function new(string name="Driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual intface vif;
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual intface)::get(this,"","driver",vif))
      `uvm_fatal("No_Vif","Virtual interface not found");
  endfunction
  
  task reset_phase(uvm_phase phase);
    vif.sda=1; 
    vif.scl=1;
  endtask
  
  bit bus_busy=0, clk=0, lost=0;
  byte byte_1;
  virtual task run_phase(uvm_phase phase);
    fork
      bus_monitor();
      clock();
    join_none
    
    forever begin
      `uvm_info(get_full_name,"Waiting ",UVM_MEDIUM)
      repeat(1) begin
        if(!lost) seq_item_port.get_next_item(req);
        wait(!bus_busy);
        strt();
        clk=1;
        lost=0;
        
        if(req.bit_10)
          byte_1={5'b11110,req.slv_addr[9:8],req.rd_wr};
        else
          byte_1={req.slv_addr[6:0],req.rd_wr};
        
        drive_byte(byte_1);
        if(lost) break;
        get_ack(req.a_ack);
        if(!req.a_ack==0) break;
        
        if(req.bit_10) begin
          drive_byte({req.slv_addr[7:0]});
          if(lost) break;
          get_ack(req.a_ack);
          if(!req.a_ack==0) break;
        end
        
        drive_byte({req.int_addr});
        if(lost) break;
        get_ack(req.i_ack);
        if(!req.i_ack==0) break;
        
        if(req.rd_wr) begin
        drive_byte(8'bz);
        put_ack(); end
        
        else begin
          drive_byte(req.wdata);
          if(lost) break;
          get_ack(req.s_ack); end
        
//         break;
      end
      if(lost) continue;
      if(!req.rpt) stp();
      
      else begin
        @(negedge vif.d.scl); vif.d.sda=1;
        @(posedge vif.d.scl);
        clk=0;
        if(!lost) bus_busy=0;
      end
      #2 seq_item_port.item_done();
    end
  endtask
  
  task drive_byte(logic [7:0]dr);
    `uvm_info($sformatf({"Drive @",get_name}),$sformatf("driving %b",dr),UVM_MEDIUM)
    repeat(8) begin
      @(negedge vif.d.scl); vif.d.sda=dr[7];
//       if(!dr[7]==1'bz) begin
      @(posedge vif.d.scl);
      if(!vif.d.sda==dr[7]) begin
        `uvm_info($sformatf({"Lost _Arb @",get_name}),"Lost arbitration",UVM_LOW)
        lost=1; break;
      end
      dr=dr<<1;
    end
  endtask
  
  task get_ack(output logic ack);
    @(negedge vif.d.scl); vif.d.sda=1'bz;
    @(posedge vif.d.scl); ack=vif.d.sda;
  endtask
  
  task put_ack();
    @(negedge vif.d.scl); vif.d.sda=1'b0;
    @(posedge vif.d.scl); req.m_ack=vif.d.sda;
  endtask
  
  task strt();
    `uvm_info($sformatf({"Start @",get_name}),"Start",UVM_MEDIUM)
    if(!vif.d.sda) vif.d.scl=1;
    vif.d.scl=1; #1 vif.d.sda=0;
  endtask
  
  task stp();
//     if(lost) return;
    @(negedge vif.d.scl); vif.d.sda=0;
    @(posedge vif.d.scl); clk=0; #1 vif.d.sda=1;
    `uvm_info(get_full_name,"Stop",UVM_MEDIUM)
  endtask
  
  task clock();
    forever begin
      wait(clk);
      #2 vif.d.scl<=0;
      #2 vif.d.scl<=1;
      wait(vif.d.scl);
    end
  endtask
  
  task bus_monitor();
    forever
      begin
        fork
          begin
            @(negedge vif.m.sda);
            if(vif.m.scl) begin bus_busy=1;
              `uvm_info(get_full_name,"bus occupied",UVM_MEDIUM) end
          end
          begin
            @(posedge vif.m.sda);
            if(vif.m.scl) begin bus_busy=0;
              `uvm_info(get_full_name,"bus released",UVM_MEDIUM) end
          end
        join
      end
  endtask
  
endclass