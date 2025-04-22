`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 22:42:52
// Design Name: 
// Module Name: Execunit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Execunit(
    input wire [31:0] op1,              // Operand 1
    input wire [31:0] op2,              // Operand 2
    input wire [31:0] immx,             // Extended immediate value
    input wire [31:0] branchTarget,     // Branch target address
    input wire [31:0] pc,               // Program counter
    input wire isAdd, isSub, isCmp,     // Arithmetic control signals
    input wire isLsl, isLsr, isAsr,     // Shift control signals
    input wire isOr, isNot, isAnd,      // Logical control signals
    input wire isMov,                   // Move operation
    input wire isMul, isDiv, isMod,     // Arithmetic unit now includes MUL, DIV, MOD
    input wire isLd, isSt,              // Load/store control signals
    input wire isBEQ, isBGT, isUBranch, // Branch control signals
    input wire isRet,                   // Return control signal
    input wire clk,                     // Clock signal
    input wire [31:0] dataMemReadData,  // Data read from memory
    output reg [31:0] aluResult,        // Final ALU result
    output reg [31:0] dataMemWriteData, // Data to write to memory
    output reg [31:0] memoryAddress,    // Memory address for load/store
    output reg dataMemWriteEnable,      // Memory write enable signal
    output reg [31:0] branchPC,         // Updated program counter for branches
    output reg isBranchTaken,           // Branch decision flag
    output wire flagZero,               // Combinational flag for zero
    output wire flagNegative            // Combinational flag for negative
);

    wire [31:0] aluOut;

    // Flag Logic
    assign flagZero = (op1 == op2);       // Combinational zero flag
    assign flagNegative = (op1 < op2);   // Combinational negative flag

    // Initialize Outputs to Avoid Undefined Behavior
    initial begin
        aluResult = 0;
        dataMemWriteData = 0;
        memoryAddress = 0;
        dataMemWriteEnable = 0;
        branchPC = 0;
        isBranchTaken = 0;
    end

    // Update ALU Results for MOV, CMP, and NOT
    always @(*) begin
        if (isMov) begin
            aluResult = op2;             // MOV simply transfers op2 into `Rd`
        end else if (isNot) begin
            aluResult = ~op1;            // NOT inverts bits of `op1`
        end
    end

    // Load/Store Operations
    always @(*) begin
        if (isLd || isSt) begin
            memoryAddress = op1 + immx;
            dataMemWriteData = op2;
            dataMemWriteEnable = isSt;
        end else begin
            memoryAddress = 0;
            dataMemWriteData = 0;
            dataMemWriteEnable = 0;
        end
    end

    // Branch Logic (Separate from ALU)
    always @(*) begin
        if (isRet)
            branchPC = op1;                // Return address from register
        else if (isUBranch)
            branchPC = branchTarget;       // Unconditional branch
        else if (isBEQ && flagZero)
            branchPC = branchTarget;       // Branch if equal
        else if (isBGT && flagNegative == 0 && flagZero == 0)
            branchPC = branchTarget;       // Branch if greater than
        else
            branchPC = pc + 4;             // Default case: increment PC

        isBranchTaken = isUBranch || (isBEQ && flagZero) || 
                        (isBGT && flagNegative == 0 && flagZero == 0);
    end

    // ALU Output Selection (Handle Load Instruction)
    always @(*) begin
        if (isLd)
            aluResult = dataMemReadData;  // Load result from memory
        else
            aluResult = aluOut;          // ALU handles arithmetic/logical operations
    end

endmodule