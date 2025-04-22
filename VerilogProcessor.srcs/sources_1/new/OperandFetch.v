`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.04.2025 22:33:18
// Design Name: 
// Module Name: OperandFetch
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

module OperandFetch(
    input wire clk,
    input wire isMov,
    input wire isCmp,
    input wire [3:0] rs1,              // Source register 1 (inst[19:15])
    input wire [3:0] rs2,              // Source register 2 (inst[24:20])
    input wire [3:0] rd,               // Destination register (inst[11:7])
    input wire [31:0] ra,              // Return address register (R15 for 'ret')
    input wire [31:0] inst,            // Instruction
    input wire [31:0] pc,              // Program counter
    input wire isRet,                  // Control signal for 'ret' instruction
    input wire isSt,                   // Control signal for store instruction 
    output wire [31:0] op1,            // Operand 1
    output wire [31:0] op2,            // Operand 2
    output wire [31:0] immx,           // Extended immediate
    output wire [4:0] opcode,          // Extracted opcode
    output wire [31:0] branchTarget    // Branch target address
);

    // Register File: 32 registers, each 32 bits wide
    reg [31:0] registerFile [0:15]; // Original 32-register design
    integer i;

    // Initialize Register File
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registerFile[i] = i; // Assign incremental values
        end
    end
    always @(posedge clk) begin // ✅ Ensure MOV happens on clock edge
    if (isMov) begin
        registerFile[rd] <= immx;  // ✅ MOV stores immediate in destination register
    end
end


    // Extract opcode
    assign opcode = inst[31:28];

    // Assign operands based on control logic
    assign op1 = (isRet) ? ra : registerFile[rs1];
    assign op2 = (isSt) ? registerFile[rs2] : registerFile[rs2];

    // Calculate immx (extended immediate from inst[1:18])
    assign immx = {{14{inst[17]}}, inst[17:0]}; // Sign extension for imm (18 bits)

    // Compute branchTarget (pc + shifted and sign-extended immediate)
    assign branchTarget = pc + (immx << 2);

endmodule
