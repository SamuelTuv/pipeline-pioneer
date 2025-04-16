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


module memory_module(
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire [15:0] write_addr, // only uses 8192 addresses yet so 12:0 is what is needed. 
    input wire [31:0] write_data,
    input wire [15:0] read_addr, // only uses 8192 addresses yet so 12:0 is what is needed. 
    output reg [31:0] read_data
    );
    
    reg [31:0] memory_array [0:255];
    
    integer i;

    // Initial program memory
    initial begin
        // Example program data
        memory_array[0] = 32'h00000001;
        memory_array[1] = 32'h00000002;
        memory_array[2] = 32'h00000003;

        for (i = 3; i < 255; i = i + 1) begin
            memory_array[i] <= 32'b0;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            read_data <= 32'b0; //
        end else begin
            if (write_enable) begin
                memory_array[write_addr[15:2]] <= write_data;
            end
        end 
            
        read_data <= memory_array[read_addr[15:2]];
        end
endmodule
