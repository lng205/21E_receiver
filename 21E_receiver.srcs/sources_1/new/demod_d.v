`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 19:33:35
// Design Name: 
// Module Name: demod_d
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

module demod_d(
input clk,
input rst_n,
input sig,
output reg [3:0] d1,
output reg [3:0] d2,
output reg [3:0] d3,
output reg [3:0] d4
    );
pilot pilot_inst(
.clk(clk),
.rst_n(rst_n),
.sig(sig),
.flag_pilot(flag_pilot)
);

/****************************************************************************************
tdma_clk
****************************************************************************************/
localparam TDMA_HALF_PERIOD = 39999;
localparam DELAY = 3500;
reg [15:0] tdma_clk_cnt;
reg flag_pilot_buf;
reg tdma_clk;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		tdma_clk <= 0;
		tdma_clk_cnt <= 0;
		flag_pilot_buf <= 0;
	end
	else begin
		flag_pilot_buf <= flag_pilot;
		if(~flag_pilot_buf & flag_pilot) begin	//if flag posedge -> set tdma_clk to synchronous
			tdma_clk <= 0;
			tdma_clk_cnt <= TDMA_HALF_PERIOD - DELAY;
		end
		else if(tdma_clk_cnt >= TDMA_HALF_PERIOD) begin
				tdma_clk <= ~tdma_clk;
				tdma_clk_cnt <= 0;
		end
		else
			tdma_clk_cnt <= tdma_clk_cnt + 1;
	end
end

/****************************************************************************************
reset freq measureing at tdma_clk posedge
****************************************************************************************/
reg tdma_clkbuf;
reg freq_meter_rst_n;
reg [4:0] freq_meter_rst_n_cnt;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		freq_meter_rst_n <= 1;
		freq_meter_rst_n_cnt <= 0;
	end
	else begin
		tdma_clkbuf <= tdma_clk;
		if(~tdma_clkbuf & tdma_clk)	//posedge
			freq_meter_rst_n <= 0;
		else if(freq_meter_rst_n == 0) begin
			if(freq_meter_rst_n_cnt >= 5'd30) begin
				freq_meter_rst_n_cnt <= 0;
				freq_meter_rst_n <= 1;
			end
			else freq_meter_rst_n_cnt <= freq_meter_rst_n_cnt + 1;
		end
		else freq_meter_rst_n <= 1;
	end
end

wire [63:0] freq0;
freq_meter #(79599)	freq_meter_tdma_inst//gate time = 79600/100M = 796us
(
.clk(clk),
.sig(sig),
.rst_n(freq_meter_rst_n),
.freq(freq0)
);

localparam deviation_width = 13;
parameter fc = 64'd1_288_490_188_800_000; //300kHz
wire	signed [deviation_width+31:0]	 deltafreq; //fixed-point
wire signed	[deviation_width-1:0] deviation; //integer
assign deltafreq = freq0 - fc;
assign deviation = deltafreq[31] ? deltafreq[deviation_width+31:32] + 1 : deltafreq[deviation_width+31:32];

wire signed [3:0] d_buf;
mult_gen_1 mult1_inst (
.A(deviation),  // input wire [12 : 0] A
.P(d_buf)  // output wire [3 : 0] P
);
wire signed [3:0] d;
assign d = 5 - d_buf;

/****************************************************************************************
tdma recive
****************************************************************************************/
reg [15:0] tdma_cnt;
always@(posedge tdma_clk or posedge flag_pilot or negedge rst_n) begin
    if(!rst_n) begin
    tdma_cnt <= 5;
    d1 <= 15;
    d2 <= 15;
    d3 <= 15;
    d4 <= 15;
    end
	else if(flag_pilot)
		tdma_cnt <= 0;
	else begin
        tdma_cnt <= tdma_cnt + 1;
        if(tdma_cnt >= 65535) tdma_cnt <= 5;
        if(tdma_cnt == 1) d1 = d;
        if(tdma_cnt == 2) d2 = d;
        if(tdma_cnt == 3) d3 = d;
        if(tdma_cnt == 4) d4 = d;
	end
end
endmodule