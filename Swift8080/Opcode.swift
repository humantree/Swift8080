//
//  Opcode.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 1/29/18.
//  Copyright © 2018 humantree. All rights reserved.
//

import Foundation

enum Opcode: UInt8 {
  // MARK: Carry bit instructions
  case CMC = 0x3F
  case STC = 0x37

  // MARK: Single register instructions
  case INR_B = 0x04
  case INR_C = 0x0C
  case INR_D = 0x14
  case INR_E = 0x1C
  case INR_H = 0x24
  case INR_L = 0x2C
  case INR_M = 0x34
  case INR_A = 0x3C

  case DCR_B = 0x05
  case DCR_C = 0x0D
  case DCR_D = 0x15
  case DCR_E = 0x1D
  case DCR_H = 0x25
  case DCR_L = 0x2D
  case DCR_M = 0x35
  case DCR_A = 0x3D

  case CMA = 0x2F
  case DAA = 0x27

  // MARK: NOP instruction
  case NOP = 0x00

  // MARK: Data transfer instructions
  case MOV_B_B = 0x40
  case MOV_B_C = 0x41
  case MOV_B_D = 0x42
  case MOV_B_E = 0x43
  case MOV_B_H = 0x44
  case MOV_B_L = 0x45
  case MOV_B_M = 0x46
  case MOV_B_A = 0x47
  case MOV_C_B = 0x48
  case MOV_C_C = 0x49
  case MOV_C_D = 0x4A
  case MOV_C_E = 0x4B
  case MOV_C_H = 0x4C
  case MOV_C_L = 0x4D
  case MOV_C_M = 0x4E
  case MOV_C_A = 0x4F
  case MOV_D_B = 0x50
  case MOV_D_C = 0x51
  case MOV_D_D = 0x52
  case MOV_D_E = 0x53
  case MOV_D_H = 0x54
  case MOV_D_L = 0x55
  case MOV_D_M = 0x56
  case MOV_D_A = 0x57
  case MOV_E_B = 0x58
  case MOV_E_C = 0x59
  case MOV_E_D = 0x5A
  case MOV_E_E = 0x5B
  case MOV_E_H = 0x5C
  case MOV_E_L = 0x5D
  case MOV_E_M = 0x5E
  case MOV_E_A = 0x5F
  case MOV_H_B = 0x60
  case MOV_H_C = 0x61
  case MOV_H_D = 0x62
  case MOV_H_E = 0x63
  case MOV_H_H = 0x64
  case MOV_H_L = 0x65
  case MOV_H_M = 0x66
  case MOV_H_A = 0x67
  case MOV_L_B = 0x68
  case MOV_L_C = 0x69
  case MOV_L_D = 0x6A
  case MOV_L_E = 0x6B
  case MOV_L_H = 0x6C
  case MOV_L_L = 0x6D
  case MOV_L_M = 0x6E
  case MOV_L_A = 0x6F
  case MOV_M_B = 0x70
  case MOV_M_C = 0x71
  case MOV_M_D = 0x72
  case MOV_M_E = 0x73
  case MOV_M_H = 0x74
  case MOV_M_L = 0x75
  case MOV_M_A = 0x77
  case MOV_A_B = 0x78
  case MOV_A_C = 0x79
  case MOV_A_D = 0x7A
  case MOV_A_E = 0x7B
  case MOV_A_H = 0x7C
  case MOV_A_L = 0x7D
  case MOV_A_M = 0x7E
  case MOV_A_A = 0x7F

  case STAX_B = 0x02
  case STAX_D = 0x12
  case LDAX_B = 0x0A
  case LDAX_D = 0x1A

  // MARK: Register or memory to accumulator instructions
  case ADD_B = 0x80
  case ADD_C = 0x81
  case ADD_D = 0x82
  case ADD_E = 0x83
  case ADD_H = 0x84
  case ADD_L = 0x85
  case ADD_M = 0x86
  case ADD_A = 0x87

