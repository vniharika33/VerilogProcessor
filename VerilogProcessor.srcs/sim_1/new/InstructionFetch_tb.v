`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2025 16:17:35
// Design Name: 
// Module Name: InstructionFetch_tb
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

module InstructionFetch_tb;

    reg clk;
    reg reset;
    wire [31:0] pc;  // Program Counter
    wire [31:0] inst; // Fetched instruction

    // Instantiate Instruction Fetch Unit
    InstructionFetchUnit uut (
        .clk(clk),
        .reset(reset),
        .isBranchTaken(1'b0), // No branches for this test
        .branchPC(32'b0),     // No branch address
        .instFromTB(32'b0),   // No dynamic instruction input
        .pc(pc),
        .inst(inst)
    );

    // Generate Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5 time units
    end

    // Apply Reset
    initial begin
        reset = 1; // Assert reset
        #10;       // Hold for one clock cycle
        reset = 0; // Deassert reset
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0d | PC: %h", $time, pc);

        #50; // Let the simulation run for a few cycles
        $finish;
    end

endmodule
