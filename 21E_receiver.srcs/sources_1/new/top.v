`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/04 11:32:12
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - 限幅
// Revision 0.02 - pilot tone 2 frame to 16 frame
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
input sys_clk_in,
input sys_rst_n,
input sig,
output dac_ile,
output dac_cs_n,
output dac_wr1_n,
output dac_wr2_n,
output dac_xfer_n,
output [7:0] dac_data,
input [3:0] i1,
input [3:0] i2,
input key3,
input [3:0] sel_R,
output reg [7:0] L,
output reg [7:0] R,
output reg [3:0] DN0,
output reg [3:0] DN1
    );
assign clk = sys_clk_in;
assign dac_ile = 1'b1;
assign dac_cs_n = 1'b0;
assign dac_wr1_n = 1'b0;
assign dac_wr2_n = 1'b0;
assign dac_xfer_n = 1'b0;

wire signed [7:0] amplitude_a;
demod_a demod_a_inst(
.clk(sys_clk_in),
.rst_n(sys_rst_n),
.sig(sig),
.amplitude(amplitude_a)
);
assign dac_data = 127 - amplitude_a;

reg [3:0] d [4:1];
wire [3:0] d_buf [4:1];
demod_d demod_d_inst(
.clk(sys_clk_in),
.rst_n(sys_rst_n),
.sig(sig),
.d1(d_buf[1]),
.d2(d_buf[2]),
.d3(d_buf[3]),
.d4(d_buf[4])
);

//delay 5s
reg [28:0] sel_cnt;//5s
reg [3:0] sel_L;
always@(posedge sys_clk_in or negedge sys_rst_n) begin
    if(!sys_rst_n) sel_cnt <= 0;
    else begin
        if(d_buf[1] == 15) begin
            if(sel_cnt <= 500_000_000) sel_cnt <= sel_cnt + 1;
            else sel_L <= 0;
        end
        else begin
            d[1] <= d_buf[1];
            d[2] <= d_buf[2];
            d[3] <= d_buf[3];
            d[4] <= d_buf[4];
            sel_cnt <= 0;
            sel_L <= 4'b1111;
        end
    end
end

reg [7:0] c [0:15];
reg clk1;
reg [15:0] divcount1;
reg [9:0] divcount2;
reg [3:0] hexnum_1;
reg [3:0] hexnum_2;
reg [2:0] count1;
reg [2:0] count2;
reg [7:0] key_count;
initial begin
c[0] = 8'b11111100; c[1] = 8'b01100000; c[2] = 8'b11011010; c[3] = 8'b11110010;
c[4] = 8'b01100110; c[5] = 8'b10110110; c[6] = 8'b10111110; c[7] = 8'b11100000; 
c[8] = 8'b11111110; c[9] = 8'b11110110; c[10] = 8'b11101110; c[11] = 8'b00111110;
c[12] = 8'b00011010; c[13] = 8'b01111010; c[14] = 8'b10011110; c[15] = 8'b10001110;
end
always @ (posedge clk) begin//1ms
    if(divcount1 == 16'd49999)
        begin
            divcount1<=16'd0;
            clk1 <= ~clk1;
        end
    else divcount1 <= divcount1+1;
end
always @ (posedge clk1) begin
    if(key3) begin
        key_count <= key_count + 1;
        if(key_count == 10) begin//按10ms
            key_count <= 0;
            hexnum_1 <= 0;
            hexnum_2 <= 0;
        end
    end
    divcount2 <= divcount2 + 1;
    count1 <= count1+1;//刷新
    if(divcount2 == 999) begin//1s
        divcount2 <= 0;//清零
        if(hexnum_2 == 15)  hexnum_1 <= hexnum_1 + 1;//复位
        hexnum_2 <= hexnum_2 + 1;
    end
    case(count1)
        2'b00: begin
            L <= c[d[1]]; 
            R <= c[i1];
            DN0 <= 4'b0001 & sel_L;
            DN1 <= 4'b0001 & sel_R;
        end
        2'b01: begin
            L <= c[d[2]]; 
            R <= c[i2] + 8'b00000001;
            DN0 <= 4'b0010 & sel_L;
            DN1 <= 4'b0010 & sel_R;
        end
        2'b10: begin
            L <= c[d[3]];
            R <= c[hexnum_1];
            DN0 <= 4'b0100 & sel_L;
            DN1 <= 4'b0100 & sel_R;
        end
        2'b11: begin
            L <= c[d[4]] + 8'b00000001;
            R <= c[hexnum_2];
            DN0 <= 4'b1000 & sel_L;
            DN1 <= 4'b1000 & sel_R;
        end
        endcase
        if(count1==2'b11) count1 <= 0;
    end
endmodule
