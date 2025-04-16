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
    wire [31:0] pc; // Declare pc as a wire

        
    // Instantiate the memory module
    memory_module mem_inst (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr(read_addr),
        .read_data(read_data)
    );
    
    // Instantiate the PC module
    pc_module pc_inst (
        .clk(clk),
        .reset(reset),
        .jmp1(1'b0), // Placeholder for jump signal
        .jmp_amt(32'b0), // Placeholder for jump amount
        .pc(pc) // Output PC to LEDs
    );
    
    
    // Use an always block to assign pc value to led
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 16'b0; // Reset LEDs to 0
        end else begin
            led <= pc[15:0]; // Assign PC value to LEDs
        end
    end


endmodule


module pc_module (
    input wire clk,
    input wire reset,
    input wire jmp1, // The signal which is sent in IR1 to jump
    input wire [31:0] jmp_amt, // lenght to jump. Signed
    output reg [31:0] pc

    );
    
    reg [31:0] pc1; // Intermediate PC register
    reg [31:0] pc2; // Intermediate PC register
    reg jmp2; // The signal which is sent in IR2 to jump next cycle. 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'h0; // Reset PC to 0
            pc1 <= 32'h0; // Reset PC1 to 0
            pc2 <= 32'h0; // Reset PC2 to 0
            jmp2 <= 1'b0; // Reset jump signal
            
        end else begin
            if (jmp1) begin
                pc2 <= pc1 + $signed(jmp_amt); // Jump relatively to the specified address, allowing for signed values.
                jmp2 = 1'b1; // Set the jump signal for the next cycle.
                pc <= pc + 4; // Increment PC by 4 on each clock cycle.
                pc2 <= pc1;

            end else if (jmp2) begin
                pc2 <= pc1;
                pc <= pc2;

            end else begin
                pc2 <= pc1;
                pc <= pc + 4; // Increment PC by 4 on each clock cycle.
            end
            pc1 <= pc;
            
        end
    end    

endmodule

module ir_module (
    input wire clk,
    input wire reset,
    input wire [31:0]ir0,
    output reg [31:0] ir1,
    output reg [31:0] ir4
    );

    reg [31:0] ir2;
    reg [31:0] ir3;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ir1 <= 32'b0; 
            ir2 <= 32'b0; 
            ir3 <= 32'b0;
            ir4 <= 32'b0;
        end else begin
            ir1 <= ir0; // Load instruction into IR
            ir2 <= ir1;
            ir3 <= ir2;
            ir4 <= ir3;
        end
    end
endmodule