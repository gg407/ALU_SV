class generator;
  
  //declaring transaction class 
  ALU_TRANS trans;
  
  //repeat count, to specify number of items to generate
  int  repeat_count;
  int count;
  
  //mailbox, to generate and send the packet to driver
  mailbox gen2driv;
  
  //event
  event ended,drive_done;
  
  //constructor
  function new(mailbox gen2driv,event ended,event drive_done);
    //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.gen2driv = gen2driv;
    this.ended    = ended;
    this.drive_done =drive_done;
    trans = new();
  endfunction
  
  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    repeat(count) begin
      
    if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");      
    
      gen2driv.put(trans);
      $display("test no = %0d ",repeat_count);
      repeat_count++;
      @(drive_done);
    end

    -> ended; 
  endtask
  
endclass
