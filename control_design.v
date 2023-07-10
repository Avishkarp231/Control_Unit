`timescale 1ns / 1ps

module control_unit (
  input [31:0] Ins,
  input clk,
  input en,
  output reg Branch,
  output reg MemRead,
  output reg MemtoReg,
  output reg [3:0] alu_control,
  output reg MemWrite,
  output reg Is_Imm,
  output reg RegWrite,
  
);
reg [31:0]temp,
reg done
reg [6:0]opcode;
reg [6:0]func7;
reg [2:0]func3;

always @(*) begin
Branch = 1'b0;
MemRead = 1'b0;
MemtoReg = 1'b0;
alu_control = 4'b0000;
MemWrite = 1'b0;
Is_Imm = 1'b0;
RegWrite = 1'b0;


if(en==0)
begin
done=1;
temp=Ins;
end

else
begin

if(temp!=Ins && done ) begin
temp=Ins;
opcode =  Ins[6:0];
func7 = Ins[31:25];
func3 = Ins[14:12];
done=1'b0;

    case (opcode)
      // R-type instructions
      
      7'b0110011: begin
       Is_Imm = 1'b0;
       #2 
        MemRead = 1'b0;
        
        #2
        case (func3)
          3'b000: begin // ADD, SUB
            case (func7)
              7'b0000000: alu_control = 4'b0010; // ADD
              7'b0100000: alu_control = 4'b0110; // SUB
            endcase
          end
          3'b001: alu_control = 4'b0000; // SLL
          3'b010: alu_control = 4'b0011; // SLT
          3'b011: alu_control = 4'b0100; // SLTU
          3'b100: alu_control = 4'b0001; // XOR
          3'b101: begin // SRL, SRA
          
            case (func7)
              7'b0000000: alu_control = 4'b0101; // SRL
              7'b0100000: alu_control = 4'b0111; // SRA
            endcase
          end
          3'b110: alu_control = 4'b1000; // OR
          3'b111: alu_control = 4'b1001; // AND
        endcase
        #2
        MemWrite = 1'b0;
        #2
        MemtoReg = 1'b0;
        #2
        RegWrite = 1'b1;
        #2
        Branch = 1'b0;
        #2
        done=1'b1;
      end
       // I-type instructions
      7'b0010011: begin
        Is_Imm = 1'b1;
        #2 
        MemRead = 1'b0;
        #2
        case (func3)
          3'b000: alu_control = 4'b0010; // ADDI
          3'b010: alu_control = 4'b0011; // SLTI
          3'b011: alu_control = 4'b0100; // SLTIU
          3'b100: alu_control = 4'b0001; // XORI
          3'b110: alu_control = 4'b1000; // ORI
          3'b111: alu_control = 4'b1001; // ANDI
        endcase
        #2
        MemWrite = 1'b0;
        #2
        MemtoReg = 1'b0;
        #2
        RegWrite = 1'b1;
        #2
        Branch = 1'b0;
        #2
        done=1'b1;
      end
         // Load instructions
      7'b0000011: begin
      Is_Imm = 1'b1;
      #2
        MemRead = 1'b1;
        
      #2
        
        case (func3)
                3'b000: alu_control = 4'b0010; // LB
      3'b001: alu_control = 4'b0010; // LH
      3'b010: alu_control = 4'b0010; // LW
      3'b100: alu_control = 4'b0010; // LBU
      3'b101: alu_control = 4'b0010; // LHU
    endcase
        #2
        MemWrite = 1'b0;
        #2
        MemtoReg = 1'b1;
        #2        
        RegWrite = 1'b1;
        #2
        Branch = 1'b0;
        #2
        done = 1;
  end
  // Store instructions
  7'b0100011: begin
    
    Is_Imm = 1'b1;
    #2
        MemRead = 1'b0;
        
    #2
    case (func3)
      3'b000: alu_control = 4'b0010; // SB
      3'b001: alu_control = 4'b0010; // SH
      3'b010: alu_control = 4'b0010; // SW
    endcase
        #2
        MemWrite = 1'b1;
        #2
        MemtoReg = 1'b0;
        #2        
        RegWrite = 1'b0;
        #2
        Branch = 1'b0;
        #2
        done = 1;
  end
  // Branch instructions
  7'b1100011: begin
    
    Is_Imm = 1'b1;
    #2
    MemRead = 1'b1;
    #2
    case (func3)
      3'b000: alu_control = 4'b0001; // BEQ
      3'b001: alu_control = 4'b1001; // BNE
      3'b100: alu_control = 4'b0011; // BLT
      3'b101: alu_control = 4'b0100; // BGE
      3'b110: alu_control = 4'b0111; // BLTU
      3'b111: alu_control = 4'b1000; // BGEU
    endcase
            #2
        
        MemWrite = 1'b0;
        #2
        MemtoReg = 1'b1;
        #2        
        RegWrite = 1'b1;
        #2
        Branch = 1'b1;
        #2
        done = 1;
  end
  // Jal and Jalr instructions
  7'b1101111, 7'b1100111: begin
  Is_Imm = 1'b1;
  #2
   MemRead = 1'b0;
  #2
  alu_control = 4'b0111;
  #2
 
  MemWrite = 1'b0;
  #2
  RegWrite = 1'b1;
  #2
   MemtoReg = 1'b0;
   #2
    Branch = 1'b1;
    #2
    done = 1;
  end  
endcase
end
end
end
endmodule