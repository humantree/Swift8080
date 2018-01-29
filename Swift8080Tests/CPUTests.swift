//
//  CPUTests.swift
//  Swift8080Tests
//
//  Created by Christopher Oldfield on 12/26/17.
//  Copyright © 2017 humantree. All rights reserved.
//

import XCTest
@testable import Swift8080

class CPUTests: XCTestCase {
  let cpu = CPU()

  override func setUp() {
    super.setUp()

    conditionBits = ConditionBits()
    memory = Data.init(repeating: 0x00, count: 0xFFFF)
    programCounter = Int()
    registers = Registers()
    stackPointer = UInt16()
  }

  func addToMemory(_ bytes: [UInt8]) {
    let data = Data.init(bytes: bytes)
    memory.replaceSubrange(0..<data.count, with: data)
  }

  func testACI() {
    addToMemory([
      0x3E, 0x56,
      0xCE, 0xBE,
      0xCE, 0x42])

    cpu.start()

    XCTAssertEqual(registers.a, 0x57)
    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADC1() {
    addToMemory([0x89])
    registers.c = 0x3D
    registers.a = 0x42

    cpu.start()

    XCTAssertEqual(registers.a, 0x7F)
    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADC2() {
    addToMemory([0x89])
    registers.c = 0x3D
    registers.a = 0x42
    conditionBits.carry = true

    cpu.start()

    XCTAssertEqual(registers.a, 0x80)
    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADD1() {
    addToMemory([0x87])
    registers.a = 0x0F

    cpu.start()

    XCTAssertEqual(registers.a, 0x1E)
    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADD2() {
    addToMemory([0x82])
    registers.d = 0x2E
    registers.a = 0x6C

    cpu.start()

    XCTAssertEqual(registers.a, 0x9A)
    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADI() {
    addToMemory([
      0x3E, 0x14,
      0xC6, 0x42,
      0xC6, 0xBE])

    cpu.start()

    XCTAssertEqual(registers.a, 0x14)
    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testANA() {
    addToMemory([0xA1])
    registers.a = 0xFC
    registers.c = 0x0F

    cpu.start()

    XCTAssertEqual(registers.a, 0x0C)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testANI() {
    addToMemory([0xE6, 0x0F])
    registers.a = 0x3A

    cpu.start()

    XCTAssertEqual(registers.a, 0x0A)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testCMA() {
    addToMemory([0x2F])
    registers.a = 0x51

    cpu.start()

    XCTAssertEqual(registers.a, 0xAE)
  }

  func testCMC() {
    addToMemory([0x3F])
    conditionBits.carry = true

    cpu.start()

    XCTAssertFalse(conditionBits.carry)
  }

  func testCMP1() {
    addToMemory([0xBB])
    registers.a = 0x0A
    registers.e = 0x05

    cpu.start()

    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testCMP2() {
    addToMemory([0xBB])
    registers.a = 0x02
    registers.e = 0x05

    cpu.start()

    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testCMP3() {
    addToMemory([0xBB])
    registers.a = 0xE5
    registers.e = 0x05

    cpu.start()

    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testCPI() {
    addToMemory([0xFE, 0x40])
    registers.a = 0x4A

    cpu.start()

    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testDAA() {
    addToMemory([0x27])
    registers.a = 0x9B

    cpu.start()

    XCTAssertEqual(registers.a, 0x01)
    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testDAD1() {
    addToMemory([0x09])
    registers.b = 0x33
    registers.c = 0x9F
    registers.h = 0xA1
    registers.l = 0x7B

    cpu.start()

    XCTAssertEqual(registers.h, 0xD5)
    XCTAssertEqual(registers.l, 0x1A)
    XCTAssertFalse(conditionBits.carry)
  }

  func testDAD2() {
    addToMemory([0x29])
    registers.h = 0xFF
    registers.l = 0xFF

    cpu.start()

    XCTAssertEqual(registers.h, 0xFF)
    XCTAssertEqual(registers.l, 0xFE)
    XCTAssertTrue(conditionBits.carry)
  }

  func testDCR() {
    addToMemory([0x35])
    registers.h = 0x3A
    registers.l = 0x7C
    memory[0x3A7C] = 0x40

    cpu.start()

    XCTAssertEqual(memory[0x3A7C], 0x3F)
    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testDCX() {
    addToMemory([0x2B])
    registers.h = 0x98
    registers.l = 0x00

    cpu.start()

    XCTAssertEqual(registers.h, 0x97)
    XCTAssertEqual(registers.l, 0xFF)
  }

  func testINR() {
    addToMemory([0x0C])
    registers.c = 0x99

    cpu.start()

    XCTAssertEqual(registers.c, 0x9A)
    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testINX1() {
    addToMemory([0x13])
    registers.d = 0x38
    registers.e = 0xFF

    cpu.start()

    XCTAssertEqual(registers.d, 0x39)
    XCTAssertEqual(registers.e, 0x00)
  }

  func testINX2() {
    addToMemory([0x33])
    stackPointer = 0xFFFF

    cpu.start()

    XCTAssertEqual(stackPointer, 0x0000)
  }

  func testLDA() {
    addToMemory([0x3A, 0x00, 0x03])
    memory[0x0300] = 0x47

    cpu.start()

    XCTAssertEqual(registers.a, 0x47)
  }

  func testLDAX() {
    addToMemory([0x1A])
    memory[0x938B] = 0x2D
    registers.d = 0x93
    registers.e = 0x8B

    cpu.start()

    XCTAssertEqual(registers.a, 0x2D)
  }

  func testLHLD() {
    addToMemory([0x2A, 0x5B, 0x02])
    memory[0x025B] = 0xFF
    memory[0x025C] = 0x03

    cpu.start()

    XCTAssertEqual(registers.h, 0x03)
    XCTAssertEqual(registers.l, 0xFF)
  }

  func testLXI1() {
    addToMemory([0x21, 0x03, 0x01])

    cpu.start()

    XCTAssertEqual(registers.h, 0x01)
    XCTAssertEqual(registers.l, 0x03)
  }

  func testLXI2() {
    addToMemory([0x31, 0xBC, 0x3A])

    cpu.start()

    XCTAssertEqual(stackPointer, 0x3ABC)
  }

  func testMOV() {
    addToMemory([0x77])
    registers.h = 0x2B
    registers.l = 0xE9
    registers.a = 0xEE

    cpu.start()

    XCTAssertEqual(memory[0x2BE9], 0xEE)
  }

  func testMVI() {
    addToMemory([
      0x26, 0x3C,
      0x2E, 0xF4,
      0x36, 0xFF])

    cpu.start()

    XCTAssertEqual(memory[0x3CF4], 0xFF)
  }

  func testNOP() {
    cpu.start()
  }

  func testORA() {
    addToMemory([0xB1])
    registers.c = 0x0F
    registers.a = 0x33

    cpu.start()

    XCTAssertEqual(registers.a, 0x3F)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testORI() {
    addToMemory([0xF6, 0x0F])
    registers.a = 0xB5

    cpu.start()

    XCTAssertEqual(registers.a, 0xBF)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testPCHL() {
    addToMemory([0xE9])
    registers.a = 0x34
    registers.h = 0x41
    registers.l = 0x3E
    memory[0x413D] = 0x47
    memory[0x413E] = 0x4F

    cpu.start()

    XCTAssertEqual(registers.b, 0x00)
    XCTAssertEqual(registers.c, 0x34)
  }

  func testPOP1() {
    addToMemory([0xE1])
    memory[0x1239] = 0x3D
    memory[0x123A] = 0x93
    stackPointer = 0x1239

    cpu.start()

    XCTAssertEqual(registers.l, 0x3D)
    XCTAssertEqual(registers.h, 0x93)
    XCTAssertEqual(stackPointer, 0x123B)
  }

  func testPOP2() {
    memory[0x2C00] = 0xC3
    memory[0x2C01] = 0xFF
    memory[0x2CFF] = 0xF1
    programCounter = 0x2CFF
    stackPointer = 0x2C00

    cpu.start()

    XCTAssertEqual(registers.a, 0xFF)
    XCTAssertEqual(stackPointer, 0x2C02)
    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertTrue(conditionBits.zero)
  }

  func testPUSH1() {
    addToMemory([0xD5])
    registers.d = 0x8F
    registers.e = 0x9D
    stackPointer = 0x3A2C

    cpu.start()

    XCTAssertEqual(memory[0x3A2B], 0x8F)
    XCTAssertEqual(memory[0x3A2A], 0x9D)
    XCTAssertEqual(stackPointer, 0x3A2A)
  }

  func testPUSH2() {
    addToMemory([0xF5])
    registers.a = 0x1F
    stackPointer = 0x502A
    conditionBits.carry = true
    conditionBits.parity = true
    conditionBits.zero = true

    cpu.start()

    XCTAssertEqual(memory[0x5029], 0x1F)
    XCTAssertEqual(memory[0x5028], 0x47)
    XCTAssertEqual(stackPointer, 0x5028)
  }

  func testRAL() {
    addToMemory([0x17])
    registers.a = 0xB5

    cpu.start()

    XCTAssertEqual(registers.a, 0x6A)
    XCTAssertTrue(conditionBits.carry)
  }

  func testRAR() {
    addToMemory([0x1F])
    registers.a = 0x6A
    conditionBits.carry = true

    cpu.start()

    XCTAssertEqual(registers.a, 0xB5)
    XCTAssertFalse(conditionBits.carry)
  }
  
  func testRLC() {
    addToMemory([0x07])
    registers.a = 0xF2

    cpu.start()

    XCTAssertEqual(registers.a, 0xE5)
    XCTAssertTrue(conditionBits.carry)
  }

  func testRRC() {
    addToMemory([0x0F])
    registers.a = 0xF2

    cpu.start()

    XCTAssertEqual(registers.a, 0x79)
    XCTAssertFalse(conditionBits.carry)
  }

  func testSBB() {
    addToMemory([0x9D])
    registers.l = 0x02
    registers.a = 0x04
    conditionBits.carry = true

    cpu.start()

    XCTAssertEqual(registers.a, 0x01)
    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testSBI() {
    addToMemory([0xDE, 0x01])
    conditionBits.carry = true

    cpu.start()

    XCTAssertEqual(registers.a, 0xFE)
    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testSHLD() {
    addToMemory([0x22, 0x0A, 0x01])
    registers.h = 0xAE
    registers.l = 0x29

    cpu.start()

    XCTAssertEqual(memory[0x010A], 0x29)
    XCTAssertEqual(memory[0x010B], 0xAE)
  }

  func testSPHL() {
    addToMemory([0xF9])
    registers.h = 0x50
    registers.l = 0x6C

    cpu.start()

    XCTAssertEqual(stackPointer, 0x506C)
  }

  func testSTA() {
    addToMemory([0x32, 0xB3, 0x05])
    registers.a = 0x8C

    cpu.start()

    XCTAssertEqual(memory[0x05B3], 0x8C)
  }

  func testSTAX() {
    addToMemory([0x02])
    registers.a = 0x60
    registers.b = 0x3F
    registers.c = 0x16

    cpu.start()

    XCTAssertEqual(memory[0x3F16], 0x60)
  }

  func testSTC() {
    addToMemory([0x37])

    cpu.start()

    XCTAssertTrue(conditionBits.carry)
  }

  func testSUB() {
    addToMemory([0x97])
    registers.a = 0x3E

    cpu.start()

    XCTAssertEqual(registers.a, 0x00)
    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertTrue(conditionBits.zero)
  }

  func testSUI() {
    addToMemory([
      0x3E, 0x00,
      0xD6, 0x01])

    cpu.start()

    XCTAssertEqual(registers.a, 0xFF)
    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertTrue(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testXCHG() {
    addToMemory([0xEB])
    registers.d = 0x33
    registers.e = 0x55
    registers.h = 0x00
    registers.l = 0xFF

    cpu.start()

    XCTAssertEqual(registers.d, 0x00)
    XCTAssertEqual(registers.e, 0xFF)
    XCTAssertEqual(registers.h, 0x33)
    XCTAssertEqual(registers.l, 0x55)
  }

  func testXTHL() {
    addToMemory([0xE3])
    memory[0x10AD] = 0xF0
    memory[0x10AE] = 0x0D
    registers.h = 0x0B
    registers.l = 0x3C
    stackPointer = 0x10AD

    cpu.start()

    XCTAssertEqual(memory[0x10AD], 0x3C)
    XCTAssertEqual(memory[0x10AE], 0x0B)
    XCTAssertEqual(registers.h, 0x0D)
    XCTAssertEqual(registers.l, 0xF0)
  }

  func testXRA() {
    addToMemory([0xA8])
    registers.a = 0x5C
    registers.b = 0x78

    cpu.start()

    XCTAssertEqual(registers.a, 0x24)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testXRI() {
    addToMemory([0xEE, 0x81])
    registers.a = 0x3B

    cpu.start()

    XCTAssertEqual(registers.a, 0xBA)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }
}
