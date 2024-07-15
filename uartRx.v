module uartRx(RX, READY, READY_CLR, CLK, CLK_EN, DATA);
	input  wire RX;
	output reg  READY;
	input  wire READY_CLR;
	input  wire CLK;
	input  wire CLK_EN;
	output reg [7:0] DATA;
	
	initial begin
		READY = 1'b0; // initialize READY 0
		DATA  = 8'b0; // initalize DATA 00000000
	end
	
	parameter RX_STATE_START = 2'b00;
	parameter RX_STATE_DATA  = 2'b01;
	parameter RX_STATE_STOP  = 2'b10;
	
	reg [1:0] state   = RX_STATE_START;
	reg [3:0] sample  = 0;
	reg [3:0] pos     = 0;
	reg [7:0] scratch = 8'b0;
	
	always @(posedge CLK)
		begin
			if (READY_CLR)
				READY <= 1'b0;	// Resets ready to 0
				
			if (CLK_EN)
				begin
					case (state)
						RX_STATE_START:
							begin
								if (!RX || sample != 0)     // Start from 1st low sample
									sample <= sample + 4'b1; // Invc by 0001
								if (sample ==15)
									begin
										state   <= RX_STATE_DATA;
										pos     <= 0;
										sample  <= 0;
										scratch <= 0;
									end
							end
							
						RX_STATE_DATA:	// Start data collection
							begin
								sample  <= sample + 4'b1; //++0001
								if (sample == 4'h8)
									begin
										scratch[pos[2:0]] <= RX;
										pos               <= pos + 4'b1;
									end
								if (pos == 8 && sample ==15)
									state <= RX_STATE_STOP;
							end
							
						RX_STATE_STOP:
							begin
								if (sample == 15 || (sample >= 8 && !RX))
									begin
										state  <= RX_STATE_START;
										DATA   <= scratch;
										READY  <= 1'b1;
										sample <= 0;
									end
								else
									begin
										sample <= sample + 4'b1;
									end
							end
							
						default:
							begin
								state <= RX_STATE_START;
							end
					endcase
				end
		end
endmodule	