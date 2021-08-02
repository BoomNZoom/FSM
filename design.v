// Code your design here
module button(clk, in, out);
	
 	input clk;
  	input in;
	output out;
	reg r1,r2,r3;
	

	always@(posedge clk)
	begin
		
		r1 <= in;
	    r2 <= r1;
		r3 <= r2;
	
	end

	assign out = ~r3 & r2;

endmodule



module lock(clk,reset_in,b0_in,b1_in,out,hex_display);
	input clk,reset_in,b0_in,b1_in;
	output out;
	output[3:0] hex_display;
	wire reset,b0,b1;//sync + convert to pulses the push buttons

	parameter S_RESET = 0;
	parameter S_0 = 1;
	parameter S_01 = 2;
	parameter S_010 = 3;
	parameter S_0101 = 4;
	parameter S_01011 = 5;

	reg[2:0] state,next_state;
	
	always@(*) begin
      if(reset) next_state = S_RESET;
		else case(state)
			S_RESET:next_state = b0?S_0:b1?S_RESET:state;

			S_0:next_state = b0?S_0:b1?S_01:state;

			S_01:next_state = b0?S_010:b1?S_01:state;

			S_010:next_state = b0?S_0:b1?S_0101:state;

			S_0101:next_state = b0?S_010:b1?S_01011:state;

			S_01011:next_state = b0?S_0:b1?S_RESET:state;

			default:next_state = S_RESET;

		endcase

	end

	
	always @(posedge clk) state <= next_state;
	assign out = (state == S_01011);
    assign hex_display = {1'b0,state};
  
  
endmodule