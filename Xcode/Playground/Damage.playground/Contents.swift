//: Playground - noun: a place where people can play

import Cocoa

let min: Double = 0.9
let max: Double = 1.1

let common: Double = 11

round((common * min) * pow(1.1, Double(1 - 1)))
round((common * 1.0) * pow(1.1, Double(1 - 1)))
round((common * max) * pow(1.1, Double(1 - 1)))

round((common * min) * pow(1.1, Double(5 - 1)))
let rare: Double = Double(round((common * 1.0) * pow(1.1, Double(5 - 1))))
round((common * max) * pow(1.1, Double(5 - 1)))

round((common * min) * pow(1.1, Double(10 - 1)))
round((common * 1.0) * pow(1.1, Double(10 - 1)))
round((common * max) * pow(1.1, Double(10 - 1)))


round((rare * min) * pow(1.1, Double(1 - 1)))
round((rare * 1.0) * pow(1.1, Double(1 - 1)))
round((rare * max) * pow(1.1, Double(1 - 1)))

round((rare * min) * pow(1.1, Double(5 - 1)))
let epic: Double = Double(round((rare * 1.0) * pow(1.1, Double(5 - 1))))
round((rare * max) * pow(1.1, Double(5 - 1)))

round((rare * min) * pow(1.1, Double(10 - 1)))
round((rare * 1.0) * pow(1.1, Double(10 - 1)))
round((rare * max) * pow(1.1, Double(10 - 1)))


round((epic * min) * pow(1.1, Double(1 - 1)))
round((epic * 1.0) * pow(1.1, Double(1 - 1)))
round((epic * max) * pow(1.1, Double(1 - 1)))

round((epic * min) * pow(1.1, Double(5 - 1)))
let legendary: Double = Double(round((epic * 1.0) * pow(1.1, Double(5 - 1))))
round((epic * max) * pow(1.1, Double(5 - 1)))

round((epic * min) * pow(1.1, Double(10 - 1)))
round((epic * 1.0) * pow(1.1, Double(10 - 1)))
round((epic * max) * pow(1.1, Double(10 - 1)))

round((legendary * min) * pow(1.1, Double(1 - 1)))
round((legendary * 1.0) * pow(1.1, Double(1 - 1)))
round((legendary * max) * pow(1.1, Double(1 - 1)))

round((legendary * min) * pow(1.1, Double(5 - 1)))
round((legendary * 1.0) * pow(1.1, Double(5 - 1)))
round((legendary * max) * pow(1.1, Double(5 - 1)))

round((legendary * min) * pow(1.1, Double(10 - 1)))
round((legendary * 1.0) * pow(1.1, Double(10 - 1)))
round((legendary * max) * pow(1.1, Double(10 - 1)))


print(common)
print(rare)
print(epic)
print(legendary)

let shotsPerSecond: Double = 5
let seconds: Double = 10

print("\n")

print(common * shotsPerSecond * seconds)
print(rare * shotsPerSecond * seconds)
print(epic * shotsPerSecond * seconds)
print(legendary * shotsPerSecond * seconds)
