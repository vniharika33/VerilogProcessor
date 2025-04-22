`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 22:51:20
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input wire clk,                     // Clock signal
    input wire writeEnable,             // Write enable signal (isSt)
    input wire [31:0] address,          // Memory address
    input wire [31:0] writeData,        // Data to write to memory
    output reg [31:0] readData          // Data read from memory
);

    reg [31:0] memory [0:255];          // Simple 256-word memory (32-bit each)
    integer i;
    // Initialize Memory
    initial begin
        
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 0; // Default all memory locations to zero
        end
    end

    // Write Operation on Positive Clock Edge
    always @(posedge clk) begin
        if (writeEnable) 
            memory[address[7:0]] <= writeData; // Address limited to 8 bits
    end

    // Read Operation on Positive Clock Edge
    always @(posedge clk) begin
        readData <= memory[address[7:0]];
    end

endmodule