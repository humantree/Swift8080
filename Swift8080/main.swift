//
//  main.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 12/23/17.
//  Copyright © 2017 humantree. All rights reserved.
//

import Foundation

var cpu = CPU()

try loadROM("rom")

debug = true
cpu.start()
