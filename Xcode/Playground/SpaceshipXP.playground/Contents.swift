//: Playground - noun: a place where people can play

import Cocoa

func xpForLevel(level x: Int) -> Int {
    let x = Double(x - 1)
    let xp = pow(2, x) * 1000
    return Int(xp)
}

for i in 2...10 {
    print("level \(i) \(xpForLevel(level: i))")
}
