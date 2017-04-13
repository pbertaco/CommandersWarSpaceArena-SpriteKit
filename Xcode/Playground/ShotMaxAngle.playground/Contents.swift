//: Playground - noun: a place where people can play

import Cocoa

let π = CGFloat(Double.pi)

extension CGFloat {
    var toRadians: CGFloat { return self * π / 180.0 }
    var toDegrees: CGFloat { return self * 180.0 / π }
}

let distance: CGFloat = 20

let spaceshipRadius: CGFloat = 10

if distance >= spaceshipRadius {
    asin(spaceshipRadius/distance).toDegrees
}
