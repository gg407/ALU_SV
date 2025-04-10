`include "environment.sv"
program test(ALU_intf intf);
  
 class my_trans extends ALU_TRANS;
    
    int  count;
    
    function void pre_randomize();
      a_op.rand_mode(0);
      b_op.rand_mode(0);
      a_opcode_c.constraint_mode(0);
      b_opcode_c.constraint_mode(0);
  case (count) 
   0:begin
     ALU_en = 0;
             a_en   = 1;
             b_en   = 1;
       a_op   = 3'b111;
     end 
  1: begin
  
    ALU_en = 0;
          a_en   = 1;
          b_en   = 0;
    b_op   = 2'b11;
  end
  2: begin
  
    ALU_en = 0;
          a_en   = 0;
          b_en   = 1;
    b_op   = 2'b11;
  end
  default: begin
       ALU_en = 0;
          a_en   = 0;
          b_en   = 1;
    b_op   = 2'b11;
    end
  endcase
      count++;
    endfunction
    
  endclass

 //declaring environment instance
    environment env;
  my_trans tr;
  
  initial begin
    //creating environment
    env = new(intf);
    tr =  new();
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.count = 4;
    env.gen.trans = tr;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram