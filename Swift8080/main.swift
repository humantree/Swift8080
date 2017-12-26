//
//  main.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 12/23/17.
//  Copyright © 2017 humantree. All rights reserved.
//

import Foundation

let cpu = CPU()

memory = Data(bytes: [0x97])
registers.a = 0x3E

cpu.start()

print(registers)
print(conditionBits)
