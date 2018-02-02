//
//  ROM.swift
//  Swift8080
//
//  Created by Christopher Oldfield on 2/2/18.
//  Copyright © 2018 humantree. All rights reserved.
//

import Foundation

func loadROM(_ filename: String,
             withExtension fileExtension: String? = nil,
             atLocation location: Int = 0) throws {

  let romURL = Bundle.main.url(forResource: filename,
                               withExtension: fileExtension)!
  let romData = try Data.init(contentsOf: romURL)
  let romRange = location..<romData.count + location

  memory.replaceSubrange(romRange, with: romData)
}
