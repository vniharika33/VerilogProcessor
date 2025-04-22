`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 23:50:36
// Design Name: 
// Module Name: ALU_tb
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


`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg clk;
    reg [31:0] op1, op2;
    reg isAdd, isSub, isCmp;
    reg isMul, isDiv, isMod;
    reg isLsl, isLsr, isAsr;
    reg isOr, isNot, isAnd;

    // Outputs
    wire [31:0] result;
    wire flagZero, flagNegative;

    // Instantiate the ALU
    ALU uut (
        .clk(clk),
        .op1(op1),
        .op2(op2),
        .isAdd(isAdd),
        .isSub(isSub),
        .isCmp(isCmp),
        .isMul(isMul),
        .isDiv(isDiv),
        .isMod(isMod),
        .isLsl(isLsl),
        .isLsr(isLsr),
        .isAsr(isAsr),
        .isOr(isOr),
        .isNot(isNot),
        .isAnd(isAnd),
        .result(result),
        .flagZero(flagZero),
        .flagNegative(flagNegative)
    );

    // Generate Clock Signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Apply Test Cases
    initial begin
        $monitor("Time: %0d | op1: %h | op2: %h | Result: %h | ZeroFlag: %b | NegativeFlag: %b",
                 $time, op1, op2, result, flagZero, flagNegative);

        // Initialize Inputs
        op1 = 32'h00000005; 
        op2 = 32'h00000003;
        isAdd = 0; isSub = 0; isCmp = 0;
        isMul = 0; isDiv = 0; isMod = 0;
        isLsl = 0; isLsr = 0; isAsr = 0;
        isOr = 0; isNot = 0; isAnd = 0;

        // Test Addition
        #10 isAdd = 1;
        #10 isAdd = 0;

        // Test Subtraction
        #10 isSub = 1;
        #10 isSub = 0;

        // Test Comparison
        #10 isCmp = 1;
        #10 isCmp = 0;

        // Test Multiplication
        #10 isMul = 1;
        #10 isMul = 0;

        // Test Division
        #10 isDiv = 1;
        #10 isDiv = 0;

        // Test Modulus
        #10 isMod = 1;
        #10 isMod = 0;

        // Test Logical AND
        #10 isAnd = 1;
        #10 isAnd = 0;

        // Test Logical OR
        #10 isOr = 1;
        #10 isOr = 0;

        // Test Logical NOT
        #10 isNot = 1;
        #10 isNot = 0;

        // Test Left Shift
        #10 isLsl = 1;
        #10 isLsl = 0;

        // Test Right Shift
        #10 isLsr = 1;
        #10 isLsr = 0;

        // Test Arithmetic Shift Right
        #10 isAsr = 1;
        #10 isAsr = 0;

        $display("✅ ALU Test Completed!");
        $finish; // Stop simulation
    end

endmodule
