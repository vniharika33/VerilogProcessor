`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 22:52:54
// Design Name: 
// Module Name: SingleCycleTinyRisc
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



module SingleCycleTinyRisc(
    input wire clk,                   // Clock signal
    input wire reset,                 // Reset signal
    input wire [31:0] instFromTB,     // Instruction input
    input wire storeInst, // ✅ Allows testbench to trigger instruction storage
input wire [7:0] storeAddress, // ✅ Address in memory where new instruction is stored

    output wire [31:0] inst,
    output wire [31:0] pc,            // Program counter output
    output wire [31:0] memoryAddress,   // Memory address for load/store
    output wire [31:0] dataMemWriteData, // Data to be written to memory
    output wire isBranchTaken,         // Branch decision flag
    output wire isAdd,
    output wire isSub,
    output wire isSt, isLd, isMul,
output wire [31:0] op1, op2,
    output wire [31:0] branchPC ,        // Branch target program counter
    output wire [31:0] aluResult      // Final ALU result
);
    
    assign memoryAddress = memoryAddress;   // Wire from DataMemory
    assign dataMemWriteData = dataMemWriteData; // Wire from Execunit
    
    // Control Signals
    wire  isSub, isCmp, isLd, isSt, isRet, isCall, isMul, isDiv, isMod;
    wire isLsl, isLsr, isAsr, isOr, isAnd, isNot, isMov, isWb;
    wire isBEQ, isBGT, isUBranch;     // Separate branch signals for BEQ, BGT, Unconditional
    wire [31:0] inste;                 // Fetched instruction

    // Intermediate Wires
    wire [31:0] op1, op2, immx, branchTarget, ldResult, writeData;
    wire [31:0] memoryAddress, dataMemReadData, dataMemWriteData;
    wire [4:0] writeAddress, opcode; // Opcode and write address widths updated
    wire flagZero, flagNegative, dataMemWriteEnable;
    
    wire [31:0] ra;                   // Return address register

   

    

    // Instruction Fetch Unit
    InstructionFetchUnit fetch (
    .clk(clk),
    .reset(reset),
    .isBranchTaken(isBranchTaken),
    .branchPC(branchPC),
    .instFromTB(instFromTB),  // ✅ Enable testbench instruction loading
    .storeInst(storeInst),    // ✅ Enable signal to store instruction
    .storeAddress(storeAddress), // ✅ Address for storing instruction
    .pc(pc),  
    .inst(inst)
);

    // Control Unit
    ControlUnit control (
        .instFromTB(instFromTB),.clk(clk),
        .isAdd(isAdd), .isSub(isSub), .isCmp(isCmp), .isLd(isLd), .isSt(isSt),
        .isBEQ(isBEQ), .isBGT(isBGT), .isUBranch(isUBranch), // Branch signals added
        .isRet(isRet), .isCall(isCall),
        .isMul(isMul), .isDiv(isDiv), .isMod(isMod),
        .isLsl(isLsl), .isLsr(isLsr), .isAsr(isAsr),
        .isOr(isOr), .isAnd(isAnd), .isNot(isNot), .isMov(isMov), .isWb(isWb)
    );

    // Operand Fetch Unit
    OperandFetch operandFetch (
        .clk(clk),
        .isMov(isMov),
        .isCmp(isCmp),
        .rs1(inst[25:22]),           // Source register 1 (4 bits)
        .rs2(inst[21:18]),           // Source register 2 (4 bits)
        .rd(inst[17:14]),             // Destination register (4 bits)
        .ra(ra),                     // Return address
        .inst(inst),                 // Fetched instruction
        .pc(pc),                     // Program Counter
        .isRet(isRet), .isSt(isSt),  // Control signals
        .op1(op1), .op2(op2), .immx(immx), .opcode(opcode), .branchTarget(branchTarget)
    );

    // Execution Stage
    Execunit execute (
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .branchTarget(branchTarget),
        .pc(pc),
        .isAdd(isAdd), .isSub(isSub), .isCmp(isCmp),
        .isMul(isMul), .isDiv(isDiv), .isMod(isMod),
        .isLsl(isLsl), .isLsr(isLsr), .isAsr(isAsr),
        .isOr(isOr), .isAnd(isAnd), .isNot(isNot),
        .isMov(isMov), .isLd(isLd), .isSt(isSt),
        .isBEQ(isBEQ), .isBGT(isBGT), .isUBranch(isUBranch),
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

    // Data Memory
    DataMemory dataMemory (
        .clk(clk),
        .writeEnable(dataMemWriteEnable),
        .address(memoryAddress),
        .writeData(dataMemWriteData),
        .readData(dataMemReadData)
    );

    // Register Write Unit
    RegisterWriteUnit writeBack (
        .aluResult(aluResult),
        .ldResult(ldResult),
        .pc(pc),
        .ra(ra),
        .rd(inst[11:7]),
        .isLd(isLd),
        .isCall(isCall),
        .isWb(isWb),
        .writeData(writeData),
        .writeAddress(writeAddress),
        .writeEnable(dataMemWriteEnable)
    );

endmodule