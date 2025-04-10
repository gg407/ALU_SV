//including interfcae and testcase files
`include "interface.sv"

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
`include "normal_test.sv"
//`include "bad_test.sv"
//----------------------------------------------------------------

/* seed 20   5000

  seed 30   5000



*/
module tbench_top;
  
  //clock and rst_n signal declaration
  bit clk;
  logic rst_n;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    rst_n = 0;
    #5; rst_n = 1;
    #5; rst_n = 0;
    #5; rst_n = 1;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  ALU_intf intf(clk,rst_n);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  ALU DUT (
    .clk(intf.clk),
    .rst_n(intf.rst_n),
    .A(intf.A),
    .B(intf.B),
  .ALU_en(intf.ALU_en),
  .a_en(intf.a_en),
  .b_en(intf.b_en),
  .a_op(intf.a_op),
  .b_op(intf.b_op),
  .C(intf.C)
   
   );
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
