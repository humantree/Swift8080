//
//  CPU.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 12/26/17.
//  Copyright © 2017 humantree. All rights reserved.
//

import Foundation

enum Direction {
  case left
  case right
}

class CPU {
  private func flipBits(_ byte: UInt8) -> UInt8 {
    return byte & 0xF ^ 0xF
  }

  private func getNextByte() -> UInt8 {
    programCounter += 1
    return memory[programCounter - 1]
  }

  private func joinBytes(_ bytes: (UInt8, UInt8)) -> UInt16 {
    return UInt16(bytes.0) << 8 + UInt16(bytes.1)
  }

  private func unimplementedInstruction(instruction: UInt8) {
    let hex = String(format: "%02X", instruction)
    print("Error: Unimplemented instruction (\(hex))")
  }
  
  private func add(_ operand: UInt8, carry: Bool = false) {
    var nibbleResult = registers.a & 0xF + operand & 0xF
    var result = UInt16(registers.a) + UInt16(operand)
    
    if carry {
      nibbleResult += UInt8(conditionBits.carry.hashValue)
      result += UInt16(conditionBits.carry.hashValue)
    }
    
    registers.a = UInt8(result & 0xFF)
    
    conditionBits.setAuxiliaryCarry(nibbleResult)
    conditionBits.setCarry(registers.a, result)
    conditionBits.setSign(registers.a)
    conditionBits.setParity(registers.a)
    conditionBits.setZero(registers.a)
  }

  private func and(_ operand: UInt8) {
    registers.a = registers.a & operand

    conditionBits.carry = false
    conditionBits.setSign(registers.a)
    conditionBits.setParity(registers.a)
    conditionBits.setZero(registers.a)
  }

  private func compare(_ operand: UInt8) {
    let nibbleResult = registers.a & 0xF + flipBits(operand) + 1
    let result = UInt16(registers.a) &- UInt16(operand)
    let result8 = UInt8(result & 0xFF)

    conditionBits.setAuxiliaryCarry(nibbleResult)
    conditionBits.setCarry(result8, result)
    conditionBits.setSign(result8)
    conditionBits.setParity(result8)
    conditionBits.zero = registers.a == operand
  }

  private func nop() { }

  private func or(_ operand: UInt8) {
    registers.a = registers.a | operand

    conditionBits.carry = false
    conditionBits.setSign(registers.a)
    conditionBits.setParity(registers.a)
    conditionBits.setZero(registers.a)
  }

  private func rotate(_ direction: Direction, carry: Bool = false) {
    let bitMask: UInt8 = direction == .left ? 0x80 : 0x01
    let carryValue = conditionBits.carry;
    conditionBits.carry = registers.a & bitMask == bitMask

    var rotated: UInt16
    if direction == .left {
      rotated = UInt16(registers.a << 1)
    } else {
      rotated = UInt16(registers.a >> 1)
    }

    if (carry && carryValue) || (!carry && conditionBits.carry) {
      rotated += direction == .left ? 0x01 : 0x80
    }

    registers.a = UInt8(rotated & 0xFF)
  }

  private func sub(_ operand: UInt8, borrow: Bool = false) {
    var nibbleResult = registers.a & 0xF + flipBits(operand) + 1
    var result = UInt16(registers.a) &- UInt16(operand)

    if borrow {
      nibbleResult -= UInt8(conditionBits.carry.hashValue)
      result -= UInt16(conditionBits.carry.hashValue)
    }

    registers.a = UInt8(result & 0xFF)
    
    conditionBits.setAuxiliaryCarry(nibbleResult)
    conditionBits.setCarry(registers.a, result)
    conditionBits.setSign(registers.a)
    conditionBits.setParity(registers.a)
    conditionBits.setZero(registers.a)
  }

  private func xor(_ operand: UInt8) {
    registers.a = registers.a ^ operand

    conditionBits.auxiliaryCarry = false
    conditionBits.carry = false
    conditionBits.setSign(registers.a)
    conditionBits.setParity(registers.a)
    conditionBits.setZero(registers.a)
  }

