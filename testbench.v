module testbench();

	reg [7:0] data = 0;
	reg clk = 0;
	reg enable = 0;

	wire Tx_busy;
	wire rdy;
	wire [7:0] Rx_data;

	wire loopback;
	reg ready_clr = 0;
	
	wire TX2;
	wire [7:0] LEDR;
	wire rxen, txen;
	wire ready;
	
	uart uart1(
		.DATA_IN(data), 
		.WR_EN(enable), 
		.CLK(clk), 
		.TX(loopback), 
		.TX_BUSY(Tx_busy), 
		.RX(loopback), 
		.READY(ready), 
		.READY_CLR(ready_clr), 
		.DATA_OUT(Rx_data),
		.LEDR(LEDR),
		.TX2(TX2),
		.rxen(rxen),
		.txen(txen)
	);
	
	initial begin
			$dumpfile("uart.vcd");
			$dumpvars(0, testbench);
			enable <= 1'b1;
			#2 enable <= 1'b0;
	end

	always begin
		#1 clk = ~clk;
	end

	always @(posedge ready) 
		begin
			#2 ready_clr <= 1;
			#2 ready_clr <= 0;
			if (Rx_data != data) 
				begin
					$display("FAIL: rx data %x does not match tx %x", Rx_data, data);
					$finish;
				end 
			else 
				begin
					if (Rx_data == 8'h2) 
						begin //Check if received data is 11111111
							$display("SUCCESS: all bytes verified");
							$finish;
						end
					
					data      <= data + 1'b1;
					enable    <= 1'b1;
					#2 enable <= 1'b0;
				end
		end
endmodule
