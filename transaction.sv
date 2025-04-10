class ALU_TRANS;
  parameter WIDTH = 5;
  rand  bit signed [WIDTH-1:0]  A,B;
        bit ALU_en,a_en,b_en;
  rand  bit [2:0] a_op;
  rand  bit [1:0] b_op;
        bit signed [WIDTH:0]   C;
        int      count; 

 //Enumerate type for opcode A
  typedef enum logic [2:0] 
 {

        ADD  = 3'b000 ,
        SUB  = 3'b001 ,
        XOR_A  = 3'b010 ,
        AND3 = 3'b011 ,
        AND4 = 3'b100 ,
        OR   = 3'b101 ,
        XNOR_A = 3'b110 ,
        NULL_A = 3'b111   

 } OP_A ;
 //Enumerate type for opcode b SET 2
 typedef enum logic [1:0] 
 {
        XOR_B       = 2'b00 ,
        XNOR_B      = 2'b01 ,
        A_MINUS_1 = 2'b10 ,
        B_PLUSE_2 = 2'b11  

 } OP_B2 ;

 //Enumerate type for opcode b SET 1
 typedef enum logic [1:0] 
 {
        NAND = 2'b00 ,
        ADD1 = 2'b01 ,
        ADD2 = 2'b10 ,
        NULL_B = 2'b11  
 
 } OP_B1 ;
  
OP_A  opcode_A;
OP_B1 opcode_b1;
OP_B2 opcode_b2;
// conistraint for hit out = 30 & 29 -30
  constraint out_c { if ((a_op == 3'b000) | (b_op == 2'b01) | (b_op == 2'b10)){
       A inside {[-15:15]}; 
       B inside {[-15:15]}; }
       } 

  constraint a_c { A inside {[-15:15]}; } 
  constraint b_c { B inside {[-15:15]}; } 

  constraint a_opcode_c { a_op inside {[0:7]}; } // change for hit null

  constraint b_opcode_c { 
                          if(b_en & a_en) b_op inside {[0:3]}; 

                    else b_op inside {[0:3]}; // change for hit null

                           } 


// Divide number of iteration equally to 3 
  function void pre_randomize();

if (count == 5)begin 
        ALU_en = 1;
        a_en   = 0;
        b_en   = 0;
        count++;
    end else begin
    if (count % 3 == 0 ) begin
       
      ALU_en = 1;
      a_en   = 1;
      b_en   = 0;

     end
   else if (count % 3 == 1) begin
      
      ALU_en = 1;
      a_en   = 0;
      b_en   = 1;
     end
    else  begin
      ALU_en = 1;
      a_en   = 1;
      b_en   = 1;
     end

      count++;
      
    end 

  
    endfunction
//postrandomize function, displaying randomized values of items 
  function void post_randomize();
    $display("--------- [Trans] post_randomize ------");
    if(ALU_en)begin
      $display("\t ALU_en  = %0b\t a_en = %0h\t b_en = %0h\t A = %0d\t B = %0d",ALU_en,a_en,b_en,A,B);
         if(ALU_en & a_en & ~b_en) begin
            opcode_A = a_op ;
            $display("\t a_op  = %0s",opcode_A.name());
          end
           if(ALU_en & b_en & ~a_en) begin
            opcode_b1 = b_op ;
            $display("\t b_op  = %0s",opcode_b1.name());
          end
           if(ALU_en & b_en & a_en) begin
            opcode_b2 = b_op ;
            $display("\t b_op  = %0s",opcode_b2.name());
          end
    end
   
    $display("-----------------------------------------");
  endfunction

endclass






