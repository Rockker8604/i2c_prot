// Code your design here
module Slave_10b #(parameter slv_addr=10'b0000000001) (
	inout wire SDA,
    input wire SCL);
  
  parameter FRIST_BYTE	    = 4'b0000;
  parameter READ_WRITE1     = 4'b0001;
  parameter ADDR_ACK1 		= 4'b0010;
  parameter SECOND_BYTE	    = 4'b0011;
  parameter ADDR_ACK2 		= 4'b0100;
  parameter INT_ADDR 		= 4'b0101;
  parameter INT_ACK 		= 4'b0110;
  parameter DATA 			= 4'b0111;
  parameter DATA_ACK   		= 4'b1000;
  parameter READ_DATA   	= 4'b1001;
  parameter READ_DATA_ACK  	= 4'b1010;
  parameter STOP 			= 4'b1011;
  
  reg [3:0] state 			= 4'b0000;
  
  reg [9:0] slaveAddress 	= slv_addr;
  reg [6:0] addr			= 7'b000_0000;
  reg [7:0] addr1			= 7'b000_0000;
  reg [6:0] addressCounter 	= 7'b000_0000;
  
  reg [7:0] int_addr;
  reg [7:0] intCounter;
  
  reg [7:0] data[15:0];
  reg [7:0] t_data			= 0;
  reg [6:0] dataCounter 	= 7'b000_0000;
  
  reg readWrite	= 1'b0;
  reg start 	= 0;
  reg ack		= 0;
  
  assign SDA = (ack == 1 ) ? 0 : 'b1z;
  
  always @(negedge SDA) begin
    if ((SCL == 1)) 
    begin
		start <= 1;
        addressCounter <= 0;
        intCounter <= 0;
      	dataCounter <= 0;
        state <= 0;
	end
  end
  
  always @(posedge SDA) begin
    if (SCL == 1)
      begin
        start <= 0;
		state <= FRIST_BYTE;
	  end
	end
  
  always @(posedge SCL)
    begin
    	if (start == 1)
    	begin
    	  case (state)
      FRIST_BYTE: 
    	      begin
                addr[6-addressCounter] <= SDA;
    	        addressCounter <= addressCounter + 1;
                if (addressCounter == 6) 
    	            begin
                      state<=READ_WRITE1;
                      addressCounter<=0;
                    end
     	     end
     READ_WRITE1:
       begin
         readWrite <= SDA;
         state <= ADDR_ACK1;
       end
       ADDR_ACK1:
       begin
         if(addr[6:2]==5'b11110)
           state<=SECOND_BYTE;
        else begin
          state<=STOP;
          addressCounter<=0; end
       end
     
     SECOND_BYTE:
       begin
          addr1[7-addressCounter] <= SDA;
          addressCounter <= addressCounter + 1;
         if (addressCounter == 7) 
    	            begin
                      state<=ADDR_ACK2;
                      addressCounter<=0;
                    end
       end
     ADDR_ACK2:
       begin
         if ({addr[1:0],addr1}==slaveAddress)
               state <= INT_ADDR;
         else
               state<=STOP; 
       end    
      INT_ADDR:
              begin
                int_addr[7-intCounter] <= SDA;
    	        intCounter <= intCounter + 1;
                if (intCounter == 7) 
    	            begin
     	             state <= INT_ACK;
     	           end
              end
      INT_ACK:
              begin
                if(int_addr<16) begin//int addr
                  if (readWrite==0)
                    state <= DATA;
                  else 
                    state<=READ_DATA;
                end
                else begin
                  state<=STOP;
                  intCounter=0;
                end
              end
      DATA:
              begin
//                 ack <= 0;
                t_data[7-dataCounter] <= SDA;
    	        dataCounter <= dataCounter + 1;
                if (dataCounter == 7) 
    	            begin
//                       data[int_addr] <= t_data;
     	             state <= DATA_ACK;
     	           end
              end
      DATA_ACK:
     	      begin
                data[int_addr] <= t_data;
//                ack <= 1;
                state <= STOP;
    	      end
      READ_DATA:
              begin
                dataCounter<=0;
    	        dataCounter <= dataCounter + 1;
                if (dataCounter == 7) 
    	            begin
     	             state <= READ_DATA_ACK;
     	           end
              end
      READ_DATA_ACK:
              begin
                state <= STOP;
              end
      STOP:
              begin
//                 ack <= 0;
                state <= STOP;
              end
    	  endcase
    	end
    end
  
  always@(negedge SCL) begin
    if (start == 1) begin
      case (state)
    ADDR_ACK1:
       begin
         if(addr[6:2]==5'b11110)
           ack<=1;
        else ack<=0;
       end
    SECOND_BYTE:
      ack<=0;
    ADDR_ACK2:
      begin
        if ({addr[1:0],addr1}==slv_addr)
          ack<=1;
        else ack<=0;
      end
    INT_ADDR:
              ack <= 0;
    INT_ACK:
              if (int_addr<16) ack <= 1;
              else ack <= 0;
    DATA:
              ack <= 0;
    DATA_ACK:
              ack <= 1;
    READ_DATA:
              ack <= !data[int_addr][7-dataCounter];
    STOP:
              ack <= 0;
      endcase
    end
  end
endmodule
