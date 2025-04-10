class driver;
  
  //used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual ALU_intf alu_vif;
  
  //creating mailbox handle
  mailbox gen2driv;
  
  // event
  event drive_done ;
  
  //constructor
  function new(virtual ALU_intf alu_vif,mailbox gen2driv, event drive_done);
    //getting the interface
    this.alu_vif = alu_vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
     this.drive_done =drive_done;
  endfunction

 //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(!alu_vif.rst_n);
    $display("--------- [DRIVER] Reset Started ---------");
      alu_vif.ALU_en <= 0;
      alu_vif.a_en <= 0; 
      alu_vif.b_en <= 0;       
    wait(alu_vif.rst_n);
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  //drivers the transaction items to interface signals
  task drive;
      ALU_TRANS trans;
      alu_vif.ALU_en <= 0;
      alu_vif.a_en <= 0; 
     alu_vif.b_en <= 0; 
      gen2driv.get(trans);
      $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
      @(posedge alu_vif.clk);
        alu_vif.A <= trans.A;
        alu_vif.B <= trans.B;
        alu_vif.ALU_en <= trans.ALU_en;
        alu_vif.a_en <= trans.a_en;
        alu_vif.b_en <= trans.b_en;
         $display("\t ALU_en  = %0b\t a_en = %0h\t b_en = %0h\t A = %0d\t B = %0d",trans.ALU_en,trans.a_en,trans.b_en,trans.A,trans.B);
      if(trans.a_en & ~trans.b_en) begin
            alu_vif.a_op <= trans.a_op;
            $display("\t a_op  = %0s",trans.opcode_A.name());
      end
         if(trans.a_en & trans.b_en) begin
              alu_vif.b_op <= trans.b_op;
              $display("\t b_op  = %0s",trans.opcode_b2.name());
      end
         if(~trans.a_en & trans.b_en) begin
              alu_vif.b_op <= trans.b_op;
              $display("\t b_op  = %0s",trans.opcode_b1.name());
      end
       if(~trans.a_en & ~trans.b_en) begin
              alu_vif.b_op <= trans.b_op;
              $display("\t b_op  = %0s",trans.opcode_b1.name());
      end
    
      $display("-----------------------------------------");
      no_transactions++;
      -> drive_done;
  endtask
  
  // main function
  
 task main;
    forever begin
      fork
        //Thread-1: Waiting for reset
        begin
          wait(!alu_vif.rst_n);
        end
        //Thread-2: Calling drive task
        begin
          forever
            drive();
        end
      join_any
      disable fork;
    end
  endtask
        
endclass


