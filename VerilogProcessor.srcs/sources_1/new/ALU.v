`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2025 18:56:40
// Design Name: 
// Module Name: ALU
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


module ALU(
    input wire clk,                      // Clock signal
    input wire [31:0] op1,          // Operand 1
    input wire [31:0] op2,          // Operand 2
    input wire isAdd, isSub, isCmp, // Arithmetic control signals
    input wire isMul, isDiv, isMod, // Multiplication, Division, and Modulus
    input wire isLsl, isLsr, isAsr, // Shift control signals
    input wire isOr, isNot, isAnd,  // Logical control signals
    output reg [31:0] result,       // ALU result
    output reg flagZero,            // Zero flag
    output reg flagNegative         // Negative flag
);

    // Initialize Outputs
    initial begin
        result = 0;
        flagZero = 0;
        flagNegative = 0;
    end

    always @(posedge clk) begin
        // Default values
        result = 0;
        flagZero = 0;
        flagNegative = 0;

        // Arithmetic Operations
        if (isAdd)
            result = op1 + op2;
        else if (isSub)
            result = op1 - op2;
        else if (isCmp) begin
            result = (op1 == op2) ? 32'b0 : 32'b1;
            flagZero = (result == 32'b0);
        end

        // Multiplication, Division, and Modulus
        else if (isMul)
            result = op1 * op2;
        else if (isDiv)
            result = op1 / op2;
        else if (isMod)
            result = op1 % op2;

        // Logical Operations
        else if (isOr)
            result = op1 | op2;
        else if (isAnd)
            result = op1 & op2;
        else if (isNot)
            result = ~op1;

        // Shift Operations
        else if (isLsl)
            result = op1 << op2;
        else if (isLsr)
            result = op1 >> op2;
        else if (isAsr)
            result = $signed(op1) >>> op2;

        // Set Negative Flag Only for Signed Arithmetic
        if (isSub || isCmp || isAsr)
            flagNegative = result[31];
        else
            flagNegative = 0;

        // Zero Flag Should Be Set for Any Operation That Results in 0
        flagZero = (result == 32'b0);
    end

endmodule