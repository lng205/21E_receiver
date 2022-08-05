
//------------------------------------------------------------------------------
// (c) Copyright 2014 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------ 
//
// C Model configuration for the "fir_compiler_0" instance.
//
//------------------------------------------------------------------------------
//
// coefficients: -90,-63,-84,-109,-137,-170,-205,-245,-287,-332,-380,-429,-478,-527,-574,-618,-657,-690,-714,-728,-729,-716,-685,-635,-563,-466,-344,-193,-11,202,450,733,1051,1407,1800,2229,2696,3197,3733,4300,4898,5522,6170,6838,7522,8218,8921,9625,10326,11019,11697,12355,12989,13591,14158,14684,15165,15596,15973,16292,16552,16749,16881,16947,16947,16881,16749,16552,16292,15973,15596,15165,14684,14158,13591,12989,12355,11697,11019,10326,9625,8921,8218,7522,6838,6170,5522,4898,4300,3733,3197,2696,2229,1800,1407,1051,733,450,202,-11,-193,-344,-466,-563,-635,-685,-716,-729,-728,-714,-690,-657,-618,-574,-527,-478,-429,-380,-332,-287,-245,-205,-170,-137,-109,-84,-63,-90
// chanpats: 173
// name: fir_compiler_0
// filter_type: 0
// rate_change: 0
// interp_rate: 1
// decim_rate: 1
// zero_pack_factor: 1
// coeff_padding: 0
// num_coeffs: 128
// coeff_sets: 1
// reloadable: 0
// is_halfband: 0
// quantization: 0
// coeff_width: 16
// coeff_fract_width: 0
// chan_seq: 0
// num_channels: 1
// num_paths: 1
// data_width: 5
// data_fract_width: 0
// output_rounding_mode: 0
// output_width: 25
// output_fract_width: 0
// config_method: 0

const double fir_compiler_0_coefficients[128] = {-90,-63,-84,-109,-137,-170,-205,-245,-287,-332,-380,-429,-478,-527,-574,-618,-657,-690,-714,-728,-729,-716,-685,-635,-563,-466,-344,-193,-11,202,450,733,1051,1407,1800,2229,2696,3197,3733,4300,4898,5522,6170,6838,7522,8218,8921,9625,10326,11019,11697,12355,12989,13591,14158,14684,15165,15596,15973,16292,16552,16749,16881,16947,16947,16881,16749,16552,16292,15973,15596,15165,14684,14158,13591,12989,12355,11697,11019,10326,9625,8921,8218,7522,6838,6170,5522,4898,4300,3733,3197,2696,2229,1800,1407,1051,733,450,202,-11,-193,-344,-466,-563,-635,-685,-716,-729,-728,-714,-690,-657,-618,-574,-527,-478,-429,-380,-332,-287,-245,-205,-170,-137,-109,-84,-63,-90};

const xip_fir_v7_2_pattern fir_compiler_0_chanpats[1] = {P_BASIC};

static xip_fir_v7_2_config gen_fir_compiler_0_config() {
  xip_fir_v7_2_config config;
  config.name                = "fir_compiler_0";
  config.filter_type         = 0;
  config.rate_change         = XIP_FIR_INTEGER_RATE;
  config.interp_rate         = 1;
  config.decim_rate          = 1;
  config.zero_pack_factor    = 1;
  config.coeff               = &fir_compiler_0_coefficients[0];
  config.coeff_padding       = 0;
  config.num_coeffs          = 128;
  config.coeff_sets          = 1;
  config.reloadable          = 0;
  config.is_halfband         = 0;
  config.quantization        = XIP_FIR_INTEGER_COEFF;
  config.coeff_width         = 16;
  config.coeff_fract_width   = 0;
  config.chan_seq            = XIP_FIR_BASIC_CHAN_SEQ;
  config.num_channels        = 1;
  config.init_pattern        = fir_compiler_0_chanpats[0];
  config.num_paths           = 1;
  config.data_width          = 5;
  config.data_fract_width    = 0;
  config.output_rounding_mode= XIP_FIR_FULL_PRECISION;
  config.output_width        = 25;
  config.output_fract_width  = 0,
  config.config_method       = XIP_FIR_CONFIG_SINGLE;
  return config;
}

const xip_fir_v7_2_config fir_compiler_0_config = gen_fir_compiler_0_config();

