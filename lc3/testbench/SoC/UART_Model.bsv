export UART_IFC (..), mkUART;

import ClientServer::*;
import GetPut::*;
import ConfigReg::*;
import FIFOF::*;

import ISA_Decls::*;
import Cur_Cycle::*;

// UART registers and their address offsets

Bit #(3) addr_UART_rbr = 3'h_0; // receiver buffer register     (read only)
Bit #(3) addr_UART_thr = 3'h_0; // transmitter holding register (write only)
Bit #(3) addr_UART_ier = 3'h_1; // interrupt enable register
Bit #(3) addr_UART_iir = 3'h_2; // interrupt id register        (read-only)
Bit #(3) addr_UART_lcr = 3'h_3; // line control reg
Bit #(3) addr_UART_mcr = 3'h_4; // modem control reg
Bit #(3) addr_UART_lsr = 3'h_5; // line status reg              (read-only)
Bit #(3) addr_UART_msr = 3'h_6; // modem status reg             (read-only)
Bit #(3) addr_UART_scr = 3'h_7; // scratch pad reg

// Aliased registers, depending on control bits
Bit #(3) addr_UART_dll = 3'h_0; // divisor latch low
Bit #(3) addr_UART_dlm = 3'h_1; // divisor latch high
Bit #(3) addr_UART_fcr = 3'h_2; // fifo control reg    (write-only)

// Bit fields of ier (Interrupt Enable Register)
Bit #(8) uart_ier_erbfi = 8'h_01; // Enable Received Data Available Interrupt
Bit #(8) uart_ier_etbei = 8'h_02; // Enable Transmitter Holding Register Empty Interrupt
Bit #(8) uart_ier_elsi  = 8'h_04; // Enable Receiver Line Status Interrupt
Bit #(8) uart_ier_edssi = 8'h_08; // Enable Modem Status Interrupt

// iir values (Interrupt Identification Register) in decreasing priority of interrupts
Bit #(8) uart_iir_none = 8'h_01; // None (no interrupts pending)
Bit #(8) uart_iir_rls  = 8'h_06; // Receiver Line Status
Bit #(8) uart_iir_rda  = 8'h_04; // Received Data Available
Bit #(8) uart_iir_cti  = 8'h_0C; // Character Timeout Indication
Bit #(8) uart_iir_thre = 8'h_02; // Transmitter Holding Register Empty
Bit #(8) uart_iir_ms   = 8'h_00; // Modem Status

// Bit fields of LCR
Bit #(8) uart_lcr_dlab = 8'h_80; // Divisor latch access bit
Bit #(8) uart_lcr_bc   = 8'h_40; // Break control
Bit #(8) uart_lcr_sp   = 8'h_20; // Stick parity
Bit #(8) uart_lcr_eps  = 8'h_10; // Even parity
Bit #(8) uart_lcr_pen  = 8'h_08; // Parity enable
Bit #(8) uart_lcr_stb  = 8'h_04; // # of stop bits (0=1b,1=2b)
Bit #(8) uart_lcr_wls  = 8'h_03; // word len (0:5b,1:6b,2:7b,3:8b)

// Bit fields of LSR
Bit #(8) uart_lsr_rxfe = 8'h_80; // Receiver FIFO error
Bit #(8) uart_lsr_temt = 8'h_40; // Transmitter empty
Bit #(8) uart_lsr_thre = 8'h_20; // THR empty
Bit #(8) uart_lsr_bi   = 8'h_10; // Break interrupt
Bit #(8) uart_lsr_fe   = 8'h_08; // Framing Error
Bit #(8) uart_lsr_pe   = 8'h_04; // Parity Error
Bit #(8) uart_lsr_oe   = 8'h_02; // Overrun Error
Bit #(8) uart_lsr_dr   = 8'h_01; // Data Ready

Bit #(8) uart_lsr_reset_value = (uart_lsr_temt | uart_lsr_thre);

interface UART_IFC;
  // Reset
  interface Server #(Token, Token) server_reset;

  // set_addr_map should be called after this module's reset
  // method Action set_addr_map (Bit #(32) addr_base, Bit #(32) addr_lim);

  // Main Fabric Reqs/Rsps
  // interface AXI4_Slave_IFC #(Wd_Id, Wd_Addr, Wd_Data, Wd_User) slave;

  // To external console
  interface Get #(Bit #(8)) get_to_console;
  interface Put #(Bit #(8)) put_from_console;

  // Interrupt pending
  (* always_ready *)
  method Bool intr;
