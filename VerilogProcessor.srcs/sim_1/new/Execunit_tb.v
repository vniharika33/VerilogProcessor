`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2025 00:56:23
// Design Name: 
// Module Name: Execunit_tb
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

module Execunit_tb;

    // Inputs
    reg [31:0] op1, op2, immx, branchTarget, pc, dataMemReadData;
    reg isAdd, isSub, isCmp;
    reg isLsl, isLsr, isAsr;
    reg isOr, isNot, isAnd;
    reg isMov;
    reg isMul, isDiv, isMod;
    reg isLd, isSt;
    reg isBEQ, isBGT, isUBranch, isRet;
    reg clk;

    // Outputs
    wire [31:0] aluResult;
    wire [31:0] dataMemWriteData;
    wire [31:0] memoryAddress;
    wire dataMemWriteEnable;
    wire [31:0] branchPC;
    wire isBranchTaken;

    // Instantiate the Execunit
    Execunit uut (
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .branchTarget(branchTarget),
        .pc(pc),
        .isAdd(isAdd),
        .isSub(isSub),
        .isCmp(isCmp),
        .isLsl(isLsl),
        .isLsr(isLsr),
        .isAsr(isAsr),
        .isOr(isOr),
        .isNot(isNot),
        .isAnd(isAnd),
        .isMov(isMov),
        .isMul(isMul),
        .isDiv(isDiv),
        .isMod(isMod),
        .isLd(isLd),
        .isSt(isSt),
        .isBEQ(isBEQ),
        .isBGT(isBGT),
        .isUBranch(isUBranch),
        .isRet(isRet),
        .clk(clk),
        .dataMemReadData(dataMemReadData),
        .aluResult(aluResult),
        .dataMemWriteData(dataMemWriteData),
        .memoryAddress(memoryAddress),
        .dataMemWriteEnable(dataMemWriteEnable),
        .branchPC(branchPC),
        .isBranchTaken(isBranchTaken)
    );

    // Generate Clock Signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test Sequence
    initial begin
        $monitor("Time: %0d | op1: %h | op2: %h | ALUResult: %h | MemAddr: %h | BranchPC: %h | isBranchTaken: %b",
                 $time, op1, op2, aluResult, memoryAddress, branchPC, isBranchTaken);

        // Initialize Inputs
        op1 = 32'h00000010; 
        op2 = 32'h00000004;
        immx = 32'h00000008;
        branchTarget = 32'h00000020;
        pc = 32'h00000000;
        dataMemReadData = 32'hDEADBEEF;

        isAdd = 0; isSub = 0; isCmp = 0;
        isLsl = 0; isLsr = 0; isAsr = 0;
        isOr = 0; isNot = 0; isAnd = 0;
        isMov = 0;
        isMul = 0; isDiv = 0; isMod = 0;
        isLd = 0; isSt = 0;
        isBEQ = 0; isBGT = 0; isUBranch = 0; isRet = 0;

        // Test ADD Operation
        #10 isAdd = 1;
        #10 isAdd = 0;

        // Test SUB Operation
        #10 isSub = 1;
        #10 isSub = 0;

        // Test Comparison
        #10 isCmp = 1;
        #10 isCmp = 0;

        // Test Logical OR
        #10 isOr = 1;
        #10 isOr = 0;

        // Test Logical AND
        #10 isAnd = 1;
        #10 isAnd = 0;

        // Test Multiplication
        #10 isMul = 1;
        #10 isMul = 0;

        // Test Division
        #10 isDiv = 1;
        #10 isDiv = 0;

        // Test Modulus
        #10 isMod = 1;
        #10 isMod = 0;

        // Test Load Operation
        #10 isLd = 1;
        #10 isLd = 0;

        // Test Store Operation
        #10 isSt = 1;
        #10 isSt = 0;

        // Test Branch Equal
        #10 isBEQ = 1;
        #10 isBEQ = 0;

        // Test Branch Greater Than
        #10 isBGT = 1;
        #10 isBGT = 0;

        // Test Unconditional Branch
        #10 isUBranch = 1;
        #10 isUBranch = 0;

        // Test Return Instruction
        #10 isRet = 1;
        #10 isRet = 0;

        $display("✅ Execunit Test Completed!");
        $finish; // End simulation
    end

endmodule