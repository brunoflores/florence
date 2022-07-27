import ClientServer::*;
// The ConfigReg package provides a way to create registers
// where each update clobbers the current value, but the
// precise timing of updates is not important.
import ConfigReg::*;
import FIFOF::*;
import GetPut::*;

import ISA_Decls::*;
import GetPut_Aux::*;
import CSR_MIE::*;

interface CSR_RegFile_IFC;
  // Reset
  interface Server #(Token, Token) server_reset;

    // CSR read (w.o. side effect)
    (* always_ready *)
    method Maybe #(WordXL) read_csr (CSR_Addr csr_addr);

    // Read MCYCLE
    (* always_ready *)
    method WordXL read_csr_mcycle;

    // Read MIP
    (* always_ready *)
    method WordXL csr_mip_read;
  endinterface: CSR_RegFile_IFC

  // Major states of mkCSR_RegFile module
  typedef enum { RF_RESET_START, RF_RUNNING } RF_State
  deriving (Eq, Bits, FShow);

  (* synthesize *)
  module mkCSR_RegFile (CSR_RegFile_IFC);
    Reg #(Bit #(4)) cfg_verbosity <- mkConfigReg (0);
    Reg #(RF_State) rg_state <- mkReg (RF_RESET_START);

    // Reset
    FIFOF #(Token) f_reset_rsps <- mkFIFOF;

    // Machine interrupt-enable (mie)
    CSR_MIE_IFC csr_mie <- mkCSR_MIE;
    // Machine interrupt-pending (mip)
    CSR_MIP_IFC csr_mip <- mkCSR_MIP;

    Reg #(Bit #(XLEN)) rg_mcycle <- mkReg (0);
    RWire #(Bit #(XLEN)) rw_mcycle <- mkRWire;

    function Maybe #(WordXL) fv_csr_read (CSR_Addr csr_addr);
      Maybe #(WordXL) m_csr_value = tagged Invalid;
      case (csr_addr)
	    csr_addr_mcycle: m_csr_value = tagged Valid (truncate (rg_mcycle));
	    default: m_csr_value = tagged Invalid;
	  endcase
      return m_csr_value;
    endfunction: fv_csr_read

    rule rl_reset_start (rg_state == RF_RESET_START);
      rg_state <= RF_RUNNING;
    endrule: rl_reset_start

    // CYCLE counter
    (* no_implicit_conditions, fire_when_enabled *)
    rule rl_mcycle_incr;
      rg_mcycle <= rg_mcycle + 1;
    endrule: rl_mcycle_incr

    // Reset
    interface Server server_reset;
      interface Put request;
        method Action put (Token token);
          rg_state <= RF_RESET_START;
          f_reset_rsps.enq (?);
        endmethod
      endinterface:request

      interface Get response;
        method ActionValue #(Token) get if (rg_state == RF_RUNNING);
          let token <- pop (f_reset_rsps);
          return token;
        endmethod
    endinterface: response
endinterface: server_reset

// CSR read (w.o. side effect)
method Maybe #(WordXL) read_csr (CSR_Addr csr_addr);
  return fv_csr_read (csr_addr);
endmethod: read_csr

// Read MCYCLE
method WordXL read_csr_mcycle;
  return rg_mcycle;
endmethod: read_csr_mcycle

// Read MIP
method WordXL csr_mip_read;
  return csr_mip.mv_read;
endmethod: csr_mip_read

endmodule: mkCSR_RegFile
