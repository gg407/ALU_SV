/*
	My Directory 
	/home/svgpdv25moadel/ALU_SV

*/
module ALU #(parameter WIDTH = 5)(

	input  logic signed [WIDTH-1:0] A,B,
	input  logic  ALU_en,a_en,b_en,
	input  logic  clk,rst_n,
	input  logic  [2:0] a_op,
	input  logic  [1:0] b_op,
	output logic signed  [WIDTH:0] C
);



	always @(posedge clk or negedge rst_n) begin
		if (~rst_n)begin
			C <= 6'b0;
		end else begin
			if (ALU_en)begin
			// set 2
			if (a_en && b_en)begin
				case (b_op)
					2'b00  : C <= A ^  B ;
					2'b01  : C <= A ~^ B ;
					2'b10  : C <= A - 1  ;
					2'b11  : C <= B + 2  ;
				endcase

			end	

			else if (a_en)begin
				case (a_op)
					3'b000  : C <= A + B  ;
					3'b001  : C <= A - B  ;
					3'b010  : C <= A ^ B  ;
					3'b011  : C <= A & B  ;
					3'b100  : C <= A & B  ;
					3'b101  : C <= A | B  ;
					3'b110  : C <= A ~^ B ;
					3'b111  : C <= 'd0    ;
				endcase

			end
			// set 1
			else if (b_en)begin
				case (b_op)
					2'b00  : C <= ~(A & B);
					2'b01  : C <=  A + B  ;
					2'b10  : C <=  A + B  ;
					2'b11  : C <= 'd0   ;
				endcase

			end	
			else begin
			C <= C;
			end 

		end  /* ALU_EN_OFF*/ else begin
								C <= 0;
							end
		
		end
	end



endmodule
