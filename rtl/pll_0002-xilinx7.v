`timescale 1ns/10ps
module pll_0002 (
  output wire outclk_0,
  output wire outclk_1,
  input  wire rst,
  output wire locked,
  input  wire refclk
 );
  wire clkout0;
  wire clkout1;
  wire feedback;

  PLLE2_ADV #(
    .CLKFBOUT_MULT        (55),
    .DIVCLK_DIVIDE        (2),
    .CLKFBOUT_PHASE       (0.000),
    .CLKOUT0_DIVIDE       (16),      // 50*55/(16*2)  = 85.909090 MHz
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT1_DIVIDE       (32),      // 50*55/(32*2)  = 42.857142857142854 MHz
    .CLKOUT1_PHASE        (0.000),
    .CLKIN1_PERIOD        (20.000),
    .REF_JITTER1(0.01),
    .STARTUP_WAIT("FALSE")
    ) PLLE2_ADV (
    .CLKFBOUT            (feedback),
    .CLKOUT0             (clkout0),
    .CLKOUT1             (clkout1),
    .CLKFBIN             (feedback),
    .CLKIN1              (refclk),
    .LOCKED              (locked),
    .PWRDWN              (1'b0),
    .RST                 (rst)
  );
  BUFG clkout1 (.I(clkout1),.O(outclk_1));
  BUFG clkout0 (.I(clkout0),.O(outclk_0));

endmodule
