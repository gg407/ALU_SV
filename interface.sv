interface ALU_intf(input logic clk,rst_n);
  parameter WIDTH = 5;
  //declaring the signals
  logic signed [WIDTH-1:0] A,B;
  logic ALU_en,a_en,b_en;
  logic [2:0] a_op;
  logic [1:0] b_op;
  logic signed [WIDTH:0] C;

// Assertions

    // Assertion 1: Reset functionality
    property RESET_CHECK;
        @(posedge clk) disable iff (rst_n)  C == 0;
    endproperty
    assert property (RESET_CHECK) else $error("Reset failed: C is not zero after reset.");

    // Assertion 2: ALU_en disabled
    property ALU_EN_OFF;
      @(posedge clk) disable iff (!rst_n) !ALU_en |=> C == 0;
    endproperty
    assert property (ALU_EN_OFF) else $error("ALU_en disabled failed: C changed when ALU_en is low.");

    // Assertion 3: a_en and b_en both enabled
    property B_OP_SET_2;
        @(posedge clk) disable iff (!rst_n) ALU_en && a_en && b_en |=>
            (b_op == 2'b00 && C == (A ^ B)) ||
            (b_op == 2'b01 && C == (A ~^ B)) ||
            (b_op == 2'b10 && C == (A - 1))  ||
            (b_op == 2'b11 && C == (B + 2));
    endproperty
    assert property (B_OP_SET_2) else $error("a_en and b_en both enabled failed: C is incorrect.");

    // Assertion 4: Only a_en enabled
    property A_OP;
        @(posedge clk) disable iff (!rst_n) ALU_en && a_en && !b_en |=>
            (a_op == 3'b000 && C == (A + B))  ||
            (a_op == 3'b001 && C == (A - B))  ||
            (a_op == 3'b010 && C == (A ^ B))  ||
            (a_op == 3'b011 && C == (A & B))  ||
            (a_op == 3'b100 && C == (A & B))  ||
            (a_op == 3'b101 && C == (A | B))  ||
            (a_op == 3'b110 && C == (A ~^ B)) ||
            (a_op == 3'b111 && C == 0);
    endproperty
    assert property (A_OP) else $error("Only a_en enabled failed: C is incorrect.");

    // Assertion 5: Only b_en enabled
    property B_OP_SET_1;
      @(posedge clk) disable iff (!rst_n) ALU_en && !a_en && b_en |=>
                (b_op == 2'b00 && C == ~(A & B)) ||
            (b_op == 2'b01 && C == (A + B))  ||
            (b_op == 2'b10 && C == (A + B))  ||
            (b_op == 2'b11 && C == 0);
    endproperty
    assert property (B_OP_SET_1) else $error("Only b_en enabled failed: C is incorrect.");

    // Assertion 5: a_en and b_en both disenabled
    property  a_en_b_en_off;
      @(posedge clk) disable iff (!rst_n) ALU_en && !a_en && !b_en |=> C == $past(C);
    endproperty
    assert property (a_en_b_en_off) else $error("Only b_en enabled failed: C is incorrect.");
  
endinterface