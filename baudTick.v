// Baudrate generator to divide 50MHz clock to 115200 baud
// RX clk oversamples by 16

module baudTick(CLK, RX_TICK, TX_TICK);
	input  wire CLK;
	output wire RX_TICK;
	output wire TX_TICK;
	
	// 50,000,000/115,200 = 435 CLK pulses per bit
	parameter RX_ACC_MAX   = 50000000 / (115200 * 16);
	parameter TX_ACC_MAX   = 50000000 / 115200;
	parameter RX_ACC_WIDTH = $clog2(RX_ACC_MAX);
	parameter TX_ACC_WIDTH = $clog2(TX_ACC_MAX);
	
	reg [RX_ACC_WIDTH-1:0] rx_acc = 0;
	reg [TX_ACC_WIDTH-1:0] tx_acc = 0;
	
	assign RX_TICK = (rx_acc == 5'd0);
	assign TX_TICK = (tx_acc == 9'd0);
	
	always @(posedge CLK)
		begin
			if (rx_acc == RX_ACC_MAX[RX_ACC_WIDTH-1:0])
				rx_acc <= 0;
			else
				rx_acc <= rx_acc + 5'b1; // increment by 00001
		end
	
	always @(posedge CLK)
		begin
			if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH-1:0])
				tx_acc <= 0;
			else
				tx_acc <= tx_acc + 9'b1; // Increment by 000000001
		end
endmodule 