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
             atLocation location: Int = 0,
             fromBundle bundle: Bundle = Bundle.main) throws {

  let romURL = bundle.url(forResource: filename,
                          withExtension: fileExtension)!
  let romData = try Data.init(contentsOf: romURL)
  let romRange = location..<romData.count + location

  memory.replaceSubrange(romRange, with: romData)
}
