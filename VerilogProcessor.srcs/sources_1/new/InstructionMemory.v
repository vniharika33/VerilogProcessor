`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2025 14:58:14
// Design Name: 
// Module Name: InstructionMemory
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

module InstructionMemory(
    input [31:0] addr,
    output reg [31:0] inst
);

    reg [31:0] memory [0:255]; // 256 instructions

    initial begin
        // Load instructions
        memory[0] = 32'b000000_00001_00010_00011_00000_000000; // ADD
        memory[1] = 32'b000001_00001_00010_00011_00000_000000; // SUB
        memory[2] = 32'b000011_00001_00000_00000_00000_000000; // LOAD
        memory[3] = 32'b000100_00001_00000_00000_00000_000000; // STORE
    end

    always @(*) begin
        inst = memory[addr[9:2]]; // Word-aligned access (addr/4)
    end

endmodule

