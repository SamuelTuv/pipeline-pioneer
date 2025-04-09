`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel Tuvstedt
// 
// Create Date: 2025-04-08
// Module Name: central
// Project Name: Pipeline Pioneer
// Target Devices: Xilinx FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////


module central(
    input wire clk,
    input wire reset,
    output reg [15:0] led

    );
    
    wire write_enable = 1'b0;
    wire [15:0] write_addr = 16'b0;
    wire [31:0] write_data = 16'b0;
    wire [15:0] read_addr = 32'b0;
    wire [31:0] read_data = 32'b0;
        
    // Instantiate the memory module
    memory mem_inst (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr(read_addr),
        .read_data(read_data)
    );
    
    
    // Always block to assign reset signal to led
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 16'b0; // Clear LEDs on reset
        end else begin
            led <= 16'b1; // Assign reset signal to all LEDs
        end
    end


endmodule

