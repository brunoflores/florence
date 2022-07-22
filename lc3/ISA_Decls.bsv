package ISA_Decls;

import Vector :: *;

typedef 16 XLEN;
Integer xlen = valueOf (XLEN);

typedef Bit #(XLEN) WordXL; // Raw (unsigned) register data
typedef Int #(XLEN) IntXL;  // Signed register data
typedef WordXL      Addr;   // addresses/pointers

typedef 8 Bits_per_Byte;
typedef Bit #(Bits_per_Byte) Byte;

typedef XLEN Bits_per_Word; // REDUNDANT to XLEN

typedef TDiv #(XLEN, Bits_per_Byte)      Bytes_per_WordXL;
typedef TLog #(Bytes_per_WordXL)         Bits_per_Byte_in_WordXL;
typedef Bit #(Bits_per_Byte_in_WordXL)   Byte_in_WordXL;
typedef Vector #(Bytes_per_WordXL, Byte) WordXL_B;

typedef XLEN                                 Bits_per_Addr;
typedef TDiv #(Bits_per_Addr, Bits_per_Byte) Bytes_per_Addr;

Integer bits_per_byte = valueOf (Bits_per_Byte);

Integer bytes_per_wordxl        = valueOf (Bytes_per_WordXL);
Integer bits_per_byte_in_wordxl = valueOf (Bits_per_Byte_in_WordXL);

Integer addr_lo_byte_in_wordxl = 0;
Integer addr_hi_byte_in_wordxl = addr_lo_byte_in_wordxl + bits_per_byte_in_wordxl - 1;

function Byte_in_WordXL fn_addr_to_byte_in_wordxl (Addr a);
  return a [addr_hi_byte_in_wordxl : addr_lo_byte_in_wordxl];
endfunction

// Tokens are used for signalling/synchronization, and have no payload.
typedef Bit #(0) Token;

typedef Bit #(XLEN) Instr;
typedef Bit #(4)    Opcode;
typedef Bit #(3)    RegName; // 8 registers, 0..7
typedef 8           NumRegs;
Integer numRegs = valueOf (NumRegs);

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
function Bit #(8) instr_trapvec8 (Instr x); return x [7:0]; endfunction

endpackage
