`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 22:50:26
// Design Name: 
// Module Name: ControlUnit
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
module ControlUnit(
    input wire clk,               // Clock signal
    input wire reset,             // Reset signal
    input wire [31:0] instFromTB, // Instruction input
    output reg isAdd, isSub, isCmp,    // Arithmetic control signals
    output reg isLd, isSt, isNOP,      // Load/Store control signals
    output reg isUBranch, isBEQ, isBGT, isRet, isCall, // Branch signals
    output reg isMul, isDiv, isMod,    // Multiply/Divide control signals
    output reg isLsl, isLsr, isAsr,    // Shift control signals
    output reg isOr, isAnd, isNot,     // Logical control signals
    output reg isMov,                  // Move control signal
    output reg isWb                    // Write-back control signal
);

    reg setSignals; // Temporary flag to control resetting signals

    always @(posedge clk) begin
        // Reset all control signals when reset is high
        setSignals <= 0;
        if (reset) begin
            isAdd <= 0; isSub <= 0; isCmp <= 0; isLd <= 0; isSt <= 0;
            isUBranch <= 0; isRet <= 0; isCall <= 0; isNOP <= 0;
            isBEQ <= 0; isBGT <= 0;
            isMul <= 0; isDiv <= 0; isMod <= 0;
            isLsl <= 0; isLsr <= 0; isAsr <= 0;
            isOr <= 0; isAnd <= 0; isNot <= 0;
            isMov <= 0; isWb <= 0;
            setSignals <= 0;
        end else begin
            // Decode instruction based on opcode (assuming 5-bit layout)
            if (!setSignals) begin
                case (instFromTB[31:27])
                    5'b00000: isAdd <= 1;       // Add
                    5'b00001: isSub <= 1;       // Subtract
                    5'b00010: isMul <= 1;       // Multiply
                    5'b00011: isDiv <= 1;       // Divide
                    5'b00100: isMod <= 1;       // Modulus
                    5'b00101: isCmp <= 1;       // Compare
                    5'b00110: isAnd <= 1;       // AND
                    5'b00111: isOr <= 1;        // OR
                    5'b01000: isNot <= 1;       // NOT
                    5'b01001: isMov <= 1;       // Move
                    5'b01010: isLsl <= 1;       // Logical Shift Left
                    5'b01011: isLsr <= 1;       // Logical Shift Right
                    5'b01100: isAsr <= 1;       // Arithmetic Shift Right
                    5'b01101: isNOP <= 1;       // NOP
                    5'b01110: isLd <= 1;        // Load
                    5'b01111: isSt <= 1;        // Store
                    5'b10000: isBEQ <= 1;       // Branch if Equal
                    5'b10001: isBGT <= 1;       // Branch if Greater Than
                    5'b10010: isUBranch <= 1;   // Unconditional Branch
                    5'b10011: isCall <= 1;      // Call
                    5'b10100: isRet <= 1;       // Return    
                    default: isNOP <= 1;        // Default to NOP
                endcase

                // Enable write-back for appropriate instructions
                isWb <= (isAdd || isSub || isCmp || isLd || isMov || isMul || isDiv || isMod || isLsl || isLsr || isAsr);

                setSignals <= 1; // Signal is now set
            end else begin
                // ✅ Reset all control signals after one clock cycle
                isAdd <= 0; isSub <= 0; isCmp <= 0; isLd <= 0; isSt <= 0;
                isUBranch <= 0; isRet <= 0; isCall <= 0; isNOP <= 0;
                isBEQ <= 0; isBGT <= 0;
                isMul <= 0; isDiv <= 0; isMod <= 0;
                isLsl <= 0; isLsr <= 0; isAsr <= 0;
                isOr <= 0; isAnd <= 0; isNot <= 0;
                isMov <= 0; isWb <= 0;
                setSignals <= 0; // Reset flag for next instruction
            end
        end
    end

endmodule