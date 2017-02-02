//: Playground - noun: a place where people can play

import Cocoa

enum rarity: Int {
    case common = 500, rare = 700, epic = 1000, legendary = 1450
}

let rarities: [rarity] = [.common, .rare, .epic, .legendary]

var missions = [[rarity]]()

for a in rarities {
    for b in rarities {
        for c in rarities {
            for d in rarities {
                missions.append([a, b, c, d])//.sorted(by: { $0.rawValue > $1.rawValue }))
            }
        }
    }
}

missions.sort { (a: [rarity], b: [rarity]) -> Bool in
    
    var aTotal = 0
    var bTotal = 0
    
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

var i: Float = 0
for m in finalMissions {
    print("Mission(level: \(Int(i/Float(finalMissions.count) * 10.0) + 1), rarities: \(m)),")
    i = i + 1
}

finalMissions.count
