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
    
    input wire [15:0] read_instr_addr, // only uses 8192 addresses yet so 12:0 is what is needed. 
    output reg [31:0] read_instr,
    
    input wire [15:0] read_data_addr, // only uses 8192 addresses yet so 12:0 is what is needed. 
    output reg [31:0] read_data
    );
    
    
     (* ram_style = "block" *) reg [31:0] memory_array [0:255];

    
    integer i;

    // Initial program memory
    initial begin
        // Example program data
        memory_array[0] = 32'b0000000_00000_00101_010_00001_0000011;
        memory_array[1] = 32'h00000000;
        memory_array[2] = 32'h00000000;
        memory_array[3] = 32'h00000000;
        memory_array[4] = 32'h00000000;
        memory_array[5] = 32'h00000000;
        memory_array[6] = 32'h00000000;
        memory_array[7] = 32'h00000000;
        memory_array[8] = 32'h00000069;

        for (i = 9; i < 255; i = i + 1) begin
            memory_array[i] <= 32'b0;
        end
        memory_array[4] = 32'h00000069;
    end

    
    always @(posedge clk) begin
    
        if (reset) begin
            read_data <= 32'h00000000;
            read_instr <=32'h00000000;
        end else begin

            if (write_enable) begin
                memory_array[write_addr[15:2]] <= write_data;
            end
            read_data <= memory_array[read_data_addr[15:2]];
            read_instr <= memory_array[read_instr_addr[15:2]];
        end
     end
        
            
endmodule
