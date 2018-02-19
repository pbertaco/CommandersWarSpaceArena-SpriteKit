//: Playground - noun: a place where people can play

import SpriteKit

enum rarity: String {
    case common, uncommon, rare, heroic, epic, legendary, supreme
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func randomRarity() -> rarity {
    
    let n: CGFloat = random()
    var i: CGFloat = 1.0/2.0
    
    let rarities: [rarity] = [.uncommon, .rare, .heroic, .epic, .legendary, .supreme]
    var value: rarity = .common
    
    for r in rarities {
        if n < i {
            i = i / 2.0
            value = r
        }
    }
    
    return value
}

var commonCount = 0
var uncommonCount = 0
var rareCount = 0
var heroicCount = 0
var epicCount = 0
var legendaryCount = 0
var supremeCount = 0

for _ in 1...100 {
    switch randomRarity() {
    case .common:
        commonCount = commonCount + 1
        break
    case .uncommon:
        uncommonCount = uncommonCount + 1
        break
    case .rare:
        rareCount = rareCount + 1
        break
    case .heroic:
        heroicCount = heroicCount + 1
        break
    case .epic:
        epicCount = epicCount + 1
        break
    case .legendary:
        legendaryCount = legendaryCount + 1
        break
    case .supreme:
        supremeCount = supremeCount + 1
        break
    }
}
