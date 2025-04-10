`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage_collector.sv"
class environment;
  
  //generator and driver instance
  generator          gen;
  driver            driv;
  monitor            mon;
  scoreboard         scb;
  coverage_collector cov;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  mailbox mon2cov;
  //event for synchronization between generator and test
  event gen_ended,drive_done;
  
  //virtual interface
  virtual ALU_intf alu_vif;
  
  //constructor
  function new(virtual ALU_intf alu_vif);
    //get the interface from test
    this.alu_vif = alu_vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb  = new();
    mon2cov  = new();
    
    //creating generator and driver
    gen  = new(gen2driv,gen_ended,drive_done);
    driv = new(alu_vif,gen2driv,drive_done);
    mon  = new(alu_vif,mon2scb,mon2cov);
    scb  = new(mon2scb);
    cov  = new(mon2cov);
  endfunction
  
  task pre_test();
    driv.reset();
    driv.reset();
  $display("out is rest and = %0d",alu_vif.C);
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    mon.main();
    scb.main();
    cov.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
   wait(gen.repeat_count == scb.no_transactions);
   $display("-----------------------------------------");
   $display("--------- TestCaces are Finished ---------");
   $display("-----------------------------------------");
   $display("Total of SuccessTestcases are  %0d ",scb.num_success);
   $display("Total of FailedTestcases  are  %0d ",scb.num_errors);
    

   $display("-----------------------------------------");
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass

