`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2023 13:21:38
// Design Name: 
// Module Name: sim
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


module test_riscv_control_unit();

    // Inputs
    reg [31:0] Ins;
    reg clk;
    reg en;
    // Outputs
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [3:0] alu_control;
    wire MemWrite;
    wire Is_Imm;
    wire RegWrite;
    
    
    // Instantiate the Unit Under Test (UUT)
    control_unit  uut(        
        .Ins(Ins),
        .clk(clk),
        .en(en),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .alu_control(alu_control),
        .MemWrite(MemWrite),
        .Is_Imm(Is_Imm),
        .RegWrite(RegWrite)
    );

    // Initialize Inputs
    initial begin
    clk = 1'b0;
    end
    always #1 clk=~clk;
    
    initial begin
    Ins=0;
    en =1'b0;
    #2
    en =1'b1;
    Ins = 32'b0100_0001_0101_1010_0000_0100_1011_0011;
    #16
    Ins = 32'b0000_0001_0101_1010_0000_0100_1001_0011;
    #5
    Ins = 32'b0100_0001_0101_1010_0000_0100_1011_0011;
    #1
    Ins = 32'b0000_0001_0101_1010_0001_0100_1011_0011;
    #10
    Ins = 32'b0000_0001_0101_1010_0001_0000_1011_0011;
    #16
    Ins = 32'b0000_0001_0101_1010_0001_0100_1010_0011;
    #16
    Ins = 32'b0000_0001_0101_1010_0000_0100_1110_0011;
    end


endmodule