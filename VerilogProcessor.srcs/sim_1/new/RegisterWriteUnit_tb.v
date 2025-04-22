`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2025 01:02:28
// Design Name: 
// Module Name: RegisterWriteUnit_tb
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

module RegisterWriteUnit_tb;

    // Inputs
    reg [31:0] aluResult;
    reg [31:0] ldResult;
    reg [31:0] pc;
    reg [31:0] ra;
    reg [4:0] rd;
    reg isLd, isCall, isWb;

    // Outputs
    wire [31:0] writeData;
    wire [4:0] writeAddress;
    wire writeEnable;

    // Instantiate the RegisterWriteUnit
    RegisterWriteUnit uut (
        .aluResult(aluResult),
        .ldResult(ldResult),
        .pc(pc),
        .ra(ra),
        .rd(rd),
        .isLd(isLd),
        .isCall(isCall),
        .isWb(isWb),
        .writeData(writeData),
        .writeAddress(writeAddress),
        .writeEnable(writeEnable)
    );

    // Test Sequence
    initial begin
        $monitor("Time: %0d | WriteData: %h | WriteAddress: %h | WriteEnable: %b",
                 $time, writeData, writeAddress, writeEnable);

        // Initialize Inputs
        aluResult = 32'h00000010; // Example ALU result
        ldResult = 32'h00000020; // Example loaded data
        pc = 32'h00000040;       // Example program counter
        ra = 32'h00000015;       // Example return address
        rd = 5'b01010;           // Example destination register address
        isLd = 0;
        isCall = 0;
        isWb = 0;

        // Test Case 1: ALU Result Writeback
        #10 isWb = 1;
        #10 isWb = 0;

        // Test Case 2: Load Instruction
        #10 isLd = 1; isWb = 1;
        #10 isLd = 0; isWb = 0;

        // Test Case 3: Call Instruction
        #10 isCall = 1; isWb = 1;
        #10 isCall = 0; isWb = 0;

        // Test Case 4: No Writeback
        #10 isWb = 0; isLd = 0; isCall = 0;

        $display("✅ RegisterWriteUnit Test Completed!");
        $finish; // End simulation
    end

endmodule
