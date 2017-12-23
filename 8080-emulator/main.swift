//
//  main.swift
//  8080-emulator
//
//  Created by Christopher Oldfield on 12/23/17.
//  Copyright © 2017 humantree. All rights reserved.
//

import Foundation

struct ConditionBits {
  var carry = false
  var auxiliaryCarry = false
  var sign = false
  var zero = false
  var parity = false
}

struct Registers {
  var b = UInt8()
  var c = UInt8()
  var d = UInt8()
  var e = UInt8()
  var h = UInt8()
  var l = UInt8()
  var a = UInt8()
}

var conditionBits = ConditionBits()
var registers = Registers()

struct RegisterPairs {
  var b: (UInt8, UInt8) {
    get {
      return (registers.b, registers.c)
    }
    set {
      registers.b = newValue.0
      registers.c = newValue.1
    }
  }
  var d: (UInt8, UInt8) {
    get {
      return (registers.d, registers.e)
    }
    set {
      registers.d = newValue.0
      registers.e = newValue.1
    }
  }
  var h: (UInt8, UInt8) {
    get {
      return (registers.h, registers.l)
    }
    set {
      registers.h = newValue.0
      registers.l = newValue.1
    }
  }
  var psw: (UInt8, ConditionBits) {
    get {
      return (registers.a, conditionBits)
    }
    set {
      registers.a = newValue.0
      conditionBits = newValue.1
    }
  }
}

var registerPairs = RegisterPairs()

var memory = UInt8()
var programCounter = UInt16()
var stackPointer = UInt16()
