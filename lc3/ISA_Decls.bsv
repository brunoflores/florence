typedef 16 XLEN;
Integer xlen = valueOf(XLEN);

typedef Bit #(XLEN) UInt;  // Raw (unsigned) register data
typedef UInt Word;
typedef Int #(XLEN) IInt;  // Signed register data

typedef 8 Bits_per_Byte;
typedef Bit #(Bits_per_Byte) Byte;

// Tokens are used for signalling/synchronization, and have no payload
typedef Bit #(0) Token;

// ================================================================
// Instruction fields

typedef  Bit #(16) Instr;
typedef  Bit #(4)  Opcode;
typedef  Bit #(3)  RegName; // 8 registers, 0..7
typedef  8         NumRegs;
Integer  numRegs = valueOf (NumRegs);

Instr illegal_instr = 16'h0000;

function Opcode instr_opcode (Instr x); return x [15:12]; endfunction

// Used by AND, AND, LD, LDI, LDR, LEA and NOT.
function Bit #(3) instr_dr (Instr x); return x [11:9]; endfunction

// Used by ADD and AND.
function Bit #(3) instr_sr1 (Instr x); return x [8:6]; endfunction
function Bit #(3) instr_sr2 (Instr x); return x [2:0]; endfunction
function Bit #(1) instr_mode (Instr x); return x [5]; endfunction
function Bit #(5) instr_imm5 (Instr x); return x [4:0]; endfunction

// Used by NOT, ST, STI and STR.
function Bit #(3) instr_sr (Instr x); return x [8:6]; endfunction

// Condition codes.
function Bit #(1) instr_n (Instr x); return x [11]; endfunction
function Bit #(1) instr_z (Instr x); return x [10]; endfunction
function Bit #(1) instr_p (Instr x); return x [9]; endfunction

// Used by BR, LD and LDI.
function Bit #(9) instr_pcoffset9 (Instr x); return x [8:0]; endfunction

// Used by JSR.
function Bit #(11) instr_pcoffset11 (Instr x); return x [10:0]; endfunction

// Used by JMP, JSRR, LDR, and STR.
function Bit #(3) instr_baser (Instr x); return x [8:6]; endfunction

// Used by LDR and STR.
function Bit #(6) instr_offset6 (Instr x); return x [5:0]; endfunction

// Used by TRAP.
function Bit #(8) instr_trapvect8 (Instr x); return x [7:0]; endfunction

// Decoded instructions
typedef struct {
  Opcode opcode;

  RegName dr;
  RegName sr;
  RegName sr1;
  RegName sr2;
  // CSR_Addr csr;

  Bit #(5) imm5;
  Bit #(9) pcoffset9;
  Bit #(11) pcoffset11;
  Bit #(6) offset6;
  Bit #(3) baser;
  Bit #(8) trapvect8;
} Decoded_Instr
deriving (FShow, Bits);

function Decoded_Instr fv_decode (Instr instr);
  return Decoded_Instr {
     opcode: instr_opcode (instr),
     dr: instr_dr (instr),
     sr: instr_sr (instr),
     sr1: instr_sr1 (instr),
     sr2: instr_sr2 (instr),
     // csr: instr_csr (instr)
     // csr: 12'b0,
     imm5: instr_imm5 (instr),
     pcoffset9: instr_pcoffset9 (instr),
     pcoffset11: instr_pcoffset11 (instr),
     offset6: instr_offset6 (instr),
     baser: instr_baser (instr),
     trapvect8: instr_trapvect8 (instr)
  };
endfunction

// Symbolic register names
RegName x0 = 0;
RegName x1 = 1;
RegName x2 = 2;
RegName x3 = 3;
RegName x4 = 4;
RegName x5 = 5;
RegName x6 = 6;
RegName x7 = 7;

// Instructions
Opcode op_add  = 4'b0001;
Opcode op_and  = 4'b0101;
Opcode op_br   = 4'b0000;
Opcode op_jmp  = 4'b1100;
Opcode op_jsr  = 4'b0100;
Opcode op_jsrr = 4'b0100;
Opcode op_ld   = 4'b0010;
Opcode op_ldi  = 4'b1010;
Opcode op_ldr  = 4'b0110;
Opcode op_lea  = 4'b1110;
Opcode op_not  = 4'b1001;
Opcode op_ret  = 4'b1100;
Opcode op_rti  = 4'b1000;
Opcode op_st   = 4'b0011;
Opcode op_sti  = 4'b1011;
Opcode op_str  = 4'b0111;
Opcode op_trap = 4'b1111;
// 1101 reserved

// Control/Status registers
typedef Bit #(2) CSR_Addr;
CSR_Addr csr_addr_mcycle = 2'b00; // Machine cycle counter

// MISA
typedef struct {
   Bit #(2) mxl;
   Bit #(1) i;
} MISA
deriving (Bits);

Bit #(2) misa_mxl_zero  = 0;
Bit #(2) misa_mxl_16    = 1;

function Word misa_to_word (MISA ms);
   return {
     ms.mxl,
     0, // expands appropriately
     ms.i
   };
endfunction

function MISA word_to_misa (Word x);
   return MISA {
      mxl: x[xlen-1:xlen-2],
      i: x[8]
   };
endfunction

instance FShow #(MISA);
  function Fmt fshow (MISA misa);
    let fmt_mxl = case (misa.mxl)
                    1: $format("mxl 16");
                    default: $format("mxl unknown %0d", misa.mxl);
                  endcase;
    return (
         fmt_mxl
       + $format((misa.i == 1'b1) ? "I": "")
    );
  endfunction
endinstance
