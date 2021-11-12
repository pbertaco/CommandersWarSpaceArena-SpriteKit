//
//  Spaceship.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode {
    
    enum rarity: Int {
        case common, uncommon, rare, heroic, epic, legendary, supreme, boss
    }
    
    var element: Element!
    
    static weak var selectedSpaceship: Spaceship?
    
    static var diameter: CGFloat = 55
    var weaponRange: CGFloat = 461
    
    static var skins: [String] = [
        "spaceship00",
        "spaceship01",
        "spaceship02",
        "spaceship03",
        "spaceship04",
        "spaceship05",
        "spaceship06",
        "spaceship07",
        "spaceship08",
        "spaceship09",
        "spaceship10",
        "spaceship11",
        "spaceship12",
        "spaceship13",
        "spaceship14",
        "spaceship15",
        "spaceship16"
    ]
    
    private(set) var spaceshipData: SpaceshipData?
    
    var level: Int!
    
    var baseLife = 1
    var baseDamage = 1
    var baseSpeed = 1
    var baseRange = 1
    var fearLevel: CGFloat = 0.0
    
    var damage: Int = 1
    var maxHealth: Int = 1
    var speedAtribute: Int = 1
    
    var health: Int = 1
    
    var rarity: rarity = .common
    
    var skinIndex: Int = 0
    
    var startingPosition = CGPoint.zero
    var startingZPosition: CGFloat = 0
    var destination: CGPoint?
    weak var targetNode: SKNode?
    
    var team: Mothership.team
    
    var totalRotationToDestination: CGFloat = 0
    
    var maxAngularVelocity: CGFloat = 3
    var angularImpulse: CGFloat = 0.0005
    var maxVelocitySquared: CGFloat = 0
    var force: CGFloat = 0
    
    weak var weaponRangeShapeNode: SKShapeNode?
    weak var healthBar: SpaceshipHealthBar?
    
    var lastShot: Double = 0
    var canShoot = true
    
    var canRespawn = true
    var deathTime = 0.0
    var lastSecond = 0.0
    weak var labelRespawn: Label?
    
    var battlePoints = 0
    var battleStartLevel: Int!
    var kills = 0
    var assists = 0
    var deaths = 0
    var getHitBySpaceships = Set<Spaceship>()
    
    var emitterNode: SKEmitterNode?
    var emitterNodeParticleBirthRate: CGFloat = 0
    var defaultEmitterNodeParticleBirthRate: CGFloat = 0
    var emitterNodeMaskNode: SKSpriteNode?
    
    var destinationEffectSpriteNode: SKSpriteNode?
    
    var retreating = false
    var lastHeal: Double = 0
    
    var loaded = false
    
    init(spaceshipData: SpaceshipData, loadPhysics: Bool = false, team: Mothership.team = .blue) {
        
        self.team = team
        
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        self.spaceshipData = spaceshipData
        
        let color = SKColor(
            red: CGFloat(spaceshipData.colorRed),
            green: CGFloat(spaceshipData.colorGreen),
            blue: CGFloat(spaceshipData.colorBlue), alpha: 1)
        
        self.rarity = Spaceship.rarity(rawValue: Int(spaceshipData.rarity))!
        
        self.load(level: Int(spaceshipData.level),
                  baseDamage: Int(spaceshipData.baseDamage),
                  baseLife: Int(spaceshipData.baseLife),
                  baseSpeed: Int(spaceshipData.baseSpeed),
                  baseRange: Int(spaceshipData.baseRange),
                  fearLevel: CGFloat(spaceshipData.fearLevel),
                  skinIndex: Int(spaceshipData.skin),
                  color: color,
                  loadPhysics: loadPhysics,
                  team: team)
    }
    
    init(level: Int, rarity: rarity, loadPhysics: Bool = false, team: Mothership.team = .blue, color: SKColor? = nil) {
        
        self.team = team
        
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        
        self.rarity = rarity
        
        self.load(level: level,
                  baseDamage: GameMath.randomBaseDamage(rarity: self.rarity),
                  baseLife: GameMath.randomBaseLife(rarity: self.rarity),
                  baseSpeed: GameMath.randomBaseSpeed(rarity: self.rarity),
                  baseRange: GameMath.randomBaseRange(rarity: self.rarity),
                  fearLevel: GameMath.randomFear(),
                  skinIndex: Int.random(Spaceship.skins.count),
                  color: color ?? Spaceship.randomColor(),
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
                  fearLevel: spaceship.fearLevel,
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
    func load(level: Int, baseDamage: Int, baseLife: Int, baseSpeed: Int, baseRange: Int, fearLevel: CGFloat,
              skinIndex: Int, color: SKColor, loadPhysics: Bool = false, team: Mothership.team) {
        
        self.level = level
        self.battleStartLevel = level
        
        self.skinIndex = skinIndex
        
        let texture = Spaceship.skinTexture(index: skinIndex)
        self.texture = texture
        self.size = texture.size()
        self.setScaleToFit(width: Spaceship.diameter, height: Spaceship.diameter)
        
        self.element = Spaceship.elementFor(color: color)
        
        self.color = color
        self.colorBlendFactor = 1
        self.blendMode = .add
        
        self.baseLife = baseLife
        self.baseDamage = baseDamage
        self.baseSpeed = baseSpeed
        self.baseRange = baseRange
        self.fearLevel = fearLevel
        
        self.updateAttributes()
        
        self.health = self.maxHealth
        
        
        
        if loadPhysics {
            self.loadPhysics()
        }
    }
    
    func updateAttributes() {
        self.maxHealth = GameMath.maxHealth(level: self.level, baseLife: self.baseLife)
        self.damage = GameMath.damage(level: self.level, baseDamage: self.baseDamage)
        self.speedAtribute = GameMath.speed(level: self.level, baseSpeed: self.baseSpeed)
        self.weaponRange = CGFloat(GameMath.range(level: self.level, baseRange: self.baseRange))
    }
    
    func getHitBy(_ shot: Shot) {
        
        if shot.shooter == self || shot.damage <= 0 {
            return
        }
        
        if self.team != .none {
            if shot.shooter?.team == self.team {
                return
            }
        }
        
        let totalRotationToShot = self.totalRotation(to: shot.position)
        
        var damageMultiplier = max(abs(totalRotationToShot), 1)
        
        if self.element.weakness == shot.element.element {
            damageMultiplier = damageMultiplier * Float(π / 2)
        }
        
        if self.element.strength == shot.element.element {
            damageMultiplier = damageMultiplier / Float(π / 2)
        }
        
        
        if let shooter = shot.shooter {
            if shooter.team != self.team {
                self.getHitBySpaceships.insert(shooter)
                shooter.battlePoints += shot.damage
            }
        }
        
        shot.damage = Int(Float(shot.damage) * damageMultiplier)
        
        self.damageEffect(damage: shot.damage, damageMultiplier: CGFloat(damageMultiplier), position: shot.position)
        
        if self.health > 0 && self.health - shot.damage <= 0 {
            if shot.damage > self.maxHealth {
                self.canRespawn = false
            }
            self.die(shooter: shot.shooter)
        } else {
            self.health -= shot.damage
            
//            if CGFloat(self.health) / CGFloat(self.maxHealth) < self.fearLevel {
//                self.retreat()
//            } else {
                if self.targetNode is Mothership {
                    if let shooter = shot.shooter {
                        self.setTarget(spaceship: shooter)
                    }
                }
//            }
        }
        self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        shot.damage = 0
        shot.removeFromParent()
    }
    
    func die(shooter: Spaceship?) {
        
        self.emitterNodeParticleBirthRate = 0
        
        if let shooter = shooter {
            shooter.kills += 1
            shooter.healthBar?.labelLevel.set(color: GameColors.controlYellow)
            self.getHitBySpaceships.remove(shooter)
        }
        
        for shooter in self.getHitBySpaceships {
            shooter.assists += 1
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
        
        self.deaths += 1
        self.deathTime = GameScene.currentTime
        self.lastSecond = GameScene.currentTime
        
        if self.canRespawn {
            self.labelRespawn?.text = (self.deaths * (self.rarity.rawValue + 1)).description
        }
        
        self.setBitMasksToDeadSpaceship()
        self.fadeSetDestinationEffect()
    }
    
    func heal() {
        if self.level < self.battleStartLevel + self.kills {
            self.upgradeOnBattle()
        }
        if self.health < self.maxHealth {
            self.lastHeal = GameScene.currentTime
            self.health += max((self.maxHealth/180), 1)
            if self.health > self.maxHealth {
                self.health = self.maxHealth
            }
            if self.health == self.maxHealth {
                self.getHitBySpaceships.removeAll()
            }
            self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        } else {
            if GameScene.currentTime - self.lastHeal > 3 {
                if !self.retreating {
                    self.physicsBody?.isDynamic = true
                }
            }
        }
    }
    
    func respawn() {
        self.isHidden = false
        self.health = 1
        self.updateHealthBar(health: self.health, maxHealth: self.maxHealth)
        self.labelRespawn?.text = ""
        self.setBitMasksToMothershipSpaceship()
    }
    
    func damageEffect(damage: Int, damageMultiplier: CGFloat, position: CGPoint) {
        
        let duration = 0.5
        
        let label = Label(text: damage.description, fontName: .kenPixel, fontSize: .fontSize8, fontColor: SKColor(red: 1, green: 1 - damageMultiplier/π, blue: 1 - damageMultiplier/π, alpha: 1))
        label.zPosition = GameWorld.zPosition.damageEffect.rawValue
        label.position = position
        Control.set.remove(label)
        //        label.position = CGPoint(
        //            x: Int(self.position.x) + Int.random(min: -27, max: 27),
        //            y: Int(self.position.y) + Int.random(min: -27, max: 27))
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
    
    func loadJetEffect(gameWorld targetNode: GameWorld) {
        
        self.defaultEmitterNodeParticleBirthRate  = CGFloat(self.speedAtribute * 20)
        
        let emitterNode = SKEmitterNode()
        let texture = SKTexture(imageNamed: "spark")
        emitterNode.particleTexture = texture
        emitterNode.particleSize = CGSize(width: 8, height: 8)
        emitterNode.particleLifetime = 1
        emitterNode.particleAlpha = 1
        emitterNode.particleAlphaSpeed = -4
        emitterNode.particleScaleSpeed = -1
        emitterNode.particleColorBlendFactor = 1
        
        switch self.team {
        case .blue:
            emitterNode.particleColor = GameColors.blueTeam
            break
        case .red, .none:
            emitterNode.particleColor = GameColors.redTeam
            break
        }
        
        emitterNode.particleBlendMode = .add
        emitterNode.particleZPosition = -1
        
        emitterNode.particlePositionRange = CGVector(dx: 8, dy: 8)
        
        let effectNode = SKEffectNode()
        effectNode.blendMode = .add
        effectNode.zPosition = self.zPosition - 1
        
        let maskTexture = Spaceship.skinMaskTexture(index: self.skinIndex)
        let maskNode = SKSpriteNode(texture: maskTexture, size: maskTexture.size())
        maskNode.setScaleToFit(width: Spaceship.diameter, height: Spaceship.diameter)
        
        maskNode.color = .white
        maskNode.colorBlendFactor = 1
        maskNode.blendMode = .subtract
        
        effectNode.addChild(emitterNode)
        effectNode.addChild(maskNode)
        targetNode.addChild(effectNode)
        
        self.emitterNode = emitterNode
        self.emitterNodeMaskNode = maskNode
    }
    
    func updateJetEffect() {
        if let emitterNode = self.emitterNode {
            emitterNode.particleBirthRate = self.emitterNodeParticleBirthRate/4
            emitterNode.particleSpeed = self.emitterNodeParticleBirthRate
            emitterNode.particleSpeedRange = self.emitterNodeParticleBirthRate/2
            emitterNode.parent?.position = self.position
            emitterNode.emissionAngle = self.zRotation - π/2
            
            if let emitterNodeMaskNode = self.emitterNodeMaskNode {
                emitterNodeMaskNode.zRotation = self.zRotation
            }
        }
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
        GameWorld.current()?.explosionSoundEffect?.play()
        GameWorld.current()?.shake()
    }
    
    func update(enemyMothership: Mothership? = nil, enemySpaceships: [Spaceship] = [], allySpaceships: [Spaceship] = []) {
        
        self.emitterNodeParticleBirthRate = 0
        
        if self.health > 0 {
            if let destination = self.destination {
                if self.position.distanceTo(destination) <= Spaceship.diameter/2 {
                    if self.destination == self.startingPosition {
                        self.resetToStartingPosition()
                    } else {
                        self.updateBitMasks()
                    }
                    self.destination = nil
                    self.fadeSetDestinationEffect()
                } else {
                    self.rotateTo(point: destination)
                    self.applyForce()
                }
            } else {
                if let physicsBody = self.physicsBody {
                    if physicsBody.categoryBitMask == GameWorld.categoryBitMask.mothershipSpaceship.rawValue {
                        if (self.position - self.startingPosition).lengthSquared() < 4 {
                            self.heal()
                        }
                        if physicsBody.isDynamic {
                            self.rotateTo(point: CGPoint(x: self.position.x, y: 0))
                            self.applyForce()
                        }
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
                                self.setTarget(spaceship: targetNode)
                            } else {
                                if let enemyMothership = enemyMothership {
                                    if self.isMothershipInRange(mothership: enemyMothership) {
                                        self.setTarget(mothership: enemyMothership)
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
                    
                    if GameScene.currentTime - self.deathTime > Double(self.deaths * (self.rarity.rawValue + 1)) {
                        self.respawn()
                    } else {
                        if let label = self.labelRespawn {
                            let text = Int((self.deaths * (self.rarity.rawValue + 1)) - Int(GameScene.currentTime - self.deathTime)).description
                            label.text = text
                        }
                    }
                }
            }
        }
        
        self.updateWeaponRangeShapeNode()
        self.updateHealthBarPosition()
    }
    
    func didSimulatePhysics() {
        self.updateJetEffect()
    }
    
    func totalRotation(to point: CGPoint) -> Float {
        
        let dx = Float(point.x - self.position.x)
        let dy = Float(point.y - self.position.y)
        
        let rotationToPoint = -atan2f(dx, dy)
        var totalRotationToPoint = rotationToPoint - Float(self.zRotation)
        while totalRotationToPoint < Float(-π) { totalRotationToPoint += Float(π * 2) }
        while totalRotationToPoint > Float(π) { totalRotationToPoint -= Float(π * 2) }
        
        return totalRotationToPoint
    }
    
    func canTryToShoot() -> Bool {
        guard let targetSpaceship = self.targetNode else { return true }
        let maxAngle = asin((Spaceship.diameter / 2) / self.position.distanceTo(targetSpaceship.position)) / 2
        return abs(self.totalRotationToDestination) <= maxAngle
    }
    
    func tryToShoot() {
        if GameScene.currentTime - self.lastShot > 0.2 {
            if self.canShoot {
                guard self.canTryToShoot() else { return }
                self.canShoot = false
                self.lastShot = GameScene.currentTime
                self.parent?.addChild(Shot(shooter: self, element: self.element))
                GameWorld.current()?.shotSoundEffect?.play()
            }
        }
    }
    
    func upgradeOnBattle() {
        self.setBattleLevel(self.level + 1)
        self.healthBar?.labelLevel.set(color: GameColors.fontBlack)
    }
    
    func setBattleLevel(_ level: Int) {
        if level < self.level {
            self.health = self.maxHealth
        }
        
        self.maxHealth = GameMath.maxHealth(level: level, baseLife: self.baseLife)
        self.damage = GameMath.damage(level: level, baseDamage: self.baseDamage)
        
        self.speedAtribute = GameMath.speed(level: min(level, 10), baseSpeed: self.baseSpeed)
        self.maxVelocitySquared = GameMath.spaceshipMaxVelocitySquared(level: self.level, speedAtribute: self.speedAtribute)
        self.force = maxVelocitySquared / 240
        self.defaultEmitterNodeParticleBirthRate  = CGFloat(self.speedAtribute * 20)
        
        self.level = level
        self.healthBar?.update(health: self.health, maxHealth: self.maxHealth)
        self.healthBar?.labelLevel.text = level.description
    }
    
    func nearestSpaceshipInRange(spaceships: [Spaceship]) -> Spaceship? {
        
        var nearestSpaceship: Spaceship? = nil
        
        for spaceship in spaceships {
            
            if spaceship == self { continue }
            
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
            if abs(physicsBody.angularVelocity) < self.maxAngularVelocity {
                self.totalRotationToDestination = CGFloat(self.totalRotation(to: point))
                physicsBody.applyAngularImpulse(self.totalRotationToDestination * self.angularImpulse)
            }
        }
    }
    
    func applyForce() {
        let absTotalRotationToDestination = abs(self.totalRotationToDestination * 2)
        let multiplier = max(1 - absTotalRotationToDestination, 0)
        
        if multiplier > 0 {
            if let physicsBody = self.physicsBody {
                let velocitySquared = (physicsBody.velocity.dx * physicsBody.velocity.dx) + (physicsBody.velocity.dy * physicsBody.velocity.dy)
                
                if velocitySquared < self.maxVelocitySquared {
                    physicsBody.applyForce(CGVector(dx: -sin(self.zRotation) * self.force * multiplier, dy: cos(self.zRotation) * self.force * multiplier))
                }
                self.emitterNodeParticleBirthRate = self.defaultEmitterNodeParticleBirthRate
            }
        }
    }
    
    func updateBitMasks() {
        if let physicsBody = self.physicsBody {
            if physicsBody.categoryBitMask == GameWorld.categoryBitMask.mothershipSpaceship.rawValue {
                if physicsBody.allContactedBodies().filter({ (physicsBody: SKPhysicsBody) -> Bool in
                    return physicsBody.categoryBitMask == GameWorld.categoryBitMask.mothership.rawValue
                }).count <= 0 {
                    self.setBitMasksToSpaceship()
                }
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
                    self.destination = nil
                    self.updateBitMasks()
                    self.fadeSetDestinationEffect()
                }
                
            } else {
                self.physicsBody?.isDynamic = true
                self.destination = point
                self.setDestinationEffect()
            }
        } else {
            if self.contains(point) {
                Spaceship.setSelected(spaceship: self)
            }
        }
    }
    
    func setTarget(spaceship: Spaceship) {
        self.fadeSetDestinationEffect()
        self.physicsBody?.isDynamic = true
        self.destination = nil
        self.targetNode = spaceship
        self.setTargetEffect(position: spaceship.position, move: true)
    }
    
    func setTarget(mothership: Mothership) {
        self.fadeSetDestinationEffect()
        self.physicsBody?.isDynamic = true
        self.destination = nil
        self.targetNode = mothership
        self.setTargetEffect(position: CGPoint(x: self.position.x, y: mothership.position.y), move: false)
    }
    
    func loadSetDestinationEffect(gameWorld: GameWorld) {
        guard self.team == .blue else { return }
        let spriteNode = SKSpriteNode(imageNamed: "Define Location", filteringMode: GameScene.defaultFilteringMode)
        spriteNode.zPosition = GameWorld.zPosition.targetEffect.rawValue
        spriteNode.setScale(0.75)
        spriteNode.set(color: self.color, blendMode: .add)
        spriteNode.alpha = 0
        
        gameWorld.addChild(spriteNode)
        self.destinationEffectSpriteNode = spriteNode
    }
    
    func setDestinationEffect() {
        guard self.team == .blue else { return }
        guard let destination = self.destination else { return }
        guard let spriteNode = self.destinationEffectSpriteNode else { return }
        
        spriteNode.removeAllActions()
        spriteNode.alpha = 1
        spriteNode.position = destination
    }
    
    func fadeSetDestinationEffect() {
        guard self.team == .blue else { return }
        guard let spriteNode = self.destinationEffectSpriteNode else { return }
        
        let duration = 0.5
        
        spriteNode.run(SKAction.fadeAlpha(to: 0, duration: duration))
    }
    
    func setTargetEffect(position: CGPoint, move: Bool) {
        guard self.team == .blue else { return }
        guard let targetNode = self.targetNode else { return }
        
        let spriteNode = SKSpriteNode(imageNamed: "Define Location", filteringMode: GameScene.defaultFilteringMode)
        spriteNode.zPosition = GameWorld.zPosition.targetEffect.rawValue
        spriteNode.set(color: .red, blendMode: .add)
        spriteNode.position = position
        targetNode.parent?.addChild(spriteNode)
        
        let duration = 0.5
        
        spriteNode.run(SKAction.group([
            SKAction.scale(to: 0.75, duration: duration/2),
            SKAction.rotate(byAngle: π/2 * CGFloat.randomSign(), duration: duration/2),
            SKAction.sequence([
                SKAction.wait(forDuration: duration/2),
                SKAction.fadeAlpha(to: 0, duration: duration/2),
                SKAction.removeFromParent()
                ])
            ]))
        
        if move {
            spriteNode.run(SKAction.customAction(withDuration: duration) { [weak targetNode] (node: SKNode, elapsedTime: CGFloat)  in
                guard let targetNode = targetNode else { return }
                node.position = targetNode.position
            })
        }
    }
    
    static func setSelected(spaceship: Spaceship?) {
        Spaceship.selectedSpaceship = spaceship
        spaceship?.showWeaponRangeShapeNode()
    }
    
    func retreat() {
        self.targetNode = nil
        self.physicsBody?.isDynamic = true
        self.destination = self.startingPosition
        self.setDestinationEffect()
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
    
    func loadHealthBar(gameWorld: SKNode) {
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
        let labelRespawn = Label(text: "")
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
        
        physicsBody.restitution = 0.9
        
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
    
    static func skinMaskTexture(index i: Int) -> SKTexture {
        let texture = SKTexture(imageNamed: Spaceship.skins[i] + "Mask", filteringMode: GameScene.defaultFilteringMode)
        return texture
    }
    
    static func randomColor() -> SKColor {
        var red = CGFloat.random()
        var green = CGFloat.random()
        var blue = CGFloat.random()
        
        let color = SKColor(red: red, green: green, blue: blue, alpha: 1)
        let element = Spaceship.elementFor(color: color)
        
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
            red += maxColor
            green += maxColor
            blue += maxColor
        }
        
        return SKColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func randomColorFor(element: Elements) -> SKColor {
        let color = Spaceship.randomColor()
        if Spaceship.elementFor(color: color).element == element {
            return color
        } else {
            return Spaceship.randomColorFor(element: element)
        }
    }
    
    static func elementColorFor(color: SKColor) -> SKColor {
        
        var elementColor = GameColors.darkness
        
        switch elementFor(color: color).element {
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
        
        return elementColor
    }
    
    static func elementFor(color: SKColor) -> Element {
        
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
    
    static func randomRarity() -> rarity {
        let n: CGFloat = CGFloat.random()
        var i: CGFloat = 1.0/2.0
        
        let rarities: [rarity] = [.uncommon, .rare, .epic, .legendary, .supreme]
        var value: rarity = .common
        
        for r in rarities {
            if n < i {
                i /= 2.0
                value = r
            }
        }
        return value
    }
}

