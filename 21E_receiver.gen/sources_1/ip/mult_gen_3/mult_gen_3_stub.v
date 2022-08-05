// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1.1 (win64) Build 3286242 Wed Jul 28 13:10:47 MDT 2021
// Date        : Sun Nov  7 17:01:25 2021
// Host        : YB running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/youbi/workspace_vivado/receive_v11/receive_v11.gen/sources_1/ip/mult_gen_3/mult_gen_3_stub.v
// Design      : mult_gen_3
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_17,Vivado 2021.1.1" *)
module mult_gen_3(A, P)
/* synthesis syn_black_box black_box_pad_pin="A[12:0],P[4:0]" */;
  input [12:0]A;
  output [4:0]P;
endmodule
