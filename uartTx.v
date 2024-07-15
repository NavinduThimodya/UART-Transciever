module uartTx(DIN, WR_EN, CLK, CLK_EN, TX, TX_BUSY);
	input  wire [7:0] DIN;	// Input Register
	input  wire WR_EN;		// Enable to start
	input  wire CLK;			
	input  wire CLK_EN;		// CLK for the transmitter
	output reg  TX;			// Register to hold the tranmitting bit
	output wire TX_BUSY;		// Busy signal
	
	initial begin
		TX = 1'b1;           // Initialize TX to 1 to begin transmit
	end
	
	// TX States
	parameter TX_STATE_IDLE  = 2'b00;
	parameter TX_STATE_START = 2'b01;
	parameter TX_STATE_DATA  = 2'b10;
	parameter TX_STATE_STOP  = 2'b11;
	
	reg [7:0] data  = 8'h00;         // Data Register
	reg [2:0] pos   = 3'h0;          // Bit position
	reg [1:0] state = TX_STATE_IDLE; // TX State
	
	
	always @(posedge CLK)
		begin
			case (state)
				TX_STATE_IDLE:
					begin
						if (~WR_EN)
							begin
								state <= TX_STATE_START;
								data  <= DIN;  // Get current data in
								pos   <= 3'h0; // Assign bit position to 0
							end
					end
					
				TX_STATE_START:
					begin
						if (CLK_EN)
							begin
								TX    <= 1'b0; // Transmission had started
								state <= TX_STATE_DATA;
							end
					end
					
				TX_STATE_DATA:
					begin
						if (CLK_EN)
							begin
								if (pos == 3'h7) // Assign data till all transmitted
									state <= TX_STATE_STOP;
								else
									pos   <= pos + 3'h1; // Increment by 001
								TX <= data[pos];
							end
					end
				
				TX_STATE_STOP:
					begin
						if (CLK_EN)
							begin
								TX    <= 1'b1; // TX=1, transmit ended
								state <= TX_STATE_IDLE;
							end
					end
					
				default:
					begin
						TX    <= 1'b1;			// Always begin with TX 1 after transmit end
						state <= TX_STATE_IDLE;
					end
			endcase
		end
		
		assign TX_BUSY = (state != TX_STATE_IDLE);
endmodule 