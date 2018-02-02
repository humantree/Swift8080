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

func log(opcode: Opcode) {
  if !debug { return }
  if skipNOP && opcode == .NOP { return }

  let address = String.init(format: "%04X", programCounter - 1)
  print("\(address)\t\(opcode)")
}
