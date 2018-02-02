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
  internal func getNextByte() -> UInt8 {
    programCounter += 1
    return memory[Int(programCounter - 1)]
  }

  internal func getNextTwoBytes() -> (UInt8, UInt8) {
    let lowData = getNextByte()
    return (getNextByte(), lowData)
  }

  internal func joinBytes(_ bytes: (UInt8, UInt8)) -> UInt16 {
    return UInt16(bytes.0) << 8 + UInt16(bytes.1)
  }

  internal func splitBytes(_ double: UInt16) -> (UInt8, UInt8) {
    return (UInt8(double >> 8), UInt8(double & 0xFF))
  }

  internal func unimplementedInstruction(instruction: Opcode) {
    let hex = String(format: "%02X", instruction.rawValue)
    print("Error: Unimplemented instruction (\(hex))")
  }

  // MARK: -

  internal func add(_ operand: UInt8, carry: Bool = false) {
    var nibbleResult = registers.a & 0xF + operand & 0xF
    var result = UInt16(registers.a) + UInt16(operand)
    
    if carry {
      nibbleResult += UInt8(conditionBits.carry.hashValue)
      result += UInt16(conditionBits.carry.hashValue)
    }
    
    registers.a = UInt8(result & 0xFF)
    
    conditionBits.setAuxiliaryCarry(nibbleResult)
    conditionBits.setCarry(registers.a, result)
    conditionBits.setParitySignZero(registers.a)
  }

  internal func add(_ operand: UInt16) {
    let result = UInt32(joinBytes(registerPairs.h)) + UInt32(operand)

    registerPairs.h = splitBytes(UInt16(result & 0xFFFF))
    conditionBits.setCarry(registers.h, UInt16(result >> 8))
  }

  internal func and(_ operand: UInt8) {
    registers.a = registers.a & operand

    conditionBits.carry = false
    conditionBits.setParitySignZero(registers.a)
  }

  internal func call(condition: Bool = true) {
    push(splitBytes(programCounter + 2))
    jump(condition: condition)
  }

  internal func decimalAdjust() {
    if registers.a & 0xF > 9 || conditionBits.auxiliaryCarry {
      registers.a += 6
      conditionBits.auxiliaryCarry = true
    } else {
      conditionBits.auxiliaryCarry = false
    }

    if registers.a & 0xF0 > 9 || conditionBits.carry {
      let result = UInt16(registers.a) + 0x60
      registers.a = UInt8(result & 0xFF)
      conditionBits.setCarry(registers.a, result)
    }

    conditionBits.setParitySignZero(registers.a)
  }

  internal func decrement(_ operand: inout UInt8) {
    let nibbleResult = operand & 0xF + 0xF
    operand = operand &- 1

    conditionBits.setAuxiliaryCarry(nibbleResult)
    conditionBits.setParitySignZero(operand)
  }

  internal func decrement(_ operand: inout (UInt8, UInt8)) {
    operand = splitBytes(joinBytes(operand) &- 1)
  }

  internal func exchange() {
    let temporary = registerPairs.h
    registerPairs.h = registerPairs.d
    registerPairs.d = temporary
  }

  internal func exchangeStack() {
    let temporary = (memory[Int(stackPointer + 1)],
                     memory[Int(stackPointer)])
    memory[Int(stackPointer + 1)] = registers.h
    memory[Int(stackPointer)] = registers.l
    registerPairs.h = temporary
  }

  internal func increment(_ operand: inout UInt8) {
    operand = operand &+ 1

    conditionBits.setAuxiliaryCarry(operand & 0xF)
    conditionBits.setParitySignZero(operand)
  }

  internal func increment(_ operand: inout (UInt8, UInt8)) {
    operand = splitBytes(joinBytes(operand) &+ 1)
  }

  internal func jump(condition: Bool = true) {
    let address = joinBytes(getNextTwoBytes())
    if condition { programCounter = address }
  }

  internal func load(_ address: UInt16) {
    registers.l = memory[Int(address)]
    registers.h = memory[Int(address + 1)]
  }

  internal func or(_ operand: UInt8) {
    registers.a = registers.a | operand

    conditionBits.carry = false
    conditionBits.setParitySignZero(registers.a)
  }

  internal func pop() -> (UInt8, UInt8) {
    let second = popByte()
    let first = popByte()
    return (first, second)
  }

  internal func popByte() -> UInt8 {
    let byte = memory[Int(stackPointer)]
    stackPointer += 1
    return byte
  }

  internal func push(_ byte: UInt8) {
    stackPointer -= 1
    memory[Int(stackPointer)] = byte
  }

  internal func push(_ bytes: (UInt8, UInt8)) {
    push(bytes.0)
    push(bytes.1)
  }

  internal func restart(_ routine: UInt8) {
    push(splitBytes(programCounter))
    programCounter = UInt16(routine << 3)
  }

  internal func ret(condition: Bool = true) {
    if condition {
      programCounter = joinBytes(pop())
    }
  }

  internal func rotate(_ direction: Direction, carry: Bool = false) {
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

  internal func store(_ address: UInt16) {
    memory[Int(address)] = registers.l
    memory[Int(address + 1)] = registers.h
  }

  internal func sub(_ operand: UInt8,
                   borrow: Bool = false,
                   saveResult: Bool = true) {

    let flippedNibble = operand & 0xF ^ 0xF
    var nibbleResult = registers.a & 0xF + flippedNibble + 1
    var result = UInt16(registers.a) &- UInt16(operand)

    if borrow {
      nibbleResult -= UInt8(conditionBits.carry.hashValue)
      result -= UInt16(conditionBits.carry.hashValue)
    }

    let result8 = UInt8(result & 0xFF)

    conditionBits.setAuxiliaryCarry(nibbleResult)
    conditionBits.setCarry(result8, result)
    conditionBits.setParitySignZero(result8)

    if saveResult {
      registers.a = result8
    }
  }

  internal func xor(_ operand: UInt8) {
    registers.a = registers.a ^ operand

    conditionBits.carry = false
    conditionBits.setParitySignZero(registers.a)
  }

  // MARK: -

  func start() {
    while programCounter < memory.count {
      let opcode = Opcode(rawValue: getNextByte())
      if opcode == nil { continue }

      logDisassembly(opcode!)

      switch opcode! {
      // MARK: Carry bit instructions
      case .CMC: conditionBits.carry = !conditionBits.carry
      case .STC: conditionBits.carry = true

      // MARK: Single register instructions
      case .INR_B: increment(&registers.b)
      case .INR_C: increment(&registers.c)
      case .INR_D: increment(&registers.d)
      case .INR_E: increment(&registers.e)
      case .INR_H: increment(&registers.h)
      case .INR_L: increment(&registers.l)
      case .INR_M: increment(&registers.m)
      case .INR_A: increment(&registers.a)

      case .DCR_B: decrement(&registers.b)
      case .DCR_C: decrement(&registers.c)
      case .DCR_D: decrement(&registers.d)
      case .DCR_E: decrement(&registers.e)
      case .DCR_H: decrement(&registers.h)
      case .DCR_L: decrement(&registers.l)
      case .DCR_M: decrement(&registers.m)
      case .DCR_A: decrement(&registers.a)

      case .CMA: registers.a ^= 0xFF
      case .DAA: decimalAdjust()

      // MARK: NOP instruction
      case .NOP: continue

      // MARK: Data transfer instructions
      case .MOV_B_B: continue
      case .MOV_B_C: registers.b = registers.c
      case .MOV_B_D: registers.b = registers.d
      case .MOV_B_E: registers.b = registers.e
      case .MOV_B_H: registers.b = registers.h
      case .MOV_B_L: registers.b = registers.l
      case .MOV_B_M: registers.b = registers.m
      case .MOV_B_A: registers.b = registers.a
      case .MOV_C_B: registers.c = registers.b
      case .MOV_C_C: continue
      case .MOV_C_D: registers.c = registers.d
      case .MOV_C_E: registers.c = registers.e
      case .MOV_C_H: registers.c = registers.h
      case .MOV_C_L: registers.c = registers.l
      case .MOV_C_M: registers.c = registers.m
      case .MOV_C_A: registers.c = registers.a
      case .MOV_D_B: registers.d = registers.b
      case .MOV_D_C: registers.d = registers.c
      case .MOV_D_D: continue
      case .MOV_D_E: registers.d = registers.e
      case .MOV_D_H: registers.d = registers.h
      case .MOV_D_L: registers.d = registers.l
      case .MOV_D_M: registers.d = registers.m
      case .MOV_D_A: registers.d = registers.a
      case .MOV_E_B: registers.e = registers.b
      case .MOV_E_C: registers.e = registers.c
      case .MOV_E_D: registers.e = registers.d
      case .MOV_E_E: continue
      case .MOV_E_H: registers.e = registers.h
      case .MOV_E_L: registers.e = registers.l
      case .MOV_E_M: registers.e = registers.m
      case .MOV_E_A: registers.e = registers.a
      case .MOV_H_B: registers.h = registers.b
      case .MOV_H_C: registers.h = registers.c
      case .MOV_H_D: registers.h = registers.d
      case .MOV_H_E: registers.h = registers.e
      case .MOV_H_H: continue
      case .MOV_H_L: registers.h = registers.l
      case .MOV_H_M: registers.h = registers.m
      case .MOV_H_A: registers.h = registers.a
      case .MOV_L_B: registers.l = registers.b
      case .MOV_L_C: registers.l = registers.c
      case .MOV_L_D: registers.l = registers.d
      case .MOV_L_E: registers.l = registers.e
      case .MOV_L_H: registers.l = registers.h
      case .MOV_L_L: continue
      case .MOV_L_M: registers.l = registers.m
      case .MOV_L_A: registers.l = registers.a
      case .MOV_M_B: registers.m = registers.b
      case .MOV_M_C: registers.m = registers.c
      case .MOV_M_D: registers.m = registers.d
      case .MOV_M_E: registers.m = registers.e
      case .MOV_M_H: registers.m = registers.h
      case .MOV_M_L: registers.m = registers.l
      case .MOV_M_A: registers.m = registers.a
      case .MOV_A_B: registers.a = registers.b
      case .MOV_A_C: registers.a = registers.c
      case .MOV_A_D: registers.a = registers.d
      case .MOV_A_E: registers.a = registers.e
      case .MOV_A_H: registers.a = registers.h
      case .MOV_A_L: registers.a = registers.l
      case .MOV_A_M: registers.a = registers.m
      case .MOV_A_A: continue

      case .STAX_B: memory[Int(joinBytes(registerPairs.b))] = registers.a
      case .STAX_D: memory[Int(joinBytes(registerPairs.d))] = registers.a
      case .LDAX_B: registers.a = memory[Int(joinBytes(registerPairs.b))]
      case .LDAX_D: registers.a = memory[Int(joinBytes(registerPairs.d))]

      // MARK: Register or memory to accumulator instructions
      case .ADD_B: add(registers.b)
      case .ADD_C: add(registers.c)
      case .ADD_D: add(registers.d)
      case .ADD_E: add(registers.e)
      case .ADD_H: add(registers.h)
      case .ADD_L: add(registers.l)
      case .ADD_M: add(registers.m)
      case .ADD_A: add(registers.a)

      case .ADC_B: add(registers.b, carry: true)
      case .ADC_C: add(registers.c, carry: true)
      case .ADC_D: add(registers.d, carry: true)
      case .ADC_E: add(registers.e, carry: true)
      case .ADC_H: add(registers.h, carry: true)
      case .ADC_L: add(registers.l, carry: true)
      case .ADC_M: add(registers.m, carry: true)
      case .ADC_A: add(registers.a, carry: true)

      case .SUB_B: sub(registers.b)
      case .SUB_C: sub(registers.c)
      case .SUB_D: sub(registers.d)
      case .SUB_E: sub(registers.e)
      case .SUB_H: sub(registers.h)
      case .SUB_L: sub(registers.l)
      case .SUB_M: sub(registers.m)
      case .SUB_A: sub(registers.a)

      case .SBB_B: sub(registers.b, borrow: true)
      case .SBB_C: sub(registers.c, borrow: true)
      case .SBB_D: sub(registers.d, borrow: true)
      case .SBB_E: sub(registers.e, borrow: true)
      case .SBB_H: sub(registers.h, borrow: true)
      case .SBB_L: sub(registers.l, borrow: true)
      case .SBB_M: sub(registers.m, borrow: true)
      case .SBB_A: sub(registers.a, borrow: true)

      case .ANA_B: and(registers.b)
      case .ANA_C: and(registers.c)
      case .ANA_D: and(registers.d)
      case .ANA_E: and(registers.e)
      case .ANA_H: and(registers.h)
      case .ANA_L: and(registers.l)
      case .ANA_M: and(registers.m)
      case .ANA_A: and(registers.a)

      case .XRA_B: xor(registers.b)
      case .XRA_C: xor(registers.c)
      case .XRA_D: xor(registers.d)
      case .XRA_E: xor(registers.e)
      case .XRA_H: xor(registers.h)
      case .XRA_L: xor(registers.l)
      case .XRA_M: xor(registers.m)
      case .XRA_A: xor(registers.a)

      case .ORA_B: or(registers.b)
      case .ORA_C: or(registers.c)
      case .ORA_D: or(registers.d)
      case .ORA_E: or(registers.e)
      case .ORA_H: or(registers.h)
      case .ORA_L: or(registers.l)
      case .ORA_M: or(registers.m)
      case .ORA_A: or(registers.a)

      case .CMP_B: sub(registers.b, saveResult: false)
      case .CMP_C: sub(registers.c, saveResult: false)
      case .CMP_D: sub(registers.d, saveResult: false)
      case .CMP_E: sub(registers.e, saveResult: false)
      case .CMP_H: sub(registers.h, saveResult: false)
      case .CMP_L: sub(registers.l, saveResult: false)
      case .CMP_M: sub(registers.m, saveResult: false)
      case .CMP_A: sub(registers.a, saveResult: false)

      // MARK: Rotate accumulator instructions
      case .RLC: rotate(.left)
      case .RRC: rotate(.right)
      case .RAL: rotate(.left,  carry: true)
      case .RAR: rotate(.right, carry: true)

      // MARK: Register pair instructions
      case .PUSH_B:   push(registerPairs.b)
      case .PUSH_D:   push(registerPairs.d)
      case .PUSH_H:   push(registerPairs.h)
      case .PUSH_PSW: push(registerPairs.psw)

      case .POP_B:   registerPairs.b   = pop()
      case .POP_D:   registerPairs.d   = pop()
      case .POP_H:   registerPairs.h   = pop()
      case .POP_PSW: registerPairs.psw = pop()

      case .DAD_B:  add(joinBytes(registerPairs.b))
      case .DAD_D:  add(joinBytes(registerPairs.d))
      case .DAD_H:  add(joinBytes(registerPairs.h))
      case .DAD_SP: add(stackPointer)

      case .INX_B:  increment(&registerPairs.b)
      case .INX_D:  increment(&registerPairs.d)
      case .INX_H:  increment(&registerPairs.h)
      case .INX_SP: stackPointer = stackPointer &+ 1

      case .DCX_B:  decrement(&registerPairs.b)
      case .DCX_D:  decrement(&registerPairs.d)
      case .DCX_H:  decrement(&registerPairs.h)
      case .DCX_SP: stackPointer = stackPointer &- 1

      case .XCHG: exchange()
      case .XTHL: exchangeStack()
      case .SPHL: stackPointer = joinBytes(registerPairs.h)

      // MARK: Immediate instructions
      case .LXI_B:  registerPairs.b = getNextTwoBytes()
      case .LXI_D:  registerPairs.d = getNextTwoBytes()
      case .LXI_H:  registerPairs.h = getNextTwoBytes()
      case .LXI_SP: stackPointer = joinBytes(getNextTwoBytes())

      case .MVI_B: registers.b = getNextByte()
      case .MVI_C: registers.c = getNextByte()
      case .MVI_D: registers.d = getNextByte()
      case .MVI_E: registers.e = getNextByte()
      case .MVI_H: registers.h = getNextByte()
      case .MVI_L: registers.l = getNextByte()
      case .MVI_M: registers.m = getNextByte()
      case .MVI_A: registers.a = getNextByte()

      case .ADI: add(getNextByte())
      case .ACI: add(getNextByte(), carry: true)
      case .SUI: sub(getNextByte())
      case .SBI: sub(getNextByte(), borrow: true)
      case .ANI: and(getNextByte())
      case .XRI: xor(getNextByte())
      case .ORI:  or(getNextByte())
      case .CPI: sub(getNextByte(), saveResult: false)

      // MARK: Direct addressing instructions
      case .STA: memory[Int(joinBytes(getNextTwoBytes()))] = registers.a
      case .LDA: registers.a = memory[Int(joinBytes(getNextTwoBytes()))]

      case .SHLD: store(joinBytes(getNextTwoBytes()))
      case .LHLD: load(joinBytes(getNextTwoBytes()))

      // MARK: Jump instructions
      case .PCHL: programCounter = joinBytes(registerPairs.h)

      case .JMP: jump()
      case .JC:  jump(condition:  conditionBits.carry)
      case .JNC: jump(condition: !conditionBits.carry)
      case .JZ:  jump(condition:  conditionBits.zero)
      case .JNZ: jump(condition: !conditionBits.zero)
      case .JM:  jump(condition:  conditionBits.sign)
      case .JP:  jump(condition: !conditionBits.sign)
      case .JPE: jump(condition:  conditionBits.parity)
      case .JPO: jump(condition: !conditionBits.parity)

      // MARK: Call subroutine instructions
      case .CALL: call()
      case .CC:   call(condition:  conditionBits.carry)
      case .CNC:  call(condition: !conditionBits.carry)
      case .CZ:   call(condition: !conditionBits.zero)
      case .CNZ:  call(condition:  conditionBits.zero)
      case .CM:   call(condition:  conditionBits.sign)
      case .CP:   call(condition: !conditionBits.sign)
      case .CPE:  call(condition:  conditionBits.parity)
      case .CPO:  call(condition: !conditionBits.parity)

      // MARK: Return from subroutine instructions
      case .RET: ret()
      case .RC:  ret(condition:  conditionBits.carry)
      case .RNC: ret(condition: !conditionBits.carry)
      case .RZ:  ret(condition:  conditionBits.zero)
      case .RNZ: ret(condition: !conditionBits.zero)
      case .RM:  ret(condition:  conditionBits.sign)
      case .RP:  ret(condition: !conditionBits.sign)
      case .RPE: ret(condition:  conditionBits.parity)
      case .RPO: ret(condition: !conditionBits.parity)

      // MARK: RST instruction
      case .RST_0: restart(0)
      case .RST_1: restart(1)
      case .RST_2: restart(2)
      case .RST_3: restart(3)
      case .RST_4: restart(4)
      case .RST_5: restart(5)
      case .RST_6: restart(6)
      case .RST_7: restart(7)

      // MARK: Interrupt flip-flop instructions
      case .EI: interruptsEnabled = true
      case .DI: interruptsEnabled = false

      // MARK: Input/output instructions
      case .IN:  _ = getNextByte()
                 unimplementedInstruction(instruction: opcode!)
      case .OUT: _ = getNextByte()
                 unimplementedInstruction(instruction: opcode!)

      // MARK: Halt instruction
      case .HLT: exit(0)
      }
    }
  }
}
