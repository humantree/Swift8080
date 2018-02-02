//
//  main.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 12/23/17.
//  Copyright © 2017 humantree. All rights reserved.
//

import Foundation

let cpu = CPU()

let romURL = Bundle.main.url(forResource: "rom", withExtension: nil)!
let romData = try Data.init(contentsOf: romURL)

memory.replaceSubrange(0..<romData.count, with: romData)

cpu.start()
