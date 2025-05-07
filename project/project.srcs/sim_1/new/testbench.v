`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel Tuvstedt
// 
// Create Date: 2025-04-08
// Module Name: testbench
// Project Name: Pipeline Pioneer
// Target Devices: Xilinx FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////

module testbench;

    // Parameters
  parameter CLOCK_PERIOD = 10; // Clock period in time units

  // Signals
  reg clk;
  reg reset;
  wire [31:0] test_reg;
  reg [31:0] test_addr;

  // Instantiate the design under test (DUT)
  central dut (
    .clk(clk),
    .reset(reset),
    .test_reg(test_reg),
    .test_addr(test_addr)
    // Add other ports as needed
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLOCK_PERIOD / 2) clk = ~clk;
  end

  // Testbench logic
  initial begin
    // Initialize signals
    reset = 1;
    test_addr = 32;
    #20 reset = 0; // Deassert reset after 20 time units

    // Add your test cases here
    // Example: Apply stimulus to DUT
    // #100; // Wait for 100 time units
    // Apply other stimulus as needed

    // Finish simulation
    # 1000 $finish; // End simulation after 1000 time units
  end

endmodule
