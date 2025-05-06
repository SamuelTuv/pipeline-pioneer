`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel Tuvstedt
// 
// Create Date: 2025-04-08
// Module Name: ALU
// Project Name: Pipeline Pioneer
// Target Devices: Xilinx FPGA Basys3
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input wire clk,
    input wire reset,
    input wire [31:0] input_a, // Primary input
    input wire [31:0] input_b, // Secondary input
    input wire [3:0] operation, 
    output reg [31:0] out
    );

    // ALU operations
    parameter ADD = 4'b0000;
    parameter SUB = 4'b0001;
    parameter AND = 4'b0010;
    parameter OR  = 4'b0011;
    parameter XOR = 4'b0100;
    parameter NOT = 4'b0101;
    parameter SLT = 4'b0110; // Set less than
    parameter SGT = 4'b0111; // Set greater than
    parameter SLL = 4'b1000; // Shift left logical
    parameter SRL = 4'b1001; // Shift right logical

    // Sequential logic for output
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 32'b0; // Reset output to zero
        end else begin
            case (operation)
                ADD: out <= input_a + input_b; 
                SUB: out <= input_a - input_b;
                AND: out <= input_a & input_b;
                OR:  out <= input_a | input_b;
                XOR: out <= input_a ^ input_b;
                NOT: out <= ~input_a;
                SLT: out <= (input_a < input_b) ? 32'b1 : 32'b0; // Set less than
                SGT: out <= (input_a > input_b) ? 32'b1 : 32'b0; // Set greater than
                SLL: out <= input_a << input_b; // Shift left logical
                SRL: out <= input_a >> input_b; // Shift right logical
                default: out <= 32'b0; // Default case to avoid latches
            endcase
        end
    end

    


endmodule