  case ADC_B = 0x88
  case ADC_C = 0x89
  case ADC_D = 0x8A
  case ADC_E = 0x8B
  case ADC_H = 0x8C
  case ADC_L = 0x8D
  case ADC_M = 0x8E
  case ADC_A = 0x8F

  case SUB_B = 0x90
  case SUB_C = 0x91
  case SUB_D = 0x92
  case SUB_E = 0x93
  case SUB_H = 0x94
  case SUB_L = 0x95
  case SUB_M = 0x96
  case SUB_A = 0x97

  case SBB_B = 0x98
  case SBB_C = 0x99
  case SBB_D = 0x9A
  case SBB_E = 0x9B
  case SBB_H = 0x9C
  case SBB_L = 0x9D
  case SBB_M = 0x9E
  case SBB_A = 0x9F

  case ANA_B = 0xA0
  case ANA_C = 0xA1
  case ANA_D = 0xA2
  case ANA_E = 0xA3
  case ANA_H = 0xA4
  case ANA_L = 0xA5
  case ANA_M = 0xA6
  case ANA_A = 0xA7

  case XRA_B = 0xA8
  case XRA_C = 0xA9
  case XRA_D = 0xAA
  case XRA_E = 0xAB
  case XRA_H = 0xAC
  case XRA_L = 0xAD
  case XRA_M = 0xAE
  case XRA_A = 0xAF

  case ORA_B = 0xB0
  case ORA_C = 0xB1
  case ORA_D = 0xB2
  case ORA_E = 0xB3
  case ORA_H = 0xB4
  case ORA_L = 0xB5
  case ORA_M = 0xB6
  case ORA_A = 0xB7

  case CMP_B = 0xB8
  case CMP_C = 0xB9
  case CMP_D = 0xBA
  case CMP_E = 0xBB
  case CMP_H = 0xBC
  case CMP_L = 0xBD
  case CMP_M = 0xBE
  case CMP_A = 0xBF

  // MARK: Rotate accumulator instructions
  case RLC = 0x07
  case RRC = 0x0F
  case RAL = 0x17
  case RAR = 0x1F

  // MARK: Register pair instructions
  case PUSH_B   = 0xC5
  case PUSH_D   = 0xD5
  case PUSH_H   = 0xE5
  case PUSH_PSW = 0xF5

  case POP_B   = 0xC1
  case POP_D   = 0xD1
  case POP_H   = 0xE1
  case POP_PSW = 0xF1

  case DAD_B  = 0x09
  case DAD_D  = 0x19
  case DAD_H  = 0x29
  case DAD_SP = 0x39

  case INX_B  = 0x03
  case INX_D  = 0x13
  case INX_H  = 0x23
  case INX_SP = 0x33

  case DCX_B  = 0x0B
  case DCX_D  = 0x1B
  case DCX_H  = 0x2B
  case DCX_SP = 0x3B

  case XCHG = 0xEB
  case XTHL = 0xE3
  case SPHL = 0xF9

  // MARK: Immediate instructions
  case LXI_B  = 0x01
  case LXI_D  = 0x11
  case LXI_H  = 0x21
  case LXI_SP = 0x31

  case MVI_B = 0x06
  case MVI_C = 0x0E
  case MVI_D = 0x16
  case MVI_E = 0x1E
  case MVI_H = 0x26
  case MVI_L = 0x2E
  case MVI_M = 0x36
  case MVI_A = 0x3E

  case ADI = 0xC6
  case ACI = 0xCE
  case SUI = 0xD6
  case SBI = 0xDE
  case ANI = 0xE6
  case XRI = 0xEE
  case ORI = 0xF6
  case CPI = 0xFE

  // MARK: Direct addressing instructions
  case STA = 0x32
  case LDA = 0x3A

  case SHLD = 0x22
  case LHLD = 0x2A

