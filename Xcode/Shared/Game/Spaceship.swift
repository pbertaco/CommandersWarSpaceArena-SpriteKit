//
//  Spaceship.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode {
    
    enum rarity: Int {
        case common, rare, epic, legendary
    }
    
    static var skins: [String] = [
        "spaceshipA", "spaceshipB", "spaceshipC", "spaceshipD", "spaceshipE",
        "spaceshipF", "spaceshipG", "spaceshipH"
    ]
    
    private(set) var spaceshipData: SpaceshipData?
    
    var level: Int {
        get { return self.level }
        set { self.spaceshipData?.level = Int16(newValue)
            self.level = newValue
        }
    }
    
    var damage: Int = 1
    var life: Int = 1
    var rarity: rarity = .common
    
    var skinIndex: Int = 0
    var colorRed: CGFloat = 1
    var colorGreen: CGFloat = 1
    var colorBlue: CGFloat = 1
    var baseDamage: Int = 1
    var baseLife: Int = 1
    
    init(spaceshipData: SpaceshipData) {
        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        self.spaceshipData = spaceshipData
        
        let color = SKColor(
            red: CGFloat(spaceshipData.colorRed),
            green: CGFloat(spaceshipData.colorGreen),
            blue: CGFloat(spaceshipData.colorBlue), alpha: 1)
        
        self.load(level: Int(spaceshipData.level),
                  baseDamage: Int(spaceshipData.baseDamage),
                  baseLife: Int(spaceshipData.baseLife),
                  skinIndex: Int(spaceshipData.skin), color: color)
    }
    
    init() {
        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        
        self.rarity = .common
        
        self.load(level: 1,
                  baseDamage: GameMath.randomBaseDamage(rarity: self.rarity),
                  baseLife: GameMath.randomBaseLife(rarity: self.rarity),
                  skinIndex: Int.random(Spaceship.skins.count),
                  color: Spaceship.randomColor())
    }
    
    func load(level: Int, baseDamage: Int, baseLife: Int,
              skinIndex: Int, color: SKColor) {
        self.skinIndex = skinIndex
        
        let texture = Spaceship.skinTexture(index: skinIndex)
        self.texture = texture
        self.size = texture.size()
        
        self.color = color
        self.colorBlendFactor = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func skinTexture(index i: Int) -> SKTexture {
        let texture = SKTexture(imageNamed: Spaceship.skins[i])
        texture.filteringMode = GameScene.defaultFilteringMode
        return texture
    }
    
    static func randomColor() -> SKColor {
        var red = CGFloat.random()
        var green = CGFloat.random()
        var blue = CGFloat.random()
        let maxColor = 1 - max(max(red, green), blue)
        
        red = red + maxColor
        green = green + maxColor
        blue = blue + maxColor
        
        return SKColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