endinterface

// Module state
typedef enum {
  STATE_START,
  STATE_READY
} Module_State
deriving (Bits, Eq, FShow);

// UART reg addresses should be at stride 4 or 8.
Integer address_stride = 4;

(* synthesize *)
module mkUART (UART_IFC);
  Reg #(Bit #(8)) cfg_verbosity <- mkConfigReg (0);
  Reg #(Module_State) rg_state <- mkReg (STATE_START);

  FIFOF #(Token) f_reset_reqs <- mkFIFOF;
  FIFOF #(Token) f_reset_rsps <- mkFIFOF;

  // Character queues to and from external circuitry for the console
  FIFOF #(Bit #(8)) f_from_console <- mkFIFOF;
  FIFOF #(Bit #(8)) f_to_console <- mkFIFOF;

  // These are the 16550 UART registers
  Reg #(Bit #(8)) rg_rbr <- mkRegU;                          // addr offset 0
  Reg #(Bit #(8)) rg_thr <- mkRegU;                          // addr offset 0
  Reg #(Bit #(8)) rg_dll <- mkReg (0);                       // addr offset 0

  Reg #(Bit #(8)) rg_ier <- mkReg (0);                       // addr offset 1
  Reg #(Bit #(8)) rg_dlm <- mkReg (0);                       // addr offset 1

  // IIR is a virtal read-only register computed
  // from other regs
  Reg #(Bit #(8)) rg_fcr <- mkReg (0);                       // addr offset 2

  Reg #(Bit #(8)) rg_lcr <- mkReg (0);                       // addr offset 3
  Reg #(Bit #(8)) rg_mcr <- mkReg (0);                       // addr offset 4
  Reg #(Bit #(8)) rg_lsr <- mkReg (uart_lsr_reset_value);    // addr offset 5
  Reg #(Bit #(8)) rg_msr <- mkReg (0);                       // addr offset 6
  Reg #(Bit #(8)) rg_scr <- mkReg (0);                       // addr offset 7

  // Virtual read-only register IIR
  function Bit #(8) fn_iir ();
    Bit #(8) iir = uart_iir_none;

    if (((rg_ier & uart_ier_erbfi) != 0)       // Rx interrupt enabled
        && ((rg_lsr & uart_lsr_dr) != 0))      // data ready
      iir = uart_iir_rda;
    else if ((rg_ier & uart_ier_etbei) != 0)   // Tx Holding Reg Empty intr enabled
      iir = uart_iir_thre;

    return iir;
  endfunction

  // Test if an interrupt is pending
  function Bool fn_intr ();
    let iir = fn_iir ();
    Bool eip = ((iir & uart_iir_none) == 0);
    return eip;
  endfunction

  // Soft reset (on token in f_reset_reqs)
  rule rl_reset;
    f_reset_reqs.deq;

    rg_dll <= 0;
    rg_ier <= 0;
    rg_dlm <= 0;
    rg_fcr <= 0;
    rg_lcr <= 0;
    rg_mcr <= 0;
    rg_lsr <= uart_lsr_reset_value;
    rg_msr <= 0;
    rg_scr <= 0;

    rg_state <= STATE_READY;

    f_reset_rsps.enq (?);

    if (cfg_verbosity != 0) $display ("%0d: UART.rl_reset", cur_cycle);
  endrule

  // Handle fabric read requests
  rule rl_process_rd_req (rg_state == STATE_READY);
    // let rda <- pop_o (slave_xactor.o_rd_addr);

    Bit #(8) rdata_byte = 0;

	// Read an input char
	rg_lsr <= (rg_lsr & (~uart_lsr_dr)); // Reset data-ready
	rdata_byte = rg_rbr;

    if (cfg_verbosity > 1) begin
      $display ("%0d: %m.rl_process_rd_req", cur_cycle);
      // $display ("            ", fshow (rda));
      // $display ("            ", fshow (rdr));
    end
  endrule

  // Handle fabric write requests
  // rule rl_process_wr_req (rg_state == STATE_READY);
  // endrule

  // Reset
  interface server_reset = toGPServer (f_reset_reqs, f_reset_rsps);

  // To external console
  interface put_from_console = toPut (f_from_console);
  interface get_to_console   = toGet (f_to_console);

  // Interrupt pending
  method Bool  intr;
    return fn_intr ();
  endmethod
endmodule
