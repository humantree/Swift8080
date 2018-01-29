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
  case STA  = 0x32
  case LDA  = 0x3A
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
}
