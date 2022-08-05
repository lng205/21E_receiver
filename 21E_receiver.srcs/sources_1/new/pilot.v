`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/06 19:27:39
// Design Name: 
// Module Name: pilot
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pilot(
input	clk,
input	rst_n,
input	sig,
output reg flag_pilot
    );

//clk
parameter PILOT_HALF_PERIOD = 499;
reg pilot_clk;	//100kHz
reg [9:0] pilot_clk_cnt;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		pilot_clk <= 0;
		pilot_clk_cnt <= 0;
	end
	else begin
		if(pilot_clk_cnt >= PILOT_HALF_PERIOD) begin
			pilot_clk <= ~pilot_clk;
			pilot_clk_cnt <= 0;
		end
		else
			pilot_clk_cnt <= pilot_clk_cnt + 1;
	end
end

wire	[63:0] freq_pilot;
reg	[63:0] freq_pilot_buf[15:0];
reg	[3:0] addr;
wire [63:0] sum;
assign sum =
freq_pilot_buf[0] + freq_pilot_buf[1] + freq_pilot_buf[2] + freq_pilot_buf[3]+
freq_pilot_buf[4] + freq_pilot_buf[5] + freq_pilot_buf[6] + freq_pilot_buf[7]+
freq_pilot_buf[8] + freq_pilot_buf[9] + freq_pilot_buf[10] + freq_pilot_buf[11]+
freq_pilot_buf[12] + freq_pilot_buf[13] + freq_pilot_buf[14] + freq_pilot_buf[15];
localparam FREQMAX = 64'd1_073_741_824_000_000;		//250k
always@(posedge pilot_clk or negedge rst_n) begin
	if(!rst_n) begin
		addr <= 0;
		flag_pilot <= 0;
		freq_pilot_buf[addr - 1] <= FREQMAX + 1;
	end
	else begin
	   if(addr >= 15) addr <= 0;
		else addr <= addr + 1;
		freq_pilot_buf[addr] <= freq_pilot;
		if(sum <= FREQMAX) begin
			flag_pilot <= 1;
			freq_pilot_buf[addr - 1] <= FREQMAX + 1;
		end
		else flag_pilot <= 0;
	end
end

/*****************************
equal precision measurement
*****************************/
freq_meter #(999)	freq_meter_pilot_inst(//gate time = 1000/100M = 10us
.clk(clk),
.rst_n(rst_n),
.sig(sig),
.freq(freq_pilot)
);

endmodule