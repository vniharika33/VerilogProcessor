`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2025 07:20:42
// Design Name: 
// Module Name: InstructionFetchUnit
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


module InstructionFetchUnit(
    input wire clk,                // Clock signal
    input wire reset,              // Reset signal
    input wire isBranchTaken,      // Branch control signal
    input wire [31:0] branchPC,    // Branch target address
    input wire [31:0] instFromTB,  // Instruction input from the testbench
    input wire storeInst,          // ✅ New signal: Enable storing instruction from TB
    input wire [7:0] storeAddress, // ✅ New signal: Address where TB instruction is stored
    output reg [31:0] pc,          // Current program counter
    output reg [31:0] inst         // Fetched instruction
);

    // Instruction Memory (256 words, each 32 bits)
    reg [31:0] instructionMemory [0:255];

    integer i;

    // Initialize PC and Memory
    initial begin
        pc = 0; // Start PC at 0

        // Initialize instruction memory to be empty
        for (i = 0; i < 256; i = i + 1) 
            instructionMemory[i] = 32'h00000000; // All instructions are empty initially
    end

    // Update PC on the positive clock edge
    always @(posedge clk or negedge reset) begin
        if (!reset)
            pc <= 0; // Reset PC to zero on falling edge of reset
        else
            pc <= isBranchTaken ? branchPC : (pc + 4); // Increment PC or branch
    end

    // Fetch the instruction from memory at the current PC
    always @(posedge clk) begin
        inst <= instructionMemory[pc[31:2]]; // Fetch instruction correctly
    end

    // ✅ Store instruction from testbench dynamically
    always @(posedge clk) begin
        if (storeInst) 
            instructionMemory[storeAddress] <= instFromTB; // ✅ Store at specified address
    end

endmodule

