//: Playground - noun: a place where people can play

import Cocoa

let min: Double = 0.9
let max: Double = 1.1

let common: Double = 58

Int((common * min) * pow(1.1, Double(1 - 1)))
Int((common * 1.0) * pow(1.1, Double(1 - 1)))
Int((common * max) * pow(1.1, Double(1 - 1)))

Int((common * min) * pow(1.1, Double(5 - 1)))
let rare: Double = Double(Int((common * 1.0) * pow(1.1, Double(5 - 1))))
Int((common * max) * pow(1.1, Double(5 - 1)))

Int((common * min) * pow(1.1, Double(10 - 1)))
Int((common * 1.0) * pow(1.1, Double(10 - 1)))
Int((common * max) * pow(1.1, Double(10 - 1)))


Int((rare * min) * pow(1.1, Double(1 - 1)))
Int((rare * 1.0) * pow(1.1, Double(1 - 1)))
Int((rare * max) * pow(1.1, Double(1 - 1)))

Int((rare * min) * pow(1.1, Double(5 - 1)))
let epic: Double = Double(Int((rare * 1.0) * pow(1.1, Double(5 - 1))))
Int((rare * max) * pow(1.1, Double(5 - 1)))

Int((rare * min) * pow(1.1, Double(10 - 1)))
Int((rare * 1.0) * pow(1.1, Double(10 - 1)))
Int((rare * max) * pow(1.1, Double(10 - 1)))


Int((epic * min) * pow(1.1, Double(1 - 1)))
Int((epic * 1.0) * pow(1.1, Double(1 - 1)))
Int((epic * max) * pow(1.1, Double(1 - 1)))

Int((epic * min) * pow(1.1, Double(5 - 1)))
let legendary: Double = Double(Int((epic * 1.0) * pow(1.1, Double(5 - 1))))
Int((epic * max) * pow(1.1, Double(5 - 1)))

Int((epic * min) * pow(1.1, Double(10 - 1)))
Int((epic * 1.0) * pow(1.1, Double(10 - 1)))
Int((epic * max) * pow(1.1, Double(10 - 1)))

Int((epic * min) * pow(1.1, Double(1 - 1)))
Int((epic * 1.0) * pow(1.1, Double(1 - 1)))
Int((epic * max) * pow(1.1, Double(1 - 1)))

Int((legendary * min) * pow(1.1, Double(5 - 1)))
Int((legendary * 1.0) * pow(1.1, Double(5 - 1)))
Int((legendary * max) * pow(1.1, Double(5 - 1)))

Int((legendary * min) * pow(1.1, Double(10 - 1)))
Int((legendary * 1.0) * pow(1.1, Double(10 - 1)))
Int((legendary * max) * pow(1.1, Double(10 - 1)))


print(common)
print(rare)
print(epic)
print(legendary)
