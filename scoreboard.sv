class scoreboard;
   //creating mailbox handle
  mailbox mon2scb;
  //used to count the number of transactions
  int no_transactions;
  //used to count the number of sucess and failed testcaces
  int num_success ;
  int num_errors  ;
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  //stores wdata and compare rdata with stored data
  task main;
    ALU_TRANS trans;
    bit signed [5:0] expected_c;
    forever begin
      mon2scb.get(trans);
     if (trans.ALU_en)begin
      // set 2
        if (trans.a_en && trans.b_en)begin
          case (trans.b_op)
            2'b00  : expected_c = trans.A ^  trans.B ;
            2'b01  : expected_c = trans.A ~^ trans.B ;
            2'b10  : expected_c = trans.A - 1  ;
            2'b11  : expected_c = trans.B + 2  ;
          endcase

        end 

        else if (trans.a_en & ~trans.b_en)begin
          case (trans.a_op)
            3'b000  : expected_c = trans.A + trans.B  ;
            3'b001  : expected_c = trans.A - trans.B  ;
            3'b010  : expected_c = trans.A ^ trans.B  ;
            3'b011  : expected_c = trans.A & trans.B  ;
            3'b100  : expected_c = trans.A & trans.B  ;
            3'b101  : expected_c = trans.A | trans.B  ;
            3'b110  : expected_c = trans.A ~^ trans.B ;
            3'b111  : expected_c = 0    ;
          endcase

        end
      // set 1
      else if (trans.b_en & ~trans.a_en)begin
        case (trans.b_op)
          2'b00  : expected_c = ~(trans.A & trans.B);
          2'b01  : expected_c =  trans.A + trans.B  ;
          2'b10  : expected_c =  trans.A + trans.B  ;
          2'b11  : expected_c = 0  ;
        endcase

      end 
      else begin
        expected_c = expected_c;
      end

  end else begin
      expected_c = 0;
    end
 
  if (trans.C == expected_c) begin
     $display("Testcase_no: %0d is Sucess && Actual = %0d && Expected = %0d",no_transactions,trans.C,expected_c;
                num_success++;
    end else begin
          $display("Testcase_no: %0d is Faild ! && Actual = %0d && Expected = %0d",no_transactions,trans.C,expected_c);
                num_errors++; 
    end
        no_transactions++;
    end 
  endtask
  
endclass

