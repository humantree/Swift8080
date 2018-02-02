//
//  Debugger.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 2/2/18.
//  Copyright © 2018 humantree. All rights reserved.
//

import Foundation

let debug = true
let skipNOP = true

func logDisassembly(_ opcode: Opcode) {
  if !debug { return }
  if skipNOP && opcode == .NOP { return }

  let address = String(format: "%04X", programCounter - 1)
  var log = "\(address)\t\(opcode.description)"

  if opcode.additionalBytes > 0 {
    log += " "

    for i in (1...opcode.additionalBytes).reversed() {
      let byte = memory[Int(programCounter) + i]
      log += String(format: "%02X", byte)
    }
  }

  print(log)
}
