//
//  CPUDiag.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 2/2/18.
//  Copyright © 2018 humantree. All rights reserved.
//

import XCTest
@testable import Swift8080

class CPUBDOS: CPU {
  internal func bdosSystemReset() {
    exit(0)
  }

  internal func bdosWriteString() {
    var address = joinBytes(registerPairs.d)
    var byte = memory[Int(address)]
    var character = Character(UnicodeScalar(byte))

    while character != "$" {
      print(character, terminator: "")

      address += 1
      byte = memory[Int(address)]
      character = Character(UnicodeScalar(byte))
    }

    print()
  }

  override internal func jump(condition: Bool = true) {
    let address = joinBytes(getNextTwoBytes())

    if condition {
      switch address {
      case 0x00: bdosSystemReset()
      case 0x05: if registers.c == 0x09 { bdosWriteString() }
      default: programCounter = address
      }
    }
  }
}

// MARK: -
class CPUDiag: XCTestCase {
  let cpu = CPUBDOS()

  func testRunCPUDiag() {
    do {
      let directory = NSURL(fileURLWithPath: NSTemporaryDirectory())
      let logURL = directory.appendingPathComponent("console.log")!

      try loadROM("cpudiag", withExtension: "bin",
                  atLocation: 0x0100,
                  fromBundle: Bundle(for: type(of: self)))

      freopen(logURL.path, "a+", stdout)

      programCounter = 0x0100
      cpu.start()

      fclose(stdout)

      let log = try String(contentsOf: logURL, encoding: .utf8)
      XCTAssertTrue(log.contains("CPU IS OPERATIONAL"))

      try FileManager.default.removeItem(at: logURL)
    } catch {
      XCTFail()
    }
  }
}
