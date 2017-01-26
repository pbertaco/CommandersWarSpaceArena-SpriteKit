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
    
    static var selectedSpaceship: Spaceship?
    
    static var skins: [String] = [
        "spaceshipA", "spaceshipB", "spaceshipC", "spaceshipD", "spaceshipE",
        "spaceshipF", "spaceshipG", "spaceshipH"
    ]
    
    private(set) var spaceshipData: SpaceshipData?
    
    var level: Int! {
        didSet {
            self.spaceshipData?.level = Int16(self.level)
        }
    }
    
    var damage: Int = 1
    var maxHealth: Int = 1
    var speedAtribute: Int = 1
    
    var health: Int = 1
    
    var rarity: rarity = .common
    
    var skinIndex: Int = 0
    var colorRed: CGFloat = 1
    var colorGreen: CGFloat = 1
    var colorBlue: CGFloat = 1
    
    var startingPosition = CGPoint.zero
    var startingZPosition: CGFloat = 0
    var destination: CGPoint?
    var targetSpaceship: Spaceship?
    
    var team: Mothership.team
    
    var rotationToDestination: CGFloat = 0
    var totalRotationToDestination: CGFloat = 0
    
    var maxAngularVelocity: CGFloat = 3
    var angularImpulse: CGFloat = 0.0005
    var maxVelocitySquared: CGFloat = 0
    var force: CGFloat = 0
    
    var weaponRangeShapeNode: SKShapeNode?
    
    init(spaceshipData: SpaceshipData, loadPhysics: Bool = false, team: Mothership.team = .blue) {
        
        self.team = team
        
        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        self.spaceshipData = spaceshipData
        
        let color = SKColor(
            red: CGFloat(spaceshipData.colorRed),
            green: CGFloat(spaceshipData.colorGreen),
            blue: CGFloat(spaceshipData.colorBlue), alpha: 1)
        
        self.rarity = rarity(rawValue: Int(spaceshipData.rarity))!
        
        self.load(level: Int(spaceshipData.level),
                  baseDamage: Int(spaceshipData.baseDamage),
                  baseLife: Int(spaceshipData.baseLife),
                  baseSpeed: Int(spaceshipData.baseSpeed),
                  skinIndex: Int(spaceshipData.skin), color: color,
                  loadPhysics: loadPhysics,
                  team: team)
    }
    
    init(loadPhysics: Bool = false, team: Mothership.team = .blue) {
        
        self.team = team
        
        super.init(texture: nil, color: SKColor.clear, size: CGSize.zero)
        
        self.rarity = .common
        
        self.load(level: 1,
                  baseDamage: GameMath.randomBaseDamage(rarity: self.rarity),
                  baseLife: GameMath.randomBaseLife(rarity: self.rarity),
                  baseSpeed: GameMath.randomBaseSpeed(rarity: self.rarity),
                  skinIndex: Int.random(Spaceship.skins.count),
                  color: Spaceship.randomColor(),
                  loadPhysics: loadPhysics,
                  team: team)
    }
    
    func load(level: Int, baseDamage: Int, baseLife: Int, baseSpeed: Int,
              skinIndex: Int, color: SKColor, loadPhysics: Bool = false, team: Mothership.team) {
        
        self.level = level
        
        self.skinIndex = skinIndex
        
        let texture = Spaceship.skinTexture(index: skinIndex)
        self.texture = texture
        self.size = texture.size()
        self.setScaleToFit(width: 55, height: 55)
        
        self.color = color
        self.blendMode = .screen
        self.colorBlendFactor = 1
        
        self.maxHealth = GameMath.maxHealth(level: level, baseLife: baseLife)
        self.damage = GameMath.damage(level: level, baseDamage: baseDamage)
        self.speedAtribute = GameMath.speed(level: level, baseSpeed: baseSpeed)
        
        self.health = self.maxHealth
        
        if loadPhysics {
            self.loadPhysics()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if self.health > 0 {
            if let destination = self.destination {
                if self.position.distanceTo(destination) <= 55/2 {
                    if self.destination == self.startingPosition {
                        self.resetToStartingPosition()
                    }
                    self.destination = nil
                } else {
                    self.rotateTo(point: destination)
                    let multiplier = max(1 - abs(self.totalRotationToDestination * 2), 0)
                    self.applyForce(multiplier: multiplier)
                }
            } else {
                if let physicsBody = self.physicsBody {
                    if physicsBody.categoryBitMask == GameWorld.categoryBitMask.mothershipSpaceship.rawValue {
                        self.rotateTo(point: CGPoint(x: self.position.x, y: 0))
                        self.applyForce()
                    } else {
                        if let targetSpaceship = self.targetSpaceship {
                            if targetSpaceship.health <= 0 {
                                self.targetSpaceship = nil
                            } else {
                                
                                self.rotateTo(point: targetSpaceship.position)
                                
                                if self.position.distanceTo(targetSpaceship.position) <= 100 {
                                    let multiplier = max(1 - abs(self.totalRotationToDestination * 2), 0)
                                    self.applyForce(multiplier: multiplier)
                                } else {
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        self.updateWeaponRangeShapeNode()
    }
    
    func resetToStartingPosition() {
        self.position = self.startingPosition
        self.zRotation = self.startingZPosition
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0
        self.physicsBody?.isDynamic = false
    }
    
    func rotateTo(point: CGPoint) {
        if let physicsBody = self.physicsBody {
            
            let dx = Float(point.x - self.position.x)
            let dy = Float(point.y - self.position.y)
            
            self.rotationToDestination = CGFloat(-atan2(dx, dy))
            
            if abs(physicsBody.angularVelocity) < self.maxAngularVelocity {
                
                self.totalRotationToDestination = self.rotationToDestination - self.zRotation
                
                while self.totalRotationToDestination < -π { self.totalRotationToDestination += π * 2 }
                while self.totalRotationToDestination >  π { self.totalRotationToDestination -= π * 2 }
                
                physicsBody.applyAngularImpulse(self.totalRotationToDestination * self.angularImpulse)
            }
        }
    }
    
    func applyForce(multiplier: CGFloat = 1) {
        if let physicsBody = self.physicsBody {
            let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
            
            if velocitySquared < self.maxVelocitySquared {
                physicsBody.applyForce(CGVector(dx: -sin(self.zRotation) * self.force * multiplier, dy: cos(self.zRotation) * self.force * multiplier))
            }
        }
    }
    
    func touchUp(touch: UITouch) {
        guard let parent = self.parent else { return }
        
        let point = touch.location(in: parent)
        
        if self == Spaceship.selectedSpaceship {
            
            self.targetSpaceship = nil
            
            if self.contains(point) {
                
                if self.destination != nil {
                    
                    if let physicsBody = self.physicsBody {
                        if physicsBody.categoryBitMask == GameWorld.categoryBitMask.mothershipSpaceship.rawValue {
                            if physicsBody.allContactedBodies().filter({ (physicsBody: SKPhysicsBody) -> Bool in
                                return physicsBody.categoryBitMask == GameWorld.categoryBitMask.mothership.rawValue
                            }).count <= 0 {
                                self.setBitMasksToSpaceship()
                            }
                        }
                    }
                    
                    self.destination = nil
                }
                
            } else {
                self.physicsBody?.isDynamic = true
                self.destination = point
            }
        } else {
            if self.contains(point) {
                Spaceship.setSelected(spaceship: self)
            }
        }
    }
    
    func setTarget(spaceship: Spaceship) {
        
    }
    
    func setTarget(mothership: Mothership) {
        
    }
    
    static func setSelected(spaceship: Spaceship?) {
        Spaceship.selectedSpaceship = spaceship
        spaceship?.showWeaponRangeShapeNode()
    }
    
    func retreat() {
        self.physicsBody?.isDynamic = true
        self.destination = self.startingPosition
        self.setBitMasksToMothershipSpaceship()
        if self == Spaceship.selectedSpaceship {
            Spaceship.setSelected(spaceship: nil)
        }
    }
    
    func loadWeaponRangeShapeNode(gameWorld: GameWorld) {
        let shapeNode = SKShapeNode(circleOfRadius: 150)
        shapeNode.strokeColor = SKColor.white
        shapeNode.fillColor = SKColor.clear
        shapeNode.alpha = 0
        shapeNode.position = self.position
        gameWorld.addChild(shapeNode)
        
        self.weaponRangeShapeNode = shapeNode
    }
    
    func updateWeaponRangeShapeNode() {
        if let weaponRangeShapeNode = self.weaponRangeShapeNode {
            if self.health <= 0 {
                weaponRangeShapeNode.alpha = 0
            } else {
                weaponRangeShapeNode.position = self.position
                if self != Spaceship.selectedSpaceship {
                    if weaponRangeShapeNode.alpha > 0 {
                        weaponRangeShapeNode.alpha -= 0.06666666667
                    }
                }
            }
        }
    }
    
    func showWeaponRangeShapeNode() {
        self.weaponRangeShapeNode?.alpha = 1
    }
    
    func didBeginContact(with bodyB: SKPhysicsBody) {
        if let bodyA = self.physicsBody {
            switch GameWorld.categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            case [.mothershipSpaceship, .mothership]:
                break
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    func didEndContact(with bodyB: SKPhysicsBody) {
        if let bodyA = self.physicsBody {
            switch GameWorld.categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            case [.mothershipSpaceship, .mothership]:
                self.setBitMasksToSpaceship()
                break
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    func loadPhysics() {
        let physicsBody = SKPhysicsBody(circleOfRadius: 55/2)
        
        physicsBody.mass = 0.0455111116170883
        physicsBody.linearDamping = 2
        physicsBody.angularDamping = 5
        
        self.physicsBody = physicsBody
        
        self.setBitMasksToMothershipSpaceship()
        physicsBody.isDynamic = false
        
        self.maxVelocitySquared = GameMath.spaceshipMaxVelocitySquared(level: self.level, speedAtribute: self.speedAtribute)
        self.force = maxVelocitySquared / 120
    }
    
    func setBitMasksToMothershipSpaceship() {
        if let physicsBody = self.physicsBody {
            physicsBody.categoryBitMask = GameWorld.categoryBitMask.mothershipSpaceship.rawValue
            physicsBody.collisionBitMask = GameWorld.collisionBitMask.mothershipSpaceship.rawValue
            physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.mothershipSpaceship.rawValue
        }
    }
    
    func setBitMasksToSpaceship() {
        if let physicsBody = self.physicsBody {
            physicsBody.categoryBitMask = GameWorld.categoryBitMask.spaceship.rawValue
            physicsBody.collisionBitMask = GameWorld.collisionBitMask.spaceship.rawValue
            physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.spaceship.rawValue
        }
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
