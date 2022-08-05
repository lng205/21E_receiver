`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: yb
// 
// Create Date: 2021/07/24 12:23:02
// Design Name: 
// Module Name: freq_meter
// Project Name: 
// Target Devices: 
// Tool Versions: 2021.1
// Description: input sig		output freq
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//				V1.0 - COMPLETED
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module freq_meter(
	input						clk,
	input						rst_n,
	input						sig,
	output		[63:0]		freq
    );

parameter	period			= 28'd2500;		//Sa = 200M/AFREQ = 80k
reg	[31:0]		clkcnt;
reg	[31:0]		sigcnt;
reg	[31:0]		clk_cnt;
reg  [31:0]		clk_cntbuf;
reg  [31:0] 		sig_cnt;
reg					fs;					//start flag
reg					fe;					//end flag
//sig_cnt
always@(posedge sig or negedge rst_n or posedge fe)
begin
	if(!rst_n)
	begin
		fs <= 0;
		sig_cnt <= 0;
		clk_cntbuf <= 0;
	end
	else if(fe)
		fs <= 0;
	else
	begin
		if(!fs)								//start
		begin
			fs <= 1'b1;
			sig_cnt <= 0;
		end
		else								//already start
		begin
			sig_cnt <= sig_cnt + 1;
			clk_cntbuf <= clk_cnt;
		end
	end
end

//clk_cnt
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		fe <= 0;
		clk_cnt <= 0;
		clkcnt <= 1;
		sigcnt <= 0;
	end
	else if(fs)
	begin
		if(clk_cnt < period)
			clk_cnt <= clk_cnt + 1;
		else
		begin
			fe <= 1'b1;
			clk_cnt <= 0;
			clkcnt <= clk_cntbuf;
			sigcnt <= sig_cnt;
		end
	end
	else
		fe <= 0;
end

//counts to freq
reg [31:0] ratio;
wire [63:0] ratiobuf;			//32fixed-point
wire div_m_vld;
div_gen_0 div_inst (
  .aclk(clk),                                      // input wire aclk
  .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tready(),    // output wire s_axis_divisor_tready
  .s_axis_divisor_tdata(clkcnt),      // input wire [31 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tready(),  // output wire s_axis_dividend_tready
  .s_axis_dividend_tdata(sigcnt),    // input wire [31 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(div_m_vld),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(ratiobuf)            // output wire [63 : 0] m_axis_dout_tdata
);
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		ratio <= 0;
	else if(div_m_vld)
		ratio <= ratiobuf[31:0];
end
mult_gen_0 mult0 (
  .A(ratio),      // input wire [31 : 0] A
  .P(freq)      // output wire [63 : 0] P
);
endmodule