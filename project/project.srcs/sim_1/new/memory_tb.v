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

module memory_tb;

    // Parameters
  parameter CLOCK_PERIOD = 10; // Clock period in time units

  // Signals
  reg clk;
  reg reset;

 
    // Memory signals
    reg write_enable;
    reg [15:0] write_addr;
    reg [31:0] write_data;
    reg [15:0] read_instr_addr;
    reg [15:0] read_data_addr;
    wire [31:0] read_data;
    wire [31:0] read_instr;

      

  // Instantiate the design under test (DUT)
  memory_module dut (
      .clk(clk),
      .reset(reset),
      .write_enable(write_enable),
      
      .write_addr(write_addr),
      .write_data(write_data),
      
      .read_instr_addr(read_instr_addr),
      .read_instr(read_instr),
      
      .read_data_addr(read_data_addr),
      .read_data(read_data)
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
      write_enable = 0;
      write_addr = 16'h0000;
      write_data = 32'h00000000;
      read_instr_addr = 16'h0000;
      read_data_addr = 16'h0000;
  
      #20 
      reset = 0; // Deassert reset after 20 time units
  
      #100
      // Add your test cases here
  
      // Test case 1: Write and read data
      write_enable = 1; // Enable write operation
      write_addr = 16'h0004; // Address to write to
      write_data = 32'hDEADBEEF; // Data to write
  
      #10; // Wait for a while
  
      write_enable = 0; // Disable write operation
      read_instr_addr = 16'h0004; // Address to read from
  
      #10; // Wait for a while
  
      read_data_addr = 16'h0008; // Address to read data from
  
      #20; // Wait for a while
      
      read_instr_addr = 16'h0000;
      // Check read data

  
      // Finish simulation
      #1000 $finish; // End simulation after 1000 time units
    end
  
  endmodule
