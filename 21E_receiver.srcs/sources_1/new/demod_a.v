`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 15:48:54
// Design Name: 
// Module Name: demod_a
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


module demod_a(
input clk,
input rst_n,
input sig,
output signed [7:0] amplitude
    );
    
wire [63:0] freq_buf;
reg [63:0] freq;
/****************************************************************************************
tdma_clk
****************************************************************************************/
freq_meter #(2000)	freq_meter_tdma_inst//gate time = 2000/100M = 20us
(
.clk(clk),
.sig(sig),
.rst_n(rst_n),
.freq(freq_buf)
);

localparam FREQMAX = 64'd1_301_375_090_688_000; // 303k
localparam FREQMIN = 64'd1_275_605_286_912_000; // 297k
always@(freq_buf) begin
    if(freq_buf > FREQMAX) freq <= FREQMAX;
    else if(freq_buf < FREQMIN) freq <= FREQMIN;
    else freq <= freq_buf;
end

/*****************************
calc deltafreq
*****************************/
localparam DEVIATION_WIDTH = 13;
parameter fc = 64'd1_288_490_188_800_000; //300kHz
wire	signed [DEVIATION_WIDTH+31:0]	deltafreq;	//fixed-point
wire signed	[DEVIATION_WIDTH-1:0] deviation;	//integer
assign deltafreq = freq - fc;
assign deviation = deltafreq[31] ? deltafreq[DEVIATION_WIDTH+31:32] + 1 : deltafreq[DEVIATION_WIDTH+31:32];

wire [4:0] amplitude_buf;
mult_gen_3 mult3_inst (
  .A(deviation),  // input wire [12 : 0] A
  .P(amplitude_buf)  // output wire [4 : 0] P
);

wire [31:0] freq_fir;
fir_compiler_0 fir0 (
  .aclk(clk),                              // input wire aclk
  .s_axis_data_tvalid(1),  // input wire s_axis_data_tvalid
  .s_axis_data_tready(),  // output wire s_axis_data_tready
  .s_axis_data_tdata(amplitude_buf),    // input wire [7 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata(freq_fir)    // output wire [31 : 0]m_axis_data_tdata
);

mult_gen_2 mult2_inst (
  .A(freq_fir),  // input wire [31 : 0] A
  .P(amplitude)  // output wire [7 : 0] P
);
endmodule
