class monitor;
  
  //creating virtual interface handle
  virtual ALU_intf alu_vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  mailbox mon2cov;
  
  //constructor
  function new(virtual ALU_intf alu_vif,mailbox mon2scb,mailbox mon2cov);
    //getting the interface
    this.alu_vif = alu_vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      ALU_TRANS trans;
      trans = new();
      @(posedge alu_vif.clk);
        trans.ALU_en  = alu_vif.ALU_en;
        trans.A    = alu_vif.A;
        trans.B    = alu_vif.B;
        trans.a_en = alu_vif.a_en;
        trans.b_en = alu_vif.b_en;
        trans.a_op = alu_vif.a_op;
        trans.b_op = alu_vif.b_op; 
        trans.C    =  alu_vif.C;     
        mon2scb.put(trans);
        mon2cov.put(trans);

    end
  endtask
  
endclass