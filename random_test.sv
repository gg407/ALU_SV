`include "environment.sv"
program test(ALU_intf intf);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(intf);
    //setting the repeat count of generator as 5000, means to generate 5000 packets
    env.gen.count = 5000;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram