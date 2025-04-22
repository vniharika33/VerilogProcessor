`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 22:47:04
// Design Name: 
// Module Name: RegisterWriteUnit
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


module RegisterWriteUnit(
    input wire [31:0] aluResult,        // ALU result (from Execution Stage)
    input wire [31:0] ldResult,         // Loaded data (from Memory Access Unit)
    input wire [31:0] pc,               // Program counter
    input wire [31:0] ra,               // Return address register (R15 for 'call')
    input wire [4:0] rd,                // Destination register (inst[11:7])
    input wire isLd,                    // Control signal for load instruction
    input wire isCall,                  // Control signal for call instruction
    input wire isWb,                    // Control signal for writeback
    output wire [31:0] writeData,       // Data to be written to the register file
    output wire [4:0] writeAddress,     // Address of register to be written
    output wire writeEnable             // Write enable signal
);

    // Register File Write Control Logic
    reg [31:0] muxResult;  // Result after selecting source data
    reg [4:0] muxAddress;  // Address after selecting destination register

    // Initialize Outputs to Avoid Undefined Values
    initial begin
        muxResult = 0;
        muxAddress = 0;
    end

    // Multiplexer to Select Write Data (aluResult, ldResult, or pc)
    always @(*) begin
        case ({isLd, isCall})
            2'b01: muxResult = pc + 4;  // Ensure PC increments when storing for a call
            2'b10: muxResult = ldResult; // If 'load', use loaded data
            default: muxResult = aluResult; // Default to ALU result
        endcase
    end

    // Multiplexer to Select Write Address (ra or rd)
    always @(*) begin
        if (isCall)
            muxAddress = ra; // If 'call', write to return address register
        else if (isWb)
            muxAddress = rd; // If writeback is enabled, write to destination register
        else
            muxAddress = 5'b00000; // Default to register 0 (RISC convention)
    end

    // Write Enable Signal
    assign writeEnable = isWb;

    // Outputs
    assign writeData = muxResult;
    assign writeAddress = muxAddress;

endmodule