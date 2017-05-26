//: Playground - noun: a place where people can play

import Cocoa
import SpriteKit

class GameColors {
    static let fire = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    static let ice = #colorLiteral(red: 0, green: 1, blue: 1, alpha: 1)
    static let wind = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1)
    static let earth = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
    static let thunder = #colorLiteral(red: 1, green: 0, blue: 1, alpha: 1)
    static let water = #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)
    static let light = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let darkness = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
}


public enum Elements: Int {
    case fire
    case ice
    case wind
    case earth
    case thunder
    case water
    case light
    case darkness
}

class Element {
    
    var element: Elements
    var strength: Elements
    var weakness: Elements
    var color: SKColor
    
    init(element: Elements, strength: Elements, weakness: Elements) {
        self.element = element
        self.strength = strength
        self.weakness = weakness
        
        var elementColor = GameColors.darkness
        
        switch element {
        case .fire:
            elementColor = GameColors.fire
            break
        case .ice:
            elementColor = GameColors.ice
            break
        case .wind:
            elementColor = GameColors.wind
            break
        case .earth:
            elementColor = GameColors.earth
            break
        case .thunder:
            elementColor = GameColors.thunder
            break
        case .water:
            elementColor = GameColors.water
            break
        case .light:
            elementColor = GameColors.light
            break
        case .darkness:
            elementColor = GameColors.darkness
            break
        }
        self.color = elementColor
    }
    
    static var types: [Elements: Element] = [
        .fire: Element(element: .fire, strength: .ice, weakness: .water),
        .ice: Element(element: .ice, strength: .wind, weakness: .fire),
        .wind: Element(element: .wind, strength: .earth, weakness: .ice),
        .earth: Element(element: .earth, strength: .thunder, weakness: .wind),
        .thunder: Element(element: .thunder, strength: .water, weakness: .earth),
        .water: Element(element: .water, strength: .fire, weakness: .thunder),
        .light: Element(element: .light, strength: .light, weakness: .darkness),
        .darkness: Element(element: .darkness, strength: .darkness, weakness: .light)
    ]
}

enum rarity: UInt16 {
    case common = 550, uncommon = 800, rare = 1150, heroic = 1700, epic = 2500, legendary = 3650, supreme = 5350
}

let rarities: [rarity] = [.common, .uncommon, .rare, .heroic, .epic, .legendary, .supreme]

var missions = [[rarity]]()

for a in rarities {
    for b in rarities {
        for c in rarities {
            for d in rarities {
                missions.append([a, b, c, d].sorted(by: { $0.rawValue > $1.rawValue }))
            }
        }
    }
}

missions.sort { (a: [rarity], b: [rarity]) -> Bool in
    
    var aTotal: UInt16 = 0
    var bTotal: UInt16 = 0
    
    for r in a {
        aTotal = aTotal + r.rawValue
    }
    
    for r in b {
        bTotal = bTotal + r.rawValue
    }
    
    return aTotal < bTotal
}

var finalMissions = [String]()