  // MARK: Jump instructions
  case PCHL = 0xE9

  case JMP = 0xC3
  case JC  = 0xDA
  case JNC = 0xD2
  case JZ  = 0xCA
  case JNZ = 0xC2
  case JM  = 0xFA
  case JP  = 0xF2
  case JPE = 0xEA
  case JPO = 0xE2

  // MARK: Call subroutine instructions
  case CALL = 0xCD
  case CC   = 0xDC
  case CNC  = 0xD4
  case CZ   = 0xCC
  case CNZ  = 0xC4
  case CM   = 0xFC
  case CP   = 0xF4
  case CPE  = 0xEC
  case CPO  = 0xE4

  // MARK: Return from subroutine instructions
  case RET = 0xC9
  case RC  = 0xD8
  case RNC = 0xD0
  case RZ  = 0xC8
  case RNZ = 0xC0
  case RM  = 0xF8
  case RP  = 0xF0
  case RPE = 0xE8
  case RPO = 0xE0

  // MARK: RST instruction
  case RST_0 = 0xC7
  case RST_1 = 0xCF
  case RST_2 = 0xD7
  case RST_3 = 0xDF
  case RST_4 = 0xE7
  case RST_5 = 0xEF
  case RST_6 = 0xF7
  case RST_7 = 0xFF

  // MARK: Interrupt flip-flop instructions
  case EI = 0xFB
  case DI = 0xF3

  // MARK: Input/output instructions
  case IN  = 0xDB
  case OUT = 0xD3

  // MARK: Halt instruction
  case HLT = 0x76

  var additionalBytes: Int {
    switch self {
    case .LXI_B:  return 2
    case .LXI_D:  return 2
    case .LXI_H:  return 2
    case .LXI_SP: return 2

    case .MVI_B: return 1
    case .MVI_C: return 1
    case .MVI_D: return 1
    case .MVI_E: return 1
    case .MVI_H: return 1
    case .MVI_L: return 1
    case .MVI_M: return 1
    case .MVI_A: return 1

    case .ADI: return 1
    case .ACI: return 1
    case .SUI: return 1
    case .SBI: return 1
    case .ANI: return 1
    case .XRI: return 1
    case .ORI: return 1
    case .CPI: return 1

    case .STA: return 2
    case .LDA: return 2

    case .SHLD: return 2
    case .LHLD: return 2

    case .JMP: return 2
    case .JC:  return 2
    case .JNC: return 2
    case .JZ:  return 2
    case .JNZ: return 2
    case .JM:  return 2
    case .JP:  return 2
    case .JPE: return 2
    case .JPO: return 2

    case .CALL: return 2
    case .CC:   return 2
    case .CNC:  return 2
    case .CZ:   return 2
    case .CNZ:  return 2
    case .CM:   return 2
    case .CP:   return 2
    case .CPE:  return 2
    case .CPO:  return 2

    case .IN:  return 1
    case .OUT: return 1

    default: return 0
    }
  }

