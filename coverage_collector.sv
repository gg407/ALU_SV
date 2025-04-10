class coverage_collector;
    
    //creating mailbox handle
    mailbox mon2cov;
    //creating ALU_TRANS handle
    ALU_TRANS trans;


         covergroup cg_alu;
        // Coverpoints for A and B inputs
        cp_A: coverpoint trans.A {
            bins pos [] = {[1:15]};
        bins zero   = {0}; 
            bins neg [] = {[-15:-1]};
        }
        cp_B: coverpoint trans.B  {
            bins pos [] = {[1:15]};
        bins zero   = {0}; 
            bins neg [] = {[-15:-1]};
        }
      cp_ALU_OUT: coverpoint trans.C  {
            bins pos  [] = {[1:30]};
        bins zero   = {0}; 
            bins neg  [] = {[-30:-1]};
        }

        // Coverpoints for control signals
        cp_ALU_en: coverpoint trans.ALU_en  {
        bins    ALU_EN_1 = {1};
        ignore_bins ALU_EN_0 = {0};
    
    }
        cp_a_en  : coverpoint trans.a_en{bins A_EN [] = {0,1};}
        cp_b_en  : coverpoint trans.b_en{bins B_EN [] = {0,1};}

        // Coverpoints for operation codes
        cp_a_op: coverpoint trans.a_op iff (trans.a_en && ~trans.b_en ){
            bins     op_add    = {3'b000};
            bins     op_sub    = {3'b001};
            bins     op_xor_a  = {3'b010};
            bins     op_and    = {3'b011};
            bins     op_and2   = {3'b100};
            bins     op_or     = {3'b101};
            bins     op_xnor_a = {3'b110};
            //illegal_bins op_null_a = {3'b111};
        }
        cp_b_op_set_2: coverpoint trans.b_op iff (trans.a_en && trans.b_en ){
            bins op_xor_b  = {2'b00};
            bins op_xnor_b = {2'b01};
            bins op_dec    = {2'b10};
            bins op_inc    = {2'b11};
        }
      cp_b_op_set_1: coverpoint trans.b_op iff (~trans.a_en && trans.b_en ){
            bins    op_nand   = {2'b00};
            bins    op_add1   = {2'b01};
            bins    op_add2   = {2'b10};
           //illegal_bins op_null_b = {2'b11};
      
        }

        // Cross coverage between control signals
        cross_control_ops: cross cp_a_en, cp_b_en;
     // Cross coverage between A and B
        cross_A_B:         cross cp_A, cp_B;
    endgroup

   //constructor
  function new(mailbox mon2cov);
    //getting the mailbox handles from  environment 
    this.mon2cov = mon2cov;
        cg_alu = new();
  endfunction



  //stores wdata and compare rdata with stored data
  task main;
    forever begin
      mon2cov.get(trans);
      cg_alu.sample();
  
    end 
  endtask


  
endclass 