  func start() {
    while programCounter < memory.count {
      let byte = getNextByte()

      switch byte {
      case 0x00: nop()
      case 0x01: unimplementedInstruction(instruction: byte)
      case 0x02: memory[Int(joinBytes(registerPairs.b))] = registers.a
      case 0x03: unimplementedInstruction(instruction: byte)
      case 0x04: unimplementedInstruction(instruction: byte)
      case 0x05: unimplementedInstruction(instruction: byte)
      case 0x06: registers.b = getNextByte()
      case 0x07: rotate(.left)
      case 0x08: nop()
      case 0x09: unimplementedInstruction(instruction: byte)
      case 0x0A: registers.a = memory[Int(joinBytes(registerPairs.b))]
      case 0x0B: unimplementedInstruction(instruction: byte)
      case 0x0C: unimplementedInstruction(instruction: byte)
      case 0x0D: unimplementedInstruction(instruction: byte)
      case 0x0E: registers.c = getNextByte()
      case 0x0F: rotate(.right)
      case 0x10: nop()
      case 0x11: unimplementedInstruction(instruction: byte)
      case 0x12: memory[Int(joinBytes(registerPairs.d))] = registers.a
      case 0x13: unimplementedInstruction(instruction: byte)
      case 0x14: unimplementedInstruction(instruction: byte)
      case 0x15: unimplementedInstruction(instruction: byte)
      case 0x16: registers.d = getNextByte()
      case 0x17: rotate(.left, carry: true)
      case 0x18: nop()
      case 0x19: unimplementedInstruction(instruction: byte)
      case 0x1A: registers.a = memory[Int(joinBytes(registerPairs.d))]
      case 0x1B: unimplementedInstruction(instruction: byte)
      case 0x1C: unimplementedInstruction(instruction: byte)
      case 0x1D: unimplementedInstruction(instruction: byte)
      case 0x1E: registers.e = getNextByte()
      case 0x1F: rotate(.right, carry: true)
      case 0x20: unimplementedInstruction(instruction: byte)
      case 0x21: unimplementedInstruction(instruction: byte)
      case 0x22: unimplementedInstruction(instruction: byte)
      case 0x23: unimplementedInstruction(instruction: byte)
      case 0x24: unimplementedInstruction(instruction: byte)
      case 0x25: unimplementedInstruction(instruction: byte)
      case 0x26: registers.h = getNextByte()
      case 0x27: unimplementedInstruction(instruction: byte)
      case 0x28: nop()
      case 0x29: unimplementedInstruction(instruction: byte)
      case 0x2A: unimplementedInstruction(instruction: byte)
      case 0x2B: unimplementedInstruction(instruction: byte)
      case 0x2C: unimplementedInstruction(instruction: byte)
      case 0x2D: unimplementedInstruction(instruction: byte)
      case 0x2E: registers.l = getNextByte()
      case 0x2F: unimplementedInstruction(instruction: byte)
      case 0x30: unimplementedInstruction(instruction: byte)
      case 0x31: unimplementedInstruction(instruction: byte)
      case 0x32: unimplementedInstruction(instruction: byte)
      case 0x33: unimplementedInstruction(instruction: byte)
      case 0x34: unimplementedInstruction(instruction: byte)
      case 0x35: unimplementedInstruction(instruction: byte)
      case 0x36: registers.m = getNextByte()
      case 0x37: conditionBits.carry = true
      case 0x38: nop()
      case 0x39: unimplementedInstruction(instruction: byte)
      case 0x3A: unimplementedInstruction(instruction: byte)
      case 0x3B: unimplementedInstruction(instruction: byte)
      case 0x3C: unimplementedInstruction(instruction: byte)
      case 0x3D: unimplementedInstruction(instruction: byte)
      case 0x3E: registers.a = getNextByte()
      case 0x3F: conditionBits.carry = !conditionBits.carry
      case 0x40: nop()
      case 0x41: registers.b = registers.c
      case 0x42: registers.b = registers.d
      case 0x43: registers.b = registers.e
      case 0x44: registers.b = registers.h
      case 0x45: registers.b = registers.l
      case 0x46: registers.b = registers.m
      case 0x47: registers.b = registers.a
      case 0x48: registers.c = registers.b
      case 0x49: nop()
      case 0x4A: registers.c = registers.d
      case 0x4B: registers.c = registers.e
      case 0x4C: registers.c = registers.h
      case 0x4D: registers.c = registers.l
      case 0x4E: registers.c = registers.m
      case 0x4F: registers.c = registers.a
      case 0x50: registers.d = registers.b
      case 0x51: registers.d = registers.c
      case 0x52: nop()
      case 0x53: registers.d = registers.e
      case 0x54: registers.d = registers.h
      case 0x55: registers.d = registers.l
      case 0x56: registers.d = registers.m
      case 0x57: registers.d = registers.a
      case 0x58: registers.e = registers.b
      case 0x59: registers.e = registers.c
      case 0x5A: registers.e = registers.d
      case 0x5B: nop()
      case 0x5C: registers.e = registers.h
      case 0x5D: registers.e = registers.l
      case 0x5E: registers.e = registers.m
      case 0x5F: registers.e = registers.a
      case 0x60: registers.h = registers.b
      case 0x61: registers.h = registers.c
      case 0x62: registers.h = registers.d
      case 0x63: registers.h = registers.e
      case 0x64: nop()
      case 0x65: registers.h = registers.l
      case 0x66: registers.h = registers.m
      case 0x67: registers.h = registers.a
      case 0x68: registers.l = registers.b
      case 0x69: registers.l = registers.c
      case 0x6A: registers.l = registers.d
      case 0x6B: registers.l = registers.e
      case 0x6C: registers.l = registers.h
      case 0x6D: nop()
      case 0x6E: registers.l = registers.m
      case 0x6F: registers.l = registers.a
      case 0x70: registers.m = registers.b
      case 0x71: registers.m = registers.c
      case 0x72: registers.m = registers.d
      case 0x73: registers.m = registers.e
      case 0x74: registers.m = registers.h
      case 0x75: registers.m = registers.l
      case 0x76: unimplementedInstruction(instruction: byte)
      case 0x77: registers.m = registers.a
      case 0x78: registers.a = registers.b
      case 0x79: registers.a = registers.c
      case 0x7A: registers.a = registers.d
      case 0x7B: registers.a = registers.e
      case 0x7C: registers.a = registers.h
      case 0x7D: registers.a = registers.l
      case 0x7E: registers.a = registers.m
      case 0x7F: nop()
      case 0x80: add(registers.b)
      case 0x81: add(registers.c)
      case 0x82: add(registers.d)
      case 0x83: add(registers.e)
      case 0x84: add(registers.h)
      case 0x85: add(registers.l)
      case 0x86: add(registers.m)
      case 0x87: add(registers.a)
      case 0x88: add(registers.b, carry: true)
      case 0x89: add(registers.c, carry: true)
      case 0x8A: add(registers.d, carry: true)
      case 0x8B: add(registers.e, carry: true)
      case 0x8C: add(registers.h, carry: true)
      case 0x8D: add(registers.l, carry: true)
      case 0x8E: add(registers.m, carry: true)
      case 0x8F: add(registers.a, carry: true)
      case 0x90: sub(registers.b)
      case 0x91: sub(registers.c)
      case 0x92: sub(registers.d)
      case 0x93: sub(registers.e)
      case 0x94: sub(registers.h)
      case 0x95: sub(registers.l)
      case 0x96: sub(registers.m)
      case 0x97: sub(registers.a)
      case 0x98: sub(registers.b, borrow: true)
      case 0x99: sub(registers.c, borrow: true)
      case 0x9A: sub(registers.d, borrow: true)
      case 0x9B: sub(registers.e, borrow: true)
      case 0x9C: sub(registers.h, borrow: true)
      case 0x9D: sub(registers.l, borrow: true)
      case 0x9E: sub(registers.m, borrow: true)
      case 0x9F: sub(registers.a, borrow: true)
      case 0xA0: and(registers.b)
      case 0xA1: and(registers.c)
      case 0xA2: and(registers.d)
      case 0xA3: and(registers.e)
      case 0xA4: and(registers.h)
      case 0xA5: and(registers.l)
      case 0xA6: and(registers.m)
      case 0xA7: and(registers.a)
      case 0xA8: xor(registers.b)
      case 0xA9: xor(registers.c)
      case 0xAA: xor(registers.d)
      case 0xAB: xor(registers.e)
      case 0xAC: xor(registers.h)
      case 0xAD: xor(registers.l)
      case 0xAE: xor(registers.m)
      case 0xAF: xor(registers.a)
      case 0xB0: or(registers.b)
      case 0xB1: or(registers.c)
      case 0xB2: or(registers.d)
      case 0xB3: or(registers.e)
      case 0xB4: or(registers.h)
      case 0xB5: or(registers.l)
      case 0xB6: or(registers.m)
      case 0xB7: or(registers.a)
      case 0xB8: compare(registers.b)
      case 0xB9: compare(registers.c)
      case 0xBA: compare(registers.d)
      case 0xBB: compare(registers.e)
      case 0xBC: compare(registers.h)
      case 0xBD: compare(registers.l)
      case 0xBE: compare(registers.m)
      case 0xBF: compare(registers.a)
      case 0xC0: unimplementedInstruction(instruction: byte)
      case 0xC1: unimplementedInstruction(instruction: byte)
      case 0xC2: unimplementedInstruction(instruction: byte)
      case 0xC3: unimplementedInstruction(instruction: byte)
      case 0xC4: unimplementedInstruction(instruction: byte)
      case 0xC5: unimplementedInstruction(instruction: byte)
      case 0xC6: add(getNextByte())
      case 0xC7: unimplementedInstruction(instruction: byte)
      case 0xC8: unimplementedInstruction(instruction: byte)
      case 0xC9: unimplementedInstruction(instruction: byte)
      case 0xCA: unimplementedInstruction(instruction: byte)
      case 0xCB: nop()
      case 0xCC: unimplementedInstruction(instruction: byte)
      case 0xCD: unimplementedInstruction(instruction: byte)
      case 0xCE: add(getNextByte(), carry: true)
      case 0xCF: unimplementedInstruction(instruction: byte)
      case 0xD0: unimplementedInstruction(instruction: byte)
      case 0xD1: unimplementedInstruction(instruction: byte)
      case 0xD2: unimplementedInstruction(instruction: byte)
      case 0xD3: unimplementedInstruction(instruction: byte)
      case 0xD4: unimplementedInstruction(instruction: byte)
      case 0xD5: unimplementedInstruction(instruction: byte)
      case 0xD6: sub(getNextByte())
      case 0xD7: unimplementedInstruction(instruction: byte)
      case 0xD8: unimplementedInstruction(instruction: byte)
      case 0xD9: nop()
      case 0xDA: unimplementedInstruction(instruction: byte)
      case 0xDB: unimplementedInstruction(instruction: byte)
      case 0xDC: unimplementedInstruction(instruction: byte)
      case 0xDD: nop()
      case 0xDE: sub(getNextByte(), borrow: true)
      case 0xDF: unimplementedInstruction(instruction: byte)
      case 0xE0: unimplementedInstruction(instruction: byte)
      case 0xE1: unimplementedInstruction(instruction: byte)
      case 0xE2: unimplementedInstruction(instruction: byte)
      case 0xE3: unimplementedInstruction(instruction: byte)
      case 0xE4: unimplementedInstruction(instruction: byte)
      case 0xE5: unimplementedInstruction(instruction: byte)
      case 0xE6: unimplementedInstruction(instruction: byte)
      case 0xE7: unimplementedInstruction(instruction: byte)
      case 0xE8: unimplementedInstruction(instruction: byte)
      case 0xE9: unimplementedInstruction(instruction: byte)
      case 0xEA: unimplementedInstruction(instruction: byte)
      case 0xEB: unimplementedInstruction(instruction: byte)
      case 0xEC: unimplementedInstruction(instruction: byte)
      case 0xED: nop()
      case 0xEE: unimplementedInstruction(instruction: byte)
      case 0xEF: unimplementedInstruction(instruction: byte)
      case 0xF0: unimplementedInstruction(instruction: byte)
      case 0xF1: unimplementedInstruction(instruction: byte)
      case 0xF2: unimplementedInstruction(instruction: byte)
      case 0xF3: unimplementedInstruction(instruction: byte)
      case 0xF4: unimplementedInstruction(instruction: byte)
      case 0xF5: unimplementedInstruction(instruction: byte)
      case 0xF6: unimplementedInstruction(instruction: byte)
      case 0xF7: unimplementedInstruction(instruction: byte)
      case 0xF8: unimplementedInstruction(instruction: byte)
      case 0xF9: unimplementedInstruction(instruction: byte)
      case 0xFA: unimplementedInstruction(instruction: byte)
      case 0xFB: unimplementedInstruction(instruction: byte)
      case 0xFC: unimplementedInstruction(instruction: byte)
      case 0xFD: nop()
      case 0xFE: unimplementedInstruction(instruction: byte)
      case 0xFF: unimplementedInstruction(instruction: byte)
      default: unimplementedInstruction(instruction: byte)
      }
    }
  }
}