  var description: String {
    switch self {
    case .INR_B: return "INR B"
    case .INR_C: return "INR C"
    case .INR_D: return "INR D"
    case .INR_E: return "INR E"
    case .INR_H: return "INR H"
    case .INR_L: return "INR L"
    case .INR_M: return "INR M"
    case .INR_A: return "INR I"

    case .DCR_B: return "DCR B"
    case .DCR_C: return "DCR C"
    case .DCR_D: return "DCR D"
    case .DCR_E: return "DCR E"
    case .DCR_H: return "DCR H"
    case .DCR_L: return "DCR L"
    case .DCR_M: return "DCR M"
    case .DCR_A: return "DCR A"

    case .MOV_B_B: return "MOV B,B"
    case .MOV_B_C: return "MOV B,C"
    case .MOV_B_D: return "MOV B,D"
    case .MOV_B_E: return "MOV B,E"
    case .MOV_B_H: return "MOV B,H"
    case .MOV_B_L: return "MOV B,L"
    case .MOV_B_M: return "MOV B,M"
    case .MOV_B_A: return "MOV B,A"
    case .MOV_C_B: return "MOV C,B"
    case .MOV_C_C: return "MOV C,C"
    case .MOV_C_D: return "MOV C,D"
    case .MOV_C_E: return "MOV C,E"
    case .MOV_C_H: return "MOV C,H"
    case .MOV_C_L: return "MOV C,L"
    case .MOV_C_M: return "MOV C,M"
    case .MOV_C_A: return "MOV C,A"
    case .MOV_D_B: return "MOV D,B"
    case .MOV_D_C: return "MOV D,C"
    case .MOV_D_D: return "MOV D,D"
    case .MOV_D_E: return "MOV D,E"
    case .MOV_D_H: return "MOV D,H"
    case .MOV_D_L: return "MOV D,L"
    case .MOV_D_M: return "MOV D,M"
    case .MOV_D_A: return "MOV D,A"
    case .MOV_E_B: return "MOV E,B"
    case .MOV_E_C: return "MOV E,C"
    case .MOV_E_D: return "MOV E,D"
    case .MOV_E_E: return "MOV E,E"
    case .MOV_E_H: return "MOV E,H"
    case .MOV_E_L: return "MOV E,L"
    case .MOV_E_M: return "MOV E,M"
    case .MOV_E_A: return "MOV E,A"
    case .MOV_H_B: return "MOV H,B"
    case .MOV_H_C: return "MOV H,C"
    case .MOV_H_D: return "MOV H,D"
    case .MOV_H_E: return "MOV H,E"
    case .MOV_H_H: return "MOV H,H"
    case .MOV_H_L: return "MOV H,L"
    case .MOV_H_M: return "MOV H,M"
    case .MOV_H_A: return "MOV H,A"
    case .MOV_L_B: return "MOV L,B"
    case .MOV_L_C: return "MOV L,C"
    case .MOV_L_D: return "MOV L,D"
    case .MOV_L_E: return "MOV L,E"
    case .MOV_L_H: return "MOV L,H"
    case .MOV_L_L: return "MOV L,L"
    case .MOV_L_M: return "MOV L,M"
    case .MOV_L_A: return "MOV L,A"
    case .MOV_M_B: return "MOV M,B"
    case .MOV_M_C: return "MOV M,C"
    case .MOV_M_D: return "MOV M,D"
    case .MOV_M_E: return "MOV M,E"
    case .MOV_M_H: return "MOV M,H"
    case .MOV_M_L: return "MOV M,L"
    case .MOV_M_A: return "MOV M,A"
    case .MOV_A_B: return "MOV M,B"
    case .MOV_A_C: return "MOV A,C"
    case .MOV_A_D: return "MOV A,D"
    case .MOV_A_E: return "MOV A,E"
    case .MOV_A_H: return "MOV A,H"
    case .MOV_A_L: return "MOV A,L"
    case .MOV_A_M: return "MOV A,M"
    case .MOV_A_A: return "MOV A,A"

    case .STAX_B: return "STAX B"
    case .STAX_D: return "STAX D"
    case .LDAX_B: return "LDAX B"
    case .LDAX_D: return "LDAX D"

    case .ADD_B: return "ADD B"
    case .ADD_C: return "ADD C"
    case .ADD_D: return "ADD D"
    case .ADD_E: return "ADD E"
    case .ADD_H: return "ADD H"
    case .ADD_L: return "ADD L"
    case .ADD_M: return "ADD M"
    case .ADD_A: return "ADD A"

    case .ADC_B: return "ADC B"
    case .ADC_C: return "ADC C"
    case .ADC_D: return "ADC D"
    case .ADC_E: return "ADC E"
    case .ADC_H: return "ADC H"
    case .ADC_L: return "ADC L"
    case .ADC_M: return "ADC M"
    case .ADC_A: return "ADC A"

    case .SUB_B: return "SUB B"
    case .SUB_C: return "SUB C"
    case .SUB_D: return "SUB D"
    case .SUB_E: return "SUB E"
    case .SUB_H: return "SUB H"
    case .SUB_L: return "SUB L"
    case .SUB_M: return "SUB M"
    case .SUB_A: return "SUB A"

    case .SBB_B: return "SBB B"
    case .SBB_C: return "SBB C"
    case .SBB_D: return "SBB D"
    case .SBB_E: return "SBB E"
    case .SBB_H: return "SBB H"
    case .SBB_L: return "SBB L"
    case .SBB_M: return "SBB M"
    case .SBB_A: return "SBB A"

    case .ANA_B: return "ANA B"
    case .ANA_C: return "ANA C"
    case .ANA_D: return "ANA D"
    case .ANA_E: return "ANA E"
    case .ANA_H: return "ANA H"
    case .ANA_L: return "ANA L"
    case .ANA_M: return "ANA M"
    case .ANA_A: return "ANA A"

    case .XRA_B: return "XRA B"
    case .XRA_C: return "XRA C"
    case .XRA_D: return "XRA D"
    case .XRA_E: return "XRA E"
    case .XRA_H: return "XRA H"
    case .XRA_L: return "XRA L"
    case .XRA_M: return "XRA M"
    case .XRA_A: return "XRA A"

    case .ORA_B: return "ORA B"
    case .ORA_C: return "ORA C"
    case .ORA_D: return "ORA D"
    case .ORA_E: return "ORA E"
    case .ORA_H: return "ORA H"
    case .ORA_L: return "ORA L"
    case .ORA_M: return "ORA M"
    case .ORA_A: return "ORA A"

    case .CMP_B: return "CMP B"
    case .CMP_C: return "CMP C"
    case .CMP_D: return "CMP D"
    case .CMP_E: return "CMP E"
    case .CMP_H: return "CMP H"
    case .CMP_L: return "CMP L"
    case .CMP_M: return "CMP M"
    case .CMP_A: return "CMP A"

    case .PUSH_B:   return "PUSH B"
    case .PUSH_D:   return "PUSH D"
    case .PUSH_H:   return "PUSH H"
    case .PUSH_PSW: return "PUSH PSW"

    case .POP_B:   return "POP B"
    case .POP_D:   return "POP D"
    case .POP_H:   return "POP H"
    case .POP_PSW: return "POP PSW"

    case .DAD_B:  return "DAD B"
    case .DAD_D:  return "DAD D"
    case .DAD_H:  return "DAD H"
    case .DAD_SP: return "DAD SP"

    case .INX_B:  return "INX B"
    case .INX_D:  return "INX D"
    case .INX_H:  return "INX H"
    case .INX_SP: return "INX SP"

    case .DCX_B:  return "DCX B"
    case .DCX_D:  return "DCX D"
    case .DCX_H:  return "DCX H"
    case .DCX_SP: return "DCX SP"

    case .LXI_B:  return "LXI B"
    case .LXI_D:  return "LXI D"
    case .LXI_H:  return "LXI H"
    case .LXI_SP: return "LXI SP"

    case .MVI_B: return "MVI B"
    case .MVI_C: return "MVI C"
    case .MVI_D: return "MVI D"
    case .MVI_E: return "MVI E"
    case .MVI_H: return "MVI H"
    case .MVI_L: return "MVI L"
    case .MVI_M: return "MVI M"
    case .MVI_A: return "MVI A"

    case .RST_0: return "RST 0"
    case .RST_1: return "RST 1"
    case .RST_2: return "RST 2"
    case .RST_3: return "RST 3"
    case .RST_4: return "RST 4"
    case .RST_5: return "RST 5"
    case .RST_6: return "RST 6"
    case .RST_7: return "RST 7"

    default: return "\(self)"
    }
  }
}
