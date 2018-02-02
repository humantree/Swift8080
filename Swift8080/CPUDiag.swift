//
//  CPUDiag.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 2/2/18.
//  Copyright © 2018 humantree. All rights reserved.
//

import Foundation

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

func loadCPUDiag() throws {
  cpu = CPUBDOS()
  programCounter = 0x0100

  try loadROM("cpudiag", withExtension: "bin", atLocation: 0x0100)
}
