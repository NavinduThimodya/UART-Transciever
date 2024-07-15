module uart(DATA_IN, WR_EN, CLK, TX, TX_BUSY, RX, READY, READY_CLR, DATA_OUT, LEDR, TX2, rxen, txen);
	input  wire [7:0] DATA_IN;
	input  wire WR_EN;
	input  wire CLK;
	output wire TX;
	output wire TX_BUSY;
	input  wire RX;
	output wire READY;
	input  wire READY_CLR;
	output wire [7:0] DATA_OUT;
	output wire [7:0] LEDR;
	output wire TX2;
	output wire rxen;
	output wire txen;
	
	assign LEDR = DATA_OUT;
	assign TX2  = TX;
	wire txclk_en, rxclk_en;
	assign rxen = rxclk_en;
	assign txen = txclk_en;
	
	baudTick baudTick1(
		.CLK(CLK),
		.RX_TICK(rxclk_en),
		.TX_TICK(txclk_en)
	);
	
	uartTx Tx1(
		.DIN(DATA_IN), 
		.WR_EN(WR_EN), 
		.CLK(CLK), 
		.CLK_EN(txclk_en), 
		.TX(TX), 
		.TX_BUSY(TX_BUSY)
	);
	
	uartRx Rx1(
		.RX(RX), 
		.READY(READY), 
		.READY_CLR(READY_CLR), 
		.CLK(CLK), 
		.CLK_EN(rxclk_en), 
		.DATA(DATA_OUT)
	);	
endmodule 