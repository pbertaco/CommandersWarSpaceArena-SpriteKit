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
    
    static var diameter: CGFloat = 55
    var weaponRange: CGFloat = 461
    
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
    
    var baseLife = 1
    var baseDamage = 1
    var baseSpeed = 1
    var baseRange = 1
    
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
    var targetNode: SKNode?
    
    var team: Mothership.team
    
    var rotationToDestination: CGFloat = 0
    var totalRotationToDestination: CGFloat = 0
    
    var maxAngularVelocity: CGFloat = 3
    var angularImpulse: CGFloat = 0.0005
    var maxVelocitySquared: CGFloat = 0
    var force: CGFloat = 0
    
    var weaponRangeShapeNode: SKShapeNode?
    var healthBar: SpaceshipHealthBar?
    
    var lastShot: Double = 0
    var canShot = true
    
    var canRespawn = true
    var deathTime = 0.0
    var lastSecond = 0.0
    var labelRespawn: Label?
    
    var battlePoints = 0
    var kills = 0
    var assists = 0
    var deaths = 0
    var getHitBySpaceships = Set<Spaceship>()
    
    init(spaceshipData: SpaceshipData, loadPhysics: Bool = false, team: Mothership.team = .blue) {
        
        self.team = team
        
        super.init(texture: nil, color: .clear, size: CGSize.zero)
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
                  baseRange: Int(spaceshipData.baseRange),
                  skinIndex: Int(spaceshipData.skin), color: color,
                  loadPhysics: loadPhysics,
                  team: team)
    }
    
    init(level: Int, rarity: rarity, loadPhysics: Bool = false, team: Mothership.team = .blue) {
        
        self.team = team
        
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        
        self.rarity = rarity
        
        self.load(level: level,
                  baseDamage: GameMath.randomBaseDamage(rarity: self.rarity),
                  baseLife: GameMath.randomBaseLife(rarity: self.rarity),
                  baseSpeed: GameMath.randomBaseSpeed(rarity: self.rarity),
                  baseRange: GameMath.randomBaseRange(rarity: self.rarity),
                  skinIndex: Int.random(Spaceship.skins.count),
                  color: Spaceship.randomColor(),
                  loadPhysics: loadPhysics,
                  team: team)
    }
    
    private init(spaceship: Spaceship, loadPhysics: Bool = false, team: Mothership.team = .blue) {
        self.team = team
        
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        
        self.rarity = spaceship.rarity
        
        self.load(level: spaceship.level,
                  baseDamage: spaceship.baseDamage,
                  baseLife: spaceship.baseLife,
                  baseSpeed: spaceship.baseSpeed,
                  baseRange: spaceship.baseRange,
                  skinIndex: spaceship.skinIndex,
                  color: spaceship.color,
                  loadPhysics: loadPhysics,
                  team: team)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCopy(loadPhysics: Bool = false, team: Mothership.team = .blue) -> Spaceship {
        let spaceship = Spaceship(spaceship: self, loadPhysics: loadPhysics, team: team)
        spaceship.spaceshipData = self.spaceshipData
        return spaceship
    }
    
    // swiftlint:disable:next function_parameter_count
    func load(level: Int, baseDamage: Int, baseLife: Int, baseSpeed: Int, baseRange: Int,
              skinIndex: Int, color: SKColor, loadPhysics: Bool = false, team: Mothership.team) {
        
        self.level = level
        
        self.skinIndex = skinIndex
        
        let texture = Spaceship.skinTexture(index: skinIndex)
        self.texture = texture
        self.size = texture.size()
        self.setScaleToFit(width: Spaceship.diameter, height: Spaceship.diameter)
        
        self.color = color
        self.colorBlendFactor = 1
        self.blendMode = .add
        
        self.baseLife = baseLife
        self.baseDamage = baseDamage
        self.baseSpeed = baseSpeed
        self.baseRange = baseRange
        
        self.updateAttributes()
        
        self.health = self.maxHealth
        
        if loadPhysics {
            self.loadPhysics()
        }
    }
    
    func updateAttributes() {
        self.maxHealth = GameMath.maxHealth(level: level, baseLife: self.baseLife)
        self.damage = GameMath.damage(level: level, baseDamage: self.baseDamage)
        self.speedAtribute = GameMath.speed(level: level, baseSpeed: self.baseSpeed)
        self.weaponRange = CGFloat(GameMath.range(level: level, baseRange: self.baseRange))
    }
    
    func getHitBy(_ shot: Shot) {
        
        if shot.shooter?.team == self.team || shot.damage <= 0 {
            return
        }
        
        let dx = Float(shot.position.x - self.position.x)
        let dy = Float(shot.position.y - self.position.y)
        
        let rotationToShot = -atan2f(dx, dy)
        var totalRotationToShot = rotationToShot - Float(self.zRotation)
        while totalRotationToShot < Float(-π) { totalRotationToShot += Float(π * 2) }
        while totalRotationToShot > Float(π) { totalRotationToShot -= Float(π * 2) }
        
        let damageMultiplier = max(abs(totalRotationToShot), 1)
        
        shot.damage = Int(Float(shot.damage) * damageMultiplier)
        
        if let shooter = shot.shooter {
            if shooter.team != self.team {
                self.getHitBySpaceships.insert(shooter)
                shooter.battlePoints = shooter.battlePoints + shot.damage
            }
        }
        
        self.damageEffect(damage: shot.damage, damageMultiplier: CGFloat(damageMultiplier))
        
        if self.health > 0 && self.health - shot.damage <= 0 {
            self.die(shooter: shot.shooter)
        } else {
            self.health = self.health - shot.damage
        }
        self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        
        shot.damage = 0
        shot.removeFromParent()
    }
    
    func die(shooter: Spaceship?) {
        
        if let shooter = shooter {
            shooter.kills = shooter.kills + 1
            self.getHitBySpaceships.remove(shooter)
        }
        
        for shooter in self.getHitBySpaceships {
            shooter.assists = shooter.assists + 1
        }
        
        self.getHitBySpaceships.removeAll()
        
        self.health = 0
        self.explosionEffect()
        
        self.retreat()
        self.resetToStartingPosition()
        
        let physicsBody = self.physicsBody
        self.physicsBody = nil
        
        self.position = self.startingPosition
        
        if let physicsBody = physicsBody {
            self.physicsBody = physicsBody
        }
        
        self.isHidden = true
        
        self.deaths = self.deaths + 1
        self.deathTime = GameScene.currentTime
        self.lastSecond = GameScene.currentTime
        
        if self.canRespawn {
            self.labelRespawn?.text = (self.deaths * 5).description
        }
        
        self.setBitMasksToDeadSpaceship()
    }
    
    func heal() {
        if self.health < self.maxHealth {
            self.health = self.health + (self.maxHealth/60)
            if self.health > self.maxHealth {
                self.health = self.maxHealth
            }
            if self.health == self.maxHealth {
                self.getHitBySpaceships.removeAll()
            }
            self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        }
    }
    
    func respawn() {
        self.isHidden = false
        self.health = self.maxHealth
        self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        self.labelRespawn?.text = ""
        self.setBitMasksToMothershipSpaceship()
    }
    
    func damageEffect(damage: Int, damageMultiplier: CGFloat) {
        
        let duration = 0.5
        
        let label = Label(text: damage.description, fontSize: .fontSize8, fontColor: SKColor(red: 1, green: 1 - damageMultiplier/π, blue: 1 - damageMultiplier/π, alpha: 1))
        Control.set.remove(label)
        label.position = CGPoint(
            x: Int(self.position.x) + Int.random(min: -27, max: 27),
            y: Int(self.position.y) + Int.random(min: -27, max: 27))
        self.parent?.addChild(label)
        
        label.run(SKAction.scale(to: 2, duration: 0))
        label.run(SKAction.scale(to: 1, duration: duration))
        
        label.run(SKAction.sequence([
            SKAction.wait(forDuration: duration/2),
            SKAction.fadeAlpha(to: 0, duration: duration/2),
            SKAction.removeFromParent()
            ]
        ))
    }
    
    func explosionEffect() {
        guard let targetNode = self.parent else { return }
        
        let emitterNode = SKEmitterNode()
        let texture = SKTexture(imageNamed: "spark")
        emitterNode.particleTexture = texture
        emitterNode.particleSize = CGSize(width: 21, height: 21)
        emitterNode.numParticlesToEmit = 100
        emitterNode.particleBirthRate = 12000
        emitterNode.particleLifetime = 1
        emitterNode.particleAlpha = 1
        emitterNode.particleAlphaSpeed = -1
        emitterNode.particleScaleSpeed = -1
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColor = GameColors.explosion
        emitterNode.particleBlendMode = .add
        
        emitterNode.particleZPosition = GameWorld.zPosition.explosion.rawValue
        
        emitterNode.particleSpeed = 500
        emitterNode.particleSpeedRange = 1000
        emitterNode.emissionAngleRange = π * 2.0
        
        emitterNode.targetNode = targetNode
        emitterNode.position = self.position
        targetNode.addChild(emitterNode)
        
        emitterNode.run(SKAction.removeFromParentAfterDelay(1))
        GameWorld.current()?.shake()
    }
    
    func update(enemyMothership: Mothership? = nil, enemySpaceships: [Spaceship] = [], allySpaceships: [Spaceship] = []) {
        if self.health > 0 {
            if let destination = self.destination {
                if self.position.distanceTo(destination) <= Spaceship.diameter/2 {
                    if self.destination == self.startingPosition {
                        self.resetToStartingPosition()
                    }
                    self.destination = nil
                } else {
                    if self.destination == self.startingPosition {
                        self.rotateTo(point: destination)
                        self.applyForce()
                    } else {
                        self.rotateTo(point: destination)
                        self.applyForce()
                    }
                }
            } else {
                if let physicsBody = self.physicsBody {
                    if physicsBody.categoryBitMask == GameWorld.categoryBitMask.mothershipSpaceship.rawValue {
                        if (self.position - self.startingPosition).lengthSquared() < 4 {
                            self.heal()
                        }
                        self.rotateTo(point: CGPoint(x: self.position.x, y: 0))
                        self.applyForce()
                    } else {
                        
                        if let targetNode = self.targetNode {
                            
                            if let targetSpaceship = targetNode as? Spaceship {
                                if targetSpaceship.health <= 0 {
                                    self.targetNode = nil
                                } else {
                                    if (targetSpaceship.position - targetSpaceship.startingPosition).lengthSquared() < 4 {
                                        self.targetNode = nil
                                    } else {
                                        self.rotateTo(point: targetSpaceship.position)
                                        
                                        if self.position.distanceTo(targetSpaceship.position) > self.weaponRange + Spaceship.diameter/2 {
                                            self.applyForce()
                                        } else {
                                            self.tryToShoot()
                                        }
                                    }
                                }
                            }
                            
                            if let targetMothership = targetNode as? Mothership {
                                if targetMothership.health <= 0 {
                                    self.targetNode = nil
                                } else {
                                    
                                    let point = CGPoint(x: self.position.x, y: targetMothership.position.y)
                                    self.rotateTo(point: point)
                                    
                                    if self.position.distanceTo(point) > self.weaponRange + 89/2 {
                                        self.applyForce()
                                    } else {
                                        self.tryToShoot()
                                    }
                                }
                            }
                        } else {
                            if let targetNode = self.nearestSpaceshipInRange(spaceships: enemySpaceships) {
                                self.targetNode = targetNode
                            } else {
                                if let enemyMothership = enemyMothership {
                                    if self.isMothershipInRange(mothership: enemyMothership) {
                                        self.targetNode = enemyMothership
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if self.canRespawn {
                if GameScene.currentTime - self.lastSecond > 1 {
                    self.lastSecond = GameScene.currentTime
                    
                    if GameScene.currentTime - self.deathTime > Double(self.deaths * 5) {
                        self.respawn()
                    } else {
                        if let label = self.labelRespawn {
                            let text = Int((self.deaths * 5) - Int(GameScene.currentTime - self.deathTime)).description
                            label.text = text
                        }
                    }
                }
            }
        }
        
        self.updateWeaponRangeShapeNode()
        self.updateHealthBarPosition()
    }
    
    func tryToShoot() {
        if GameScene.currentTime - self.lastShot > 0.2 {
            if self.canShot {
                self.canShot = false
                self.lastShot = GameScene.currentTime
                self.parent?.addChild(Shot(shooter: self))
            }
        }
    }
    
    func nearestSpaceshipInRange(spaceships: [Spaceship]) -> Spaceship? {
        
        var nearestSpaceship: Spaceship? = nil
        
        for spaceship in spaceships {
            if spaceship.health > 0 {
                if (spaceship.position - spaceship.startingPosition).lengthSquared() > 4 {
                    if self.position.distanceTo(spaceship.position) < self.weaponRange + Spaceship.diameter/2 {
                        
                        if nearestSpaceship != nil {
                            if (self.position - spaceship.position).lengthSquared() < (self.position - nearestSpaceship!.position).lengthSquared() {
                                nearestSpaceship = spaceship
                            }
                        } else {
                            nearestSpaceship = spaceship
                        }
                    }
                }
            }
        }
        
        return nearestSpaceship
    }
    
    func isMothershipInRange(mothership: Mothership) -> Bool {
        let point = CGPoint(x: self.position.x, y: mothership.position.y)
        return self.position.distanceTo(point) < self.weaponRange + 89/2
    }
    
    func resetToStartingPosition() {
        self.physicsBody?.isDynamic = false
        self.position = self.startingPosition
        self.zRotation = self.startingZPosition
        self.physicsBody?.velocity = CGVector.zero
        self.physicsBody?.angularVelocity = 0
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
    
    func applyForce() {
        
        let multiplier = max(1 - abs(self.totalRotationToDestination * 2), 0)
        
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
            
            self.targetNode = nil
            
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
        self.destination = nil
        self.physicsBody?.isDynamic = true
        self.targetNode = spaceship
    }
    
    func setTarget(mothership: Mothership) {
        self.destination = nil
        self.physicsBody?.isDynamic = true
        self.targetNode = mothership
    }
    
    static func setSelected(spaceship: Spaceship?) {
        Spaceship.selectedSpaceship = spaceship
        spaceship?.showWeaponRangeShapeNode()
    }
    
    func retreat() {
        self.targetNode = nil
        self.physicsBody?.isDynamic = true
        self.destination = self.startingPosition
        self.setBitMasksToMothershipSpaceship()
        if self == Spaceship.selectedSpaceship {
            Spaceship.setSelected(spaceship: nil)
        }
    }
    
    func loadWeaponRangeShapeNode(gameWorld: GameWorld) {
        let shapeNode = SKShapeNode(circleOfRadius: self.weaponRange)
        shapeNode.zPosition = GameWorld.zPosition.spaceshipWeaponRangeShapeNode.rawValue
        shapeNode.strokeColor = SKColor.white
        shapeNode.fillColor = .clear
        shapeNode.alpha = 0
        shapeNode.position = self.position
        gameWorld.addChild(shapeNode)
        
        self.weaponRangeShapeNode = shapeNode
    }
    
    func loadHealthBar(gameWorld: GameWorld) {
        let healthBar = SpaceshipHealthBar(level: self.level, health: self.health, team: self.team, rarity: self.rarity)
        
        gameWorld.addChild(healthBar)
        
        self.healthBar = healthBar
    }
    
    func updateHealthBarPosition() {
        if let healthBar = self.healthBar {
            healthBar.position = self.position + healthBar.positionOffset
        }
    }
    
    func updateHealthBar(health: Int, maxHealth: Int) {
        if let healthBar = self.healthBar {
            healthBar.update(health: health, maxHealth: maxHealth)
        }
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
    
    func loadLabelRespawn(gameWorld: GameWorld) {
        let labelRespawn = Label(text: "", fontSize: .fontSize16, fontColor: GameColors.fontWhite)
        Control.set.remove(labelRespawn)
        labelRespawn.position = self.startingPosition
        gameWorld.addChild(labelRespawn)
        
        self.labelRespawn = labelRespawn
    }
    
    func didBeginContact(with bodyB: SKPhysicsBody) {
        if let bodyA = self.physicsBody {
            switch GameWorld.categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            
            case [.spaceship, .shot]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
                break
                
            case [.spaceship, .spaceshipShot]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
                break
                
            case [.mothershipSpaceship, .shot]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
                break
                
            case [.mothershipSpaceship, .spaceshipShot]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
                break
                
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
                
            case [.spaceship, .shot]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
                break
                
            case [.mothershipSpaceship, .shot]:
                if let shot = bodyB.node as? Shot {
                    self.getHitBy(shot)
                }
                break
                
            case [.spaceship, .spaceshipShot]:
                if let shot = bodyB.node as? Shot {
                    shot.setBitMasksToShot()
                }
                break
                
            case [.mothershipSpaceship, .spaceshipShot]:
                if let shot = bodyB.node as? Shot {
                    shot.setBitMasksToShot()
                }
                break
                
            case [.mothershipSpaceship, .mothership]:
                if (self.destination ?? CGPoint.zero) != self.startingPosition {
                    self.setBitMasksToSpaceship()
                }
                break
                
            case [.mothershipSpaceship, .deadMothership]:
                if (self.destination ?? CGPoint.zero) != self.startingPosition {
                    self.setBitMasksToSpaceship()
                }
                break
                
            case [.deadSpaceship, .spaceshipShot]:
                if let shot = bodyB.node as? Shot {
                    shot.setBitMasksToShot()
                }
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
        
        self.zPosition = GameWorld.zPosition.spaceship.rawValue
        
        let physicsBody = SKPhysicsBody(circleOfRadius: Spaceship.diameter/2)
        
        physicsBody.mass = 0.0455111116170883
        physicsBody.linearDamping = 2
        physicsBody.angularDamping = 5
        
        self.physicsBody = physicsBody
        
        self.setBitMasksToMothershipSpaceship()
        physicsBody.isDynamic = false
        
        self.maxVelocitySquared = GameMath.spaceshipMaxVelocitySquared(level: self.level, speedAtribute: self.speedAtribute)
        self.force = maxVelocitySquared / 240
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
    
    func setBitMasksToDeadSpaceship() {
        if let physicsBody = self.physicsBody {
            physicsBody.categoryBitMask = GameWorld.categoryBitMask.deadSpaceship.rawValue
            physicsBody.collisionBitMask = GameWorld.categoryBitMask.deadSpaceship.rawValue
            physicsBody.contactTestBitMask = GameWorld.categoryBitMask.deadSpaceship.rawValue
        }
    }
    
    static func skinTexture(index i: Int) -> SKTexture {
        let texture = SKTexture(imageNamed: Spaceship.skins[i], filteringMode: GameScene.defaultFilteringMode)
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
    
    static func randomRarity() -> rarity? {
        
        switch Int.random(100) {
        case 0..<5: // 5%
            return .legendary
        case 5..<15: // 10%
            return .epic
        case 15..<35: // 20%
            return .rare
        case 35..<75: // 40%
            return .common
        default:
            return nil
        }
    }
}
