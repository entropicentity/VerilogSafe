/*
 * Copyright (c) 2024 Alexander Singer
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_ASICSAFE_entropicentity (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = 0;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{uio_in[7:4], ena, clk, rst_n, 1'b0};

    wire c1;
    wire c2;

    wire green;
    wire blue;
    wire lock;

    wire [3:0] dataline;

    wire [3:0] numins;
    wire [2:0] numouts;

    assign uio_out[2:0] = numouts;
    assign uio_out[3] = lock;
    assign uio_out[4] = green;
    assign uio_out[5] = blue;
    assign uio_out[7:6] = 2'b00;

  clockboss u_clockboss (
    .clk(clk),
    .rst(~rst_n),
    .c1(c1),
    .c2(c2)
  );

  membranedriver u_membranedriver (
    .clk(c1),
    .rst(~rst_n),
    .in0(uio_in[0]),
    .in1(uio_in[1]),
    .in2(uio_in[2]),
    .in3(uio_in[3]),
    .out0(numouts[0]),
    .out1(numouts[1]),
    .out2(numouts[2]),
    .data_out(dataline)
  );

  safecontrol u_safecontrol (
    .clk(c2),
    .rst(~rst_n),
    .invalue(dataline),
    .lock(lock),
    .green(green),
    .blue(blue)
  );



endmodule