for m in missions {
    
    let finalMission = "[.\(m[0]), .\(m[1]), .\(m[2]), .\(m[3])]"
    
    if !finalMissions.contains(finalMission) {
        finalMissions.append(finalMission)
    }
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func elementFor(color: SKColor) -> Element {
    
    let color: CIColor = {
        let color = CIColor(color: color)
        #if os(OSX)
            return color!
        #else
            return color
        #endif
    }()
    
    let red  = color.red
    let green = color.green
    let blue = color.blue
    
    var element: Element? = Element.types[.darkness]
    
    switch (red > 0.5, green > 0.5, blue > 0.5) {
        
    case (true, false, false):
        element = Element.types[.fire]
        break
    case (false, true, false):
        element = Element.types[.earth]
        break
    case (false, false, true):
        element = Element.types[.water]
        break
        
    case (false, true, true):
        element = Element.types[.ice]
        break
    case (true, false, true):
        element = Element.types[.thunder]
        break
    case (true, true, false):
        element = Element.types[.wind]
        break
        
    case (true, true, true):
        element = Element.types[.light]
        break
    case (false, false, false):
        element = Element.types[.darkness]
        break
    }
    
    return element!
}

func randomColorFor(element: Elements) -> SKColor {
    let color = randomColor()
    if elementFor(color: color).element == element {
        return color
    } else {
        return randomColorFor(element: element)
    }
}

func randomColor() -> SKColor {
    var red = random()
    var green = random()
    var blue = random()
    
    let color = SKColor(red: red, green: green, blue: blue, alpha: 1)
    let element = elementFor(color: color)
    
    let elementColor: CIColor = {
        let color = CIColor(color: element.color)
        #if os(OSX)
            return color!
        #else
            return color
        #endif
    }()
    
    red = (red + elementColor.red) / 2
    green = (green + elementColor.green) / 2
    blue = (blue + elementColor.blue) / 2
    
    if element.element != .darkness {
        let maxColor = 1 - max(max(red, green), blue)
        red = red + maxColor
        green = green + maxColor
        blue = blue + maxColor
    }
    
    return SKColor(red: red, green: green, blue: blue, alpha: 1)
}

var i: Float = 0
var iElement = 0
for m in finalMissions {
    
    let element = Elements(rawValue: iElement)!
    if element == .darkness {
        iElement = 0
    } else {
        iElement = iElement + 1
    }
    
    let color = randomColorFor(element: element)
    
    let colorString = "SKColor(red: \(String(format: "%.1f", color.redComponent)), green: \(String(format: "%.1f", color.greenComponent)), blue: \(String(format: "%.1f", color.blueComponent)), alpha: 1)"
    
    print("Mission(level: \(Int(i/Float(finalMissions.count) * 12.0) + 1), rarities: \(m), color: \(colorString)),")
    i = i + 1
}

finalMissions.count

/*
 Mission(level: 1, rarities: [.common, .common, .common, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 1, rarities: [.uncommon, .common, .common, .common], color: SKColor(red: 0.2, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 1, rarities: [.uncommon, .uncommon, .common, .common], color: SKColor(red: 1.0, green: 0.9, blue: 0.1, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .common, .common, .common], color: SKColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 1, rarities: [.uncommon, .uncommon, .uncommon, .common], color: SKColor(red: 0.9, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .uncommon, .common, .common], color: SKColor(red: 0.3, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 1, rarities: [.uncommon, .uncommon, .uncommon, .uncommon], color: SKColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .uncommon, .uncommon, .common], color: SKColor(red: 0.5, green: 0.3, blue: 0.5, alpha: 1)),
 Mission(level: 1, rarities: [.heroic, .common, .common, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.1, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .rare, .common, .common], color: SKColor(red: 0.4, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .uncommon, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.9, blue: 0.0, alpha: 1)),
 Mission(level: 1, rarities: [.heroic, .uncommon, .common, .common], color: SKColor(red: 0.1, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .rare, .uncommon, .common], color: SKColor(red: 1.0, green: 0.2, blue: 0.8, alpha: 1)),
 Mission(level: 1, rarities: [.heroic, .uncommon, .uncommon, .common], color: SKColor(red: 0.4, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .rare, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.8, blue: 1.0, alpha: 1)),
 Mission(level: 1, rarities: [.heroic, .rare, .common, .common], color: SKColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1)),
 Mission(level: 1, rarities: [.rare, .rare, .rare, .common], color: SKColor(red: 1.0, green: 0.2, blue: 0.1, alpha: 1)),
 Mission(level: 1, rarities: [.heroic, .uncommon, .uncommon, .uncommon], color: SKColor(red: 0.1, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 2, rarities: [.epic, .common, .common, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .rare, .uncommon, .common], color: SKColor(red: 0.3, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 2, rarities: [.rare, .rare, .rare, .uncommon], color: SKColor(red: 0.8, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 2, rarities: [.epic, .uncommon, .common, .common], color: SKColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .rare, .uncommon, .uncommon], color: SKColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .heroic, .common, .common], color: SKColor(red: 0.5, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .rare, .rare, .common], color: SKColor(red: 1.0, green: 0.4, blue: 0.3, alpha: 1)),
 Mission(level: 2, rarities: [.rare, .rare, .rare, .rare], color: SKColor(red: 0.2, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 2, rarities: [.epic, .uncommon, .uncommon, .common], color: SKColor(red: 1.0, green: 0.9, blue: 0.2, alpha: 1)),
 Mission(level: 2, rarities: [.epic, .rare, .common, .common], color: SKColor(red: 0.1, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .heroic, .uncommon, .common], color: SKColor(red: 1.0, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .rare, .rare, .uncommon], color: SKColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 2, rarities: [.epic, .uncommon, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.8, blue: 0.9, alpha: 1)),
 Mission(level: 2, rarities: [.epic, .rare, .uncommon, .common], color: SKColor(red: 0.5, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .heroic, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.1, blue: 0.2, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .heroic, .rare, .common], color: SKColor(red: 0.2, green: 0.8, blue: 1.0, alpha: 1)),
 Mission(level: 2, rarities: [.heroic, .rare, .rare, .rare], color: SKColor(red: 1.0, green: 0.9, blue: 0.2, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .rare, .uncommon, .uncommon], color: SKColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .heroic, .common, .common], color: SKColor(red: 0.9, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 3, rarities: [.legendary, .common, .common, .common], color: SKColor(red: 0.4, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 3, rarities: [.heroic, .heroic, .rare, .uncommon], color: SKColor(red: 1.0, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .rare, .rare, .common], color: SKColor(red: 0.5, green: 0.4, blue: 0.4, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .heroic, .uncommon, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 3, rarities: [.legendary, .uncommon, .common, .common], color: SKColor(red: 0.2, green: 1.0, blue: 0.8, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .rare, .rare, .uncommon], color: SKColor(red: 0.9, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 3, rarities: [.heroic, .heroic, .heroic, .common], color: SKColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 3, rarities: [.heroic, .heroic, .rare, .rare], color: SKColor(red: 0.8, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 3, rarities: [.legendary, .uncommon, .uncommon, .common], color: SKColor(red: 0.4, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .heroic, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .heroic, .rare, .common], color: SKColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 1)),
 Mission(level: 3, rarities: [.legendary, .rare, .common, .common], color: SKColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1)),
 Mission(level: 3, rarities: [.heroic, .heroic, .heroic, .uncommon], color: SKColor(red: 0.1, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .rare, .rare, .rare], color: SKColor(red: 1.0, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 3, rarities: [.legendary, .uncommon, .uncommon, .uncommon], color: SKColor(red: 0.3, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 3, rarities: [.epic, .epic, .common, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.9, alpha: 1)),
 Mission(level: 4, rarities: [.legendary, .rare, .uncommon, .common], color: SKColor(red: 0.3, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .heroic, .rare, .uncommon], color: SKColor(red: 0.8, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 4, rarities: [.heroic, .heroic, .heroic, .rare], color: SKColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .epic, .uncommon, .common], color: SKColor(red: 1.0, green: 0.4, blue: 0.1, alpha: 1)),
 Mission(level: 4, rarities: [.legendary, .rare, .uncommon, .uncommon], color: SKColor(red: 0.2, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 4, rarities: [.legendary, .heroic, .common, .common], color: SKColor(red: 1.0, green: 1.0, blue: 0.1, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .heroic, .heroic, .common], color: SKColor(red: 0.2, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 4, rarities: [.legendary, .rare, .rare, .common], color: SKColor(red: 0.9, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .heroic, .rare, .rare], color: SKColor(red: 0.3, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .epic, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 4, rarities: [.legendary, .heroic, .uncommon, .common], color: SKColor(red: 0.4, green: 0.3, blue: 0.5, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .heroic, .heroic, .uncommon], color: SKColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .epic, .rare, .common], color: SKColor(red: 0.1, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 4, rarities: [.legendary, .rare, .rare, .uncommon], color: SKColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1)),
 Mission(level: 4, rarities: [.heroic, .heroic, .heroic, .heroic], color: SKColor(red: 0.3, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 4, rarities: [.legendary, .heroic, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.2, blue: 0.9, alpha: 1)),
 Mission(level: 4, rarities: [.epic, .epic, .rare, .uncommon], color: SKColor(red: 0.4, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 5, rarities: [.supreme, .common, .common, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 5, rarities: [.epic, .heroic, .heroic, .rare], color: SKColor(red: 0.3, green: 0.3, blue: 0.5, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .heroic, .rare, .common], color: SKColor(red: 1.0, green: 0.1, blue: 0.2, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .rare, .rare, .rare], color: SKColor(red: 0.2, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 5, rarities: [.epic, .epic, .heroic, .common], color: SKColor(red: 1.0, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 5, rarities: [.supreme, .uncommon, .common, .common], color: SKColor(red: 0.3, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .epic, .common, .common], color: SKColor(red: 0.9, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .heroic, .rare, .uncommon], color: SKColor(red: 0.2, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 5, rarities: [.epic, .epic, .rare, .rare], color: SKColor(red: 0.9, green: 0.8, blue: 1.0, alpha: 1)),
 Mission(level: 5, rarities: [.epic, .epic, .heroic, .uncommon], color: SKColor(red: 0.3, green: 0.4, blue: 0.4, alpha: 1)),
 Mission(level: 5, rarities: [.supreme, .uncommon, .uncommon, .common], color: SKColor(red: 1.0, green: 0.5, blue: 0.4, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .epic, .uncommon, .common], color: SKColor(red: 0.3, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 5, rarities: [.supreme, .rare, .common, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 5, rarities: [.epic, .heroic, .heroic, .heroic], color: SKColor(red: 0.3, green: 1.0, blue: 0.5, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .heroic, .heroic, .common], color: SKColor(red: 0.9, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .heroic, .rare, .rare], color: SKColor(red: 0.2, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 5, rarities: [.legendary, .epic, .uncommon, .uncommon], color: SKColor(red: 0.9, green: 1.0, blue: 0.8, alpha: 1)),
 Mission(level: 5, rarities: [.supreme, .uncommon, .uncommon, .uncommon], color: SKColor(red: 0.4, green: 0.5, blue: 0.4, alpha: 1)),
 Mission(level: 6, rarities: [.supreme, .rare, .uncommon, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.2, alpha: 1)),
 Mission(level: 6, rarities: [.epic, .epic, .heroic, .rare], color: SKColor(red: 0.1, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 6, rarities: [.legendary, .epic, .rare, .common], color: SKColor(red: 1.0, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 6, rarities: [.legendary, .heroic, .heroic, .uncommon], color: SKColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 6, rarities: [.epic, .epic, .epic, .common], color: SKColor(red: 1.0, green: 0.2, blue: 0.9, alpha: 1)),
 Mission(level: 6, rarities: [.supreme, .rare, .uncommon, .uncommon], color: SKColor(red: 0.1, green: 0.0, blue: 1.0, alpha: 1)),
 Mission(level: 6, rarities: [.legendary, .epic, .rare, .uncommon], color: SKColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 6, rarities: [.supreme, .heroic, .common, .common], color: SKColor(red: 0.4, green: 0.4, blue: 0.3, alpha: 1)),
 Mission(level: 6, rarities: [.supreme, .rare, .rare, .common], color: SKColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1)),
 Mission(level: 6, rarities: [.legendary, .heroic, .heroic, .rare], color: SKColor(red: 0.2, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 6, rarities: [.epic, .epic, .epic, .uncommon], color: SKColor(red: 1.0, green: 0.9, blue: 0.2, alpha: 1)),
 Mission(level: 6, rarities: [.legendary, .epic, .heroic, .common], color: SKColor(red: 0.1, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 6, rarities: [.supreme, .heroic, .uncommon, .common], color: SKColor(red: 1.0, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 6, rarities: [.epic, .epic, .heroic, .heroic], color: SKColor(red: 0.4, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 6, rarities: [.legendary, .legendary, .common, .common], color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 6, rarities: [.legendary, .epic, .rare, .rare], color: SKColor(red: 0.4, green: 0.4, blue: 0.3, alpha: 1)),
 Mission(level: 6, rarities: [.supreme, .rare, .rare, .uncommon], color: SKColor(red: 1.0, green: 0.3, blue: 0.4, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .heroic, .uncommon, .uncommon], color: SKColor(red: 0.2, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .epic, .heroic, .uncommon], color: SKColor(red: 0.9, green: 1.0, blue: 0.1, alpha: 1)),
 Mission(level: 7, rarities: [.epic, .epic, .epic, .rare], color: SKColor(red: 0.2, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .legendary, .uncommon, .common], color: SKColor(red: 1.0, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .heroic, .rare, .common], color: SKColor(red: 0.4, green: 0.4, blue: 1.0, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .heroic, .heroic, .heroic], color: SKColor(red: 0.8, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .rare, .rare, .rare], color: SKColor(red: 0.5, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .legendary, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.3, blue: 0.4, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .epic, .common, .common], color: SKColor(red: 0.2, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .legendary, .rare, .common], color: SKColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .heroic, .rare, .uncommon], color: SKColor(red: 0.1, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .epic, .heroic, .rare], color: SKColor(red: 1.0, green: 0.3, blue: 0.9, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .epic, .uncommon, .common], color: SKColor(red: 0.4, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .epic, .epic, .common], color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 7, rarities: [.epic, .epic, .epic, .heroic], color: SKColor(red: 0.3, green: 0.4, blue: 0.3, alpha: 1)),
 Mission(level: 7, rarities: [.legendary, .legendary, .rare, .uncommon], color: SKColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .heroic, .heroic, .common], color: SKColor(red: 0.2, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 7, rarities: [.supreme, .heroic, .rare, .rare], color: SKColor(red: 1.0, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .epic, .uncommon, .uncommon], color: SKColor(red: 0.1, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 8, rarities: [.legendary, .epic, .epic, .uncommon], color: SKColor(red: 0.8, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .heroic, .heroic, .uncommon], color: SKColor(red: 0.4, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.legendary, .legendary, .heroic, .common], color: SKColor(red: 1.0, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .epic, .rare, .common], color: SKColor(red: 0.4, green: 0.4, blue: 0.2, alpha: 1)),
 Mission(level: 8, rarities: [.legendary, .epic, .heroic, .heroic], color: SKColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1)),
 Mission(level: 8, rarities: [.legendary, .legendary, .rare, .rare], color: SKColor(red: 0.2, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.legendary, .epic, .epic, .rare], color: SKColor(red: 1.0, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .epic, .rare, .uncommon], color: SKColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 8, rarities: [.legendary, .legendary, .heroic, .uncommon], color: SKColor(red: 0.8, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .heroic, .heroic, .rare], color: SKColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.epic, .epic, .epic, .epic], color: SKColor(red: 1.0, green: 0.8, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .legendary, .common, .common], color: SKColor(red: 0.3, green: 0.3, blue: 0.5, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .epic, .heroic, .common], color: SKColor(red: 1.0, green: 0.2, blue: 0.3, alpha: 1)),
 Mission(level: 8, rarities: [.legendary, .legendary, .heroic, .rare], color: SKColor(red: 0.4, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .epic, .rare, .rare], color: SKColor(red: 0.9, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 8, rarities: [.supreme, .legendary, .uncommon, .common], color: SKColor(red: 0.2, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .epic, .heroic, .uncommon], color: SKColor(red: 1.0, green: 0.3, blue: 0.9, alpha: 1)),
 Mission(level: 9, rarities: [.legendary, .epic, .epic, .heroic], color: SKColor(red: 0.5, green: 0.4, blue: 1.0, alpha: 1)),
 Mission(level: 9, rarities: [.legendary, .legendary, .epic, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.8, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .heroic, .heroic, .heroic], color: SKColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .legendary, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.1, blue: 0.3, alpha: 1)),
 Mission(level: 9, rarities: [.legendary, .legendary, .epic, .uncommon], color: SKColor(red: 0.2, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .epic, .heroic, .rare], color: SKColor(red: 0.9, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 9, rarities: [.legendary, .legendary, .heroic, .heroic], color: SKColor(red: 0.2, green: 1.0, blue: 0.1, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .legendary, .rare, .common], color: SKColor(red: 1.0, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .epic, .epic, .common], color: SKColor(red: 0.4, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .legendary, .rare, .uncommon], color: SKColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 9, rarities: [.legendary, .legendary, .epic, .rare], color: SKColor(red: 0.3, green: 0.4, blue: 0.3, alpha: 1)),
 Mission(level: 9, rarities: [.legendary, .epic, .epic, .epic], color: SKColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .epic, .epic, .uncommon], color: SKColor(red: 0.2, green: 0.9, blue: 1.0, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .legendary, .heroic, .common], color: SKColor(red: 1.0, green: 0.8, blue: 0.1, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .epic, .heroic, .heroic], color: SKColor(red: 0.2, green: 1.0, blue: 0.1, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .legendary, .rare, .rare], color: SKColor(red: 0.8, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 9, rarities: [.supreme, .legendary, .heroic, .uncommon], color: SKColor(red: 0.2, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .epic, .epic, .rare], color: SKColor(red: 0.8, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 10, rarities: [.legendary, .legendary, .epic, .heroic], color: SKColor(red: 0.3, green: 0.5, blue: 0.3, alpha: 1)),
 Mission(level: 10, rarities: [.legendary, .legendary, .legendary, .common], color: SKColor(red: 1.0, green: 0.3, blue: 0.2, alpha: 1)),
 Mission(level: 10, rarities: [.legendary, .legendary, .legendary, .uncommon], color: SKColor(red: 0.1, green: 1.0, blue: 0.8, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .supreme, .common, .common], color: SKColor(red: 0.9, green: 1.0, blue: 0.1, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .legendary, .heroic, .rare], color: SKColor(red: 0.2, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .legendary, .epic, .common], color: SKColor(red: 1.0, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .epic, .epic, .heroic], color: SKColor(red: 0.3, green: 0.4, blue: 1.0, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .supreme, .uncommon, .common], color: SKColor(red: 0.8, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 10, rarities: [.legendary, .legendary, .legendary, .rare], color: SKColor(red: 0.4, green: 0.4, blue: 0.5, alpha: 1)),
 Mission(level: 10, rarities: [.legendary, .legendary, .epic, .epic], color: SKColor(red: 1.0, green: 0.3, blue: 0.1, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .legendary, .epic, .uncommon], color: SKColor(red: 0.1, green: 1.0, blue: 0.8, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .supreme, .uncommon, .uncommon], color: SKColor(red: 1.0, green: 0.9, blue: 0.1, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .supreme, .rare, .common], color: SKColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .legendary, .heroic, .heroic], color: SKColor(red: 1.0, green: 0.2, blue: 0.9, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .supreme, .rare, .uncommon], color: SKColor(red: 0.4, green: 0.4, blue: 1.0, alpha: 1)),
 Mission(level: 10, rarities: [.supreme, .legendary, .epic, .rare], color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 11, rarities: [.legendary, .legendary, .legendary, .heroic], color: SKColor(red: 0.4, green: 0.4, blue: 0.3, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .epic, .epic, .epic], color: SKColor(red: 1.0, green: 0.2, blue: 0.3, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .heroic, .common], color: SKColor(red: 0.3, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .rare, .rare], color: SKColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .legendary, .epic, .heroic], color: SKColor(red: 0.4, green: 1.0, blue: 0.4, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .legendary, .legendary, .common], color: SKColor(red: 1.0, green: 0.2, blue: 0.9, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .heroic, .uncommon], color: SKColor(red: 0.4, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .legendary, .legendary, .uncommon], color: SKColor(red: 0.8, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 11, rarities: [.legendary, .legendary, .legendary, .epic], color: SKColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .heroic, .rare], color: SKColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .epic, .common], color: SKColor(red: 0.1, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .legendary, .legendary, .rare], color: SKColor(red: 0.8, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .legendary, .epic, .epic], color: SKColor(red: 0.1, green: 1.0, blue: 0.3, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .epic, .uncommon], color: SKColor(red: 1.0, green: 0.2, blue: 0.9, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .heroic, .heroic], color: SKColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .legendary, .legendary, .heroic], color: SKColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 11, rarities: [.supreme, .supreme, .epic, .rare], color: SKColor(red: 0.3, green: 0.5, blue: 0.4, alpha: 1)),
 Mission(level: 11, rarities: [.legendary, .legendary, .legendary, .legendary], color: SKColor(red: 1.0, green: 0.5, blue: 0.4, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .epic, .heroic], color: SKColor(red: 0.2, green: 1.0, blue: 0.9, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .legendary, .common], color: SKColor(red: 1.0, green: 0.9, blue: 0.1, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .legendary, .legendary, .epic], color: SKColor(red: 0.1, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .legendary, .uncommon], color: SKColor(red: 0.9, green: 0.1, blue: 1.0, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .legendary, .rare], color: SKColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .epic, .epic], color: SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .legendary, .heroic], color: SKColor(red: 0.4, green: 0.5, blue: 0.3, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .legendary, .legendary, .legendary], color: SKColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .supreme, .common], color: SKColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .legendary, .epic], color: SKColor(red: 1.0, green: 1.0, blue: 0.1, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .supreme, .uncommon], color: SKColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .supreme, .rare], color: SKColor(red: 0.9, green: 0.4, blue: 1.0, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .supreme, .heroic], color: SKColor(red: 0.2, green: 0.3, blue: 1.0, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .legendary, .legendary], color: SKColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .supreme, .epic], color: SKColor(red: 0.4, green: 0.3, blue: 0.3, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .supreme, .legendary], color: SKColor(red: 1.0, green: 0.2, blue: 0.3, alpha: 1)),
 Mission(level: 12, rarities: [.supreme, .supreme, .supreme, .supreme], color: SKColor(red: 0.2, green: 1.0, blue: 0.9, alpha: 1))
 */
