//
//  CPUTests.swift
//  8080-emulatorTests
//
//  Created by Christopher Oldfield on 12/26/17.
//  Copyright © 2017 humantree. All rights reserved.
//

import XCTest
@testable import _080_emulator

class CPUTests: XCTestCase {
  let cpu = CPU()

  override func setUp() {
    super.setUp()

    conditionBits = ConditionBits()
    memory = Data()
    programCounter = UInt16()
    registers = Registers()
    stackPointer = UInt16()
  }

  func testADC1() {
    memory = Data.init(bytes: [0x89])
    registers.c = 0x3D
    registers.a = 0x42

    cpu.start()

    XCTAssertTrue(registers.a == 0x7F)

    XCTAssertFalse(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADC2() {
    memory = Data.init(bytes: [0x89])
    registers.c = 0x3D
    registers.a = 0x42
    conditionBits.carry = true

    cpu.start()

    XCTAssertTrue(registers.a == 0x80)

    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertFalse(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADD1() {
    memory = Data.init(bytes: [0x87])
    registers.a = 0x0F

    cpu.start()

    XCTAssertTrue(registers.a == 0x1E)

    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testADD2() {
    memory = Data.init(bytes: [0x82])
    registers.d = 0x2E
    registers.a = 0x6C

    cpu.start()

    XCTAssertTrue(registers.a == 0x9A)

    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertTrue(conditionBits.sign)
    XCTAssertFalse(conditionBits.zero)
  }

  func testNOP() {
    memory = Data.init(bytes: [0x00])
    cpu.start()
  }

  func testSUB() {
    memory = Data.init(bytes: [0x97])
    registers.a = 0x3E

    cpu.start()

    XCTAssertTrue(registers.a == 0x00)

    XCTAssertTrue(conditionBits.auxiliaryCarry)
    XCTAssertFalse(conditionBits.carry)
    XCTAssertTrue(conditionBits.parity)
    XCTAssertFalse(conditionBits.sign)
    XCTAssertTrue(conditionBits.zero)
  }
}
