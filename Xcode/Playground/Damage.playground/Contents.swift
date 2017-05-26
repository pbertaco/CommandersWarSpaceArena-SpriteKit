//: Playground - noun: a place where people can play

import Cocoa

//common, uncommon, rare, heroic, epic, legendary, immortal

let min: Double = 0.9
let max: Double = 1.1

let t1: Double = 11

round((t1 * min) * pow(1.1, Double(1 - 1)))
round((t1 * 1.0) * pow(1.1, Double(1 - 1)))
round((t1 * max) * pow(1.1, Double(1 - 1)))

round((t1 * min) * pow(1.1, Double(5 - 1)))
let t2: Double = Double(round((t1 * 1.0) * pow(1.1, Double(5 - 1))))
round((t1 * max) * pow(1.1, Double(5 - 1)))

round((t1 * min) * pow(1.1, Double(10 - 1)))
round((t1 * 1.0) * pow(1.1, Double(10 - 1)))
round((t1 * max) * pow(1.1, Double(10 - 1)))


round((t2 * min) * pow(1.1, Double(1 - 1)))
round((t2 * 1.0) * pow(1.1, Double(1 - 1)))
round((t2 * max) * pow(1.1, Double(1 - 1)))

round((t2 * min) * pow(1.1, Double(5 - 1)))
let t3: Double = Double(round((t2 * 1.0) * pow(1.1, Double(5 - 1))))
round((t2 * max) * pow(1.1, Double(5 - 1)))

round((t2 * min) * pow(1.1, Double(10 - 1)))
round((t2 * 1.0) * pow(1.1, Double(10 - 1)))
round((t2 * max) * pow(1.1, Double(10 - 1)))


round((t3 * min) * pow(1.1, Double(1 - 1)))
round((t3 * 1.0) * pow(1.1, Double(1 - 1)))
round((t3 * max) * pow(1.1, Double(1 - 1)))

round((t3 * min) * pow(1.1, Double(5 - 1)))
let t4: Double = Double(round((t3 * 1.0) * pow(1.1, Double(5 - 1))))
round((t3 * max) * pow(1.1, Double(5 - 1)))

round((t3 * min) * pow(1.1, Double(10 - 1)))
round((t3 * 1.0) * pow(1.1, Double(10 - 1)))
round((t3 * max) * pow(1.1, Double(10 - 1)))


round((t4 * min) * pow(1.1, Double(1 - 1)))
round((t4 * 1.0) * pow(1.1, Double(1 - 1)))
round((t4 * max) * pow(1.1, Double(1 - 1)))

round((t4 * min) * pow(1.1, Double(5 - 1)))
let t5: Double = Double(round((t4 * 1.0) * pow(1.1, Double(5 - 1))))
round((t4 * max) * pow(1.1, Double(5 - 1)))

round((t4 * min) * pow(1.1, Double(10 - 1)))
round((t4 * 1.0) * pow(1.1, Double(10 - 1)))
round((t4 * max) * pow(1.1, Double(10 - 1)))


round((t5 * min) * pow(1.1, Double(1 - 1)))
round((t5 * 1.0) * pow(1.1, Double(1 - 1)))
round((t5 * max) * pow(1.1, Double(1 - 1)))

round((t5 * min) * pow(1.1, Double(5 - 1)))
let t6: Double = Double(round((t5 * 1.0) * pow(1.1, Double(5 - 1))))
round((t5 * max) * pow(1.1, Double(5 - 1)))

round((t5 * min) * pow(1.1, Double(10 - 1)))
round((t5 * 1.0) * pow(1.1, Double(10 - 1)))
round((t5 * max) * pow(1.1, Double(10 - 1)))


round((t6 * min) * pow(1.1, Double(1 - 1)))
round((t6 * 1.0) * pow(1.1, Double(1 - 1)))
round((t6 * max) * pow(1.1, Double(1 - 1)))

round((t6 * min) * pow(1.1, Double(5 - 1)))
let t7: Double = Double(round((t6 * 1.0) * pow(1.1, Double(5 - 1))))
round((t6 * max) * pow(1.1, Double(5 - 1)))

round((t6 * min) * pow(1.1, Double(10 - 1)))
round((t6 * 1.0) * pow(1.1, Double(10 - 1)))
round((t6 * max) * pow(1.1, Double(10 - 1)))


round((t7 * min) * pow(1.1, Double(1 - 1)))
round((t7 * 1.0) * pow(1.1, Double(1 - 1)))
round((t7 * max) * pow(1.1, Double(1 - 1)))

round((t7 * min) * pow(1.1, Double(5 - 1)))
round((t7 * 1.0) * pow(1.1, Double(5 - 1)))
round((t7 * max) * pow(1.1, Double(5 - 1)))

round((t7 * min) * pow(1.1, Double(10 - 1)))
round((t7 * 1.0) * pow(1.1, Double(10 - 1)))
round((t7 * max) * pow(1.1, Double(10 - 1)))


print(t1)
print(t2)
print(t3)
print(t4)
print(t5)
print(t6)
print(t7)

let shotsPerSecond: Double = 5
let seconds: Double = 10

print("\n")

print(t1 * shotsPerSecond * seconds)
print(t2 * shotsPerSecond * seconds)
print(t3 * shotsPerSecond * seconds)
print(t4 * shotsPerSecond * seconds)
print(t5 * shotsPerSecond * seconds)
print(t6 * shotsPerSecond * seconds)
print(t7 * shotsPerSecond * seconds)

/*
 11.0
 16.0
 23.0
 34.0
 50.0
 73.0
 107.0
 
 
 550.0
 800.0
 1150.0
 1700.0
 2500.0
 3650.0
 5350.0
 */
