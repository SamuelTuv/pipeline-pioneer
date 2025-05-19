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
    output reg [15:0] led,
    input wire  [31:0] test_addr,
    output reg [31:0] test_reg

    );
    
    // Memory 
    reg write_enable;
    reg [15:0] write_addr;
    reg [31:0] write_data;
    reg [15:0] read_instr_addr;
    wire [31:0] read_instr;
    reg [15:0] read_data_addr;
    //wire [31:0] read_data; read data is namechanged to z4
    
    // PC
    wire [31:0] pc; // Declare pc as a wire

    // ALU
    

    // Instruction registers
    wire [31:0] ir0;
    assign ir0 = read_instr;
    reg [31:0] ir1;
    reg [31:0] ir2;
    reg [31:0] ir3;
    reg [31:0] ir4;

    // Intermediate registers
    reg [31:0] im2; // Immediate value for load instruction, alternate left input to ALU
    reg [31:0] a2; //Alternative right input to ALU
    reg [31:0] b2; //Alternative left input to ALU
    reg [31:0] d3; //Result of ALU
    reg [31:0] d4;
    reg [31:0] z3; 
    wire [31:0] z4; //output of Memory

    // General purpose registers
    reg [31:0] gpr [0:31]; // 32 general purpose registers
    
    wire [11:0] imm_s = {ir1[31:25], ir1[11:7]}; // Immediate value for store instruction

    
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

        
        case (ir1[6:0])
            7'b0000011: begin // Load instruction
                a2 <= gpr[ir1[19:15]]; // Load data from register
                im2 <= ir1[31:20]; // Load immediate value
            end
            
            default: begin
                //test_reg <= 32'b0; // Default to zero
            end
        endcase

        
        case (ir2[6:0])
            7'b0000011: begin // Load instruction
                //add a2 and im2 to get the address
                d3 <= a2 + im2; // Load data from register
            end
            
            default: begin
                //test_reg <= 32'b0; // Default to zero
            end
        endcase
      

        // Instruction Fetch for risc 5
        case (ir3[6:0])
            7'b0000011: begin // Load instruction
                write_enable <= 1'b0; // Disable write
                read_data_addr <= a2 + im2; // read address is the sum of the immediate and the register
            end
            
            7'b0100011: begin // Store instruction
                write_enable <= 1'b1; // Enable write
                write_addr <= gpr[ir3[19:15]] + imm_s; // Write address from instruction
                write_data <= gpr[ir3[24:20]]; // Write data from instruction
            end

            7'b0110011: begin // R-type instruction

                write_enable <= 1'b0; // Disable write
                

            end

            
            default: begin
                write_enable <= 1'b0; // Default to no write
            end
        endcase
        

        case (ir4[6:0])
            7'b0000011: begin // Load instruction
                gpr[ir4[24:20]] <= z4; // Load data into test register
            end
            
            default: begin
                //test_reg <= 32'b0; // Default to zero
            end
        endcase

    end

        
    // Instantiate the memory module
    memory_module mem_inst (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        
        .write_addr(write_addr),
        .write_data(write_data),
        
        .read_instr_addr(read_instr_addr),
        .read_instr(read_instr),
        
        .read_data_addr(read_data_addr),
        .read_data(z4)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            read_instr_addr <= 16'b0; // Reset instruction address to 0
        end else begin
            read_instr_addr <= pc[15:0]; // Assign PC value to instruction address
        end
    end
    
    // Instantiate the PC module
    pc_module pc_inst (
        .clk(clk),
        .reset(reset),
        .jmp1(1'b0), // Placeholder for jump signal
        .jmp_amt(32'b0), // Placeholder for jump amount
        .pc(pc) // Output PC to LEDs
    );
    
    
    // Instantiate the ALU module
    alu_module alu_inst (
        .clk(clk),
        .reset(reset),
        .input_a(input_a), // input A
        .input_b(input_b), // input B
        .out(d3) //output of ALU
    );
    


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

    always @(posedge clk) begin
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
