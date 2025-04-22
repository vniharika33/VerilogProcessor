
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 22:55:36
// Design Name: 
// Module Name: SingleCycleTinyRisc_tb
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

module SingleCycleTinyRisc_tb;

    // Inputs to the processor
    reg clk;
    reg reset;
    reg [31:0] instFromTB;
    reg storeInst;
    reg [7:0] storeAddress;

    // Outputs from the processor
    wire [31:0] pc;
    wire [31:0] inst;
    
    wire isBranchTaken;
    wire isAdd, isSub, isSt, isLd, isMul;
    wire [31:0] branchPC;
    wire [31:0] op1, op2;

    // Instantiate the SingleCycleTinyRisc module
    SingleCycleTinyRisc uut (
        .clk(clk),
        .reset(reset),
        .instFromTB(instFromTB),
        .storeInst(storeInst),
        .storeAddress(storeAddress),
        .inst(inst),
        .pc(pc),
        .memoryAddress(memoryAddress),
        .dataMemWriteData(dataMemWriteData),
        .isBranchTaken(isBranchTaken),
        .isAdd(isAdd),
        .isSub(isSub),
        .isSt(isSt),
        .isLd(isLd),
        .isMul(isMul),
        .op1(op1),
        .op2(op2),
        .branchPC(branchPC),
        .aluResult(aluResult)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Apply test cases
    initial begin
        $monitor("Time: %0d | PC: %h | Inst: %h |  BranchTaken: %b",
                 $time, pc, inst,  isBranchTaken);

        // Initialize inputs
        reset = 1;
        instFromTB = 0;
        storeInst = 0;
        storeAddress = 0;

        // Reset the processor
        #10 reset = 0;

        // Load an ADD instruction into the instruction memory
        #10 storeInst = 1;
        storeAddress = 8'd0;        // Store at memory address 0
        instFromTB = 32'b00000_0_0001_0010_0011_00000000000000;  // ADD instruction
        #10 storeInst = 0;

        // Load a SUB instruction
        #10 storeInst = 1;
        storeAddress = 8'd1;        // Store at memory address 1
        instFromTB = 32'b00001_0_0001_0010_0011_00000000000000;  // SUB instruction
        #10 storeInst = 0;

        // Load a BEQ (branch if equal) instruction
        #10 storeInst = 1;
        storeAddress = 8'd2;        // Store at memory address 2
        instFromTB = 32'b00010_0_0001_0010_0011_00000000000000;  // MUL instruction
        #10 storeInst = 0;

        // Let the processor run
        #100;

        $display("✅ SingleCycleTinyRisc Test Completed!");
        $finish; // End simulation
    end
    

endmodule

