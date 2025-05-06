`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel Tuvstedt
// 
// Create Date: 2025-05-05
// Module Name: memory testbench
// Project Name: Pipeline Pioneer
// Target Devices: Xilinx FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////

module alu_tb;

    // Parameters
  parameter CLOCK_PERIOD = 10; // Clock period in time units

  // Signals
  reg clk;
  reg reset;
  reg [31:0] input_a; // Primary input
  reg [31:0] input_b; // Secondary input
  reg [3:0] operation; 
  wire [31:0] out;

    
  // Instantiate the design under test (DUT)
  alu dut (
    .clk(clk),
    .reset(reset),
    .input_a(input_a),
    .input_b(input_b),
    .operation(operation),
    .out(out)
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
      input_a = 0;
      input_b = 0;
      operation = 0;
      #20 reset = 0; // Release reset after 20 time units
      // Test cases
      
      // Test addition
      input_a = 32'h00000001; // First operand
      input_b = 32'h00000002; // Second operand
      operation = 4'b0000; // ADD operation

      #CLOCK_PERIOD; // Wait for one clock cycle
      // Check output
      
      // Test subtraction
      input_a = 32'h00000005; // First operand
      input_b = 32'h00000001; // Second operand
      operation = 4'b0001; // SUB operation
      #CLOCK_PERIOD; // Wait for one clock cycle
  
      // Finish simulation
      #1000 $finish; // End simulation after 1000 time units
    end
  
  endmodule
