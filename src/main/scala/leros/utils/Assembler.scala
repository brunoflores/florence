package leros.utils

import leros.shared.Constants._
import scala.io.Source

object Assembler {

  val prog = Array[Int](
    0x0903, // addi 0x3
    0x09ff, // -1
    0x0d02, // subi 2
    0x21ab, // ldi 0xab
    0x230f, // and 0x0f
    0x25c3, // or 0xc3
    0x0000
  )
  def getProgramFix() = prog

  def getProgram(prog: String) = {
    assemble(prog)
  }

  val symbols = collection.mutable.Map[String, Int]()

  def assemble(prog: String): Array[Int] = {
    assemble(prog, false)
    assemble(prog, true)
  }

  def assemble(prog: String, pass2: Boolean): Array[Int] = {
    val source = Source.fromFile(prog)
    var program = List[Int]()
    var pc = 0

    def toInt(s: String): Int = {
      if (s.startsWith("0x")) {
        Integer.parseInt(s.substring(2), 16) & 0xff
      } else {
        Integer.parseInt(s) & 0xff
      }
    }

    def regNumber(s: String): Int = {
      assert(s.startsWith("r"), "Register numbers shall start with \'r\': " + s)
      s.substring(1).toInt
    }

    for (line <- source.getLines()) {
      val tokens = line.trim().split(" ")
      def brOff = if (pass2) symbols(tokens(1)) - pc else 0
      val Pattern = "(.*:)".r
      val instr = tokens(0) match {
        case "//" => // comment
        case Pattern(l) =>
          if (!pass2) symbols += (l.substring(0, l.length - 1) -> pc)
        case "nop"     => (NOP << 8) + 0
        case "add"     => (ADD << 8) + regNumber(tokens(1))
        case "sub"     => (SUB << 8) + regNumber(tokens(1))
        case "and"     => (AND << 8) + regNumber(tokens(1))
        case "or"      => (OR << 8) + regNumber(tokens(1))
        case "xor"     => (XOR << 8) + regNumber(tokens(1))
        case "load"    => (LD << 8) + regNumber(tokens(1))
        case "addi"    => (ADDI << 8) + toInt(tokens(1))
        case "subi"    => (SUBI << 8) + toInt(tokens(1))
        case "andi"    => (ANDI << 8) + toInt(tokens(1))
        case "ori"     => (ORI << 8) + toInt(tokens(1))
        case "xori"    => (XORI << 8) + toInt(tokens(1))
        case "shr"     => (SHR << 8)
        case "loadi"   => (LDI << 8) + toInt(tokens(1))
        case "loadhi"  => (LDHI << 8) + toInt(tokens(1))
        case "loadh2i" => (LDH2I << 8) + toInt(tokens(1))
        case "loadh3i" => (LDH3I << 8) + toInt(tokens(1))
        case "store"   => (ST << 8) + regNumber(tokens(1))
        case "ldaddr"  => (LDADDR << 8)
        case "ldind"   => (LDIND << 8) + toInt(tokens(1))
        case "ldindbu" => (LDINDBU << 8) + toInt(tokens(1))
        case "stind"   => (STIND << 8) + toInt(tokens(1))
        case "stindb"  => (STINDB << 8) + toInt(tokens(1))
        case "br"      => (BR << 8) + brOff
        case "brz"     => (BRZ << 8) + brOff
        case "brnz"    => (BRNZ << 8) + brOff
        case "brp"     => (BRP << 8) + brOff
        case "brn"     => (BRN << 8) + brOff
        case "in"      => (IN << 8) + toInt(tokens(1))
        case "out"     => (OUT << 8) + toInt(tokens(1))
        case "scall"   => (SCALL << 8) + toInt(tokens(1))
        case ""        => // println("Empty line")
        case t: String =>
          throw new Exception("Assembler error: unknown instruction: " + t)
        case _ => throw new Exception("Assembler error")
      }
      instr match {
        case (a: Int) => {
          program = a :: program
          pc += 1
        }
        case _ => // println("Something else")
      }
    }

    val finalProg = program.reverse.toArray
    finalProg
  }
}
