//
//  GameWorld.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/18/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameWorld: SKNode, SKPhysicsContactDelegate {
    enum zPosition: CGFloat {
        case stars = -50
        case border = -40
        case mothership = -30
        case mothershipHealthBar = -20
        case shot = -10
        case spaceship = 0
        case explosion = 10
        case targetEffect = 20
        case spaceshipWeaponRangeShapeNode = 30
        case spaceshipHealthBar = 40
        case damageEffect = 50
    }

    static func current() -> GameWorld? {
        return GameWorld.lastInstance
    }

    private weak static var lastInstance: GameWorld?

    var explosionSoundEffect: SoundEffect!
    var shotSoundEffect: SoundEffect!

    weak var stars: Stars!

    init(loadBorder: Bool = true) {
        super.init()

        GameWorld.lastInstance = self

        let stars = Stars()
        self.addChild(stars)
        self.stars = stars

        self.loadSoundEffect()

        if !loadBorder {
            return
        }

        let border = SKSpriteNode(imageNamed: "gameWorld", filteringMode: GameScene.defaultFilteringMode)
        border.zPosition = GameWorld.zPosition.border.rawValue
        self.addChild(border)

        self.loadPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSize() {
        self.stars.updateSize()
    }

    func loadPhysics() {
        self.zPosition = BattleScene.zPosition.gameWorld.rawValue

        let size = GameScene.sketchSize
        let physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size))

        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = GameWorld.categoryBitMask.world.rawValue
        physicsBody.collisionBitMask = GameWorld.collisionBitMask.world.rawValue
        physicsBody.contactTestBitMask = GameWorld.contactTestBitMask.world.rawValue

        self.physicsBody = physicsBody
    }

    func loadSoundEffect() {
        self.explosionSoundEffect = SoundEffect(effectType: .explosion)
        self.shotSoundEffect = SoundEffect(effectType: .laser)
    }

    func shake() {
        let zRotation = CGFloat.random(min: -π, max: +π)
        let distance: CGFloat = 34
        let amount = CGPoint(x: -sin(zRotation) * distance, y: cos(zRotation) * distance)
        self.run(SKAction.screenShakeWithNode(self, amount: amount, oscillations: 10, duration: 1))
    }

    func didBegin(_ contact: SKPhysicsContact) {
        // Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }

        switch categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            /*
             world
             spaceship
             mothershipSpaceship
             deadSpaceship
             shot
             spaceshipShot
             mothership
             deadMothership
             */

        case [.spaceship, .shot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break

        case [.spaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break

        case [.mothershipSpaceship, .shot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break

        case [.mothershipSpaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break

        case [.mothershipSpaceship, .mothership]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didBeginContact(with: bodyB)
            }
            break

        case [.deadSpaceship, .shot]:
            break

        case [.deadSpaceship, .spaceshipShot]:
            break

        case [.deadSpaceship, .mothership]:
            break

        case [.deadSpaceship, .deadMothership]:
            break

        case [.shot, .mothership]:
            if let mothership = bodyB.node as? Mothership {
                mothership.didBeginContact(with: bodyA)
            }
            break

        case [.shot, .deadMothership]:
            break

        case [.spaceshipShot, .mothership]:
            if let mothership = bodyB.node as? Mothership {
                mothership.didBeginContact(with: bodyA)
            }
            break

        case [.spaceshipShot, .deadMothership]:
            break

        default:
            #if DEBUG
                var bodyAcategoryBitMask = ""
                var bodyBcategoryBitMask = ""

                switch bodyA.categoryBitMask {
                case categoryBitMask.world.rawValue:
                    bodyAcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyAcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyAcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.deadSpaceship.rawValue:
                    bodyAcategoryBitMask = "deadSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyAcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyAcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyAcategoryBitMask = "mothership"
                    break
                case categoryBitMask.deadMothership.rawValue:
                    bodyBcategoryBitMask = "deadMothership"
                    break
                default:
                    bodyAcategoryBitMask = "unknown"
                    break
                }

                switch bodyB.categoryBitMask {
                case categoryBitMask.world.rawValue:
                    bodyBcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyBcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyBcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.deadSpaceship.rawValue:
                    bodyAcategoryBitMask = "deadSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyBcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyBcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyBcategoryBitMask = "mothership"
                    break
                case categoryBitMask.deadMothership.rawValue:
                    bodyBcategoryBitMask = "deadMothership"
                    break
                default:
                    bodyBcategoryBitMask = "unknown"
                    break
                }

                print("\(#function) case [.\(bodyAcategoryBitMask), .\(bodyBcategoryBitMask)]:")
                fatalError()
            #endif
            break
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        // Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }

        switch categoryBitMask(rawValue: bodyA.categoryBitMask | bodyB.categoryBitMask) {
            /*
             world
             spaceship
             mothershipSpaceship
             deadSpaceship
             shot
             spaceshipShot
             mothership
             deadMothership
             */

        case [.spaceship, .shot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break

        case [.spaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break

        case [.mothershipSpaceship, .shot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break

        case [.mothershipSpaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break

        case [.mothershipSpaceship, .mothership]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break

        case [.mothershipSpaceship, .deadMothership]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break

        case [.deadSpaceship, .shot]:
            break

        case [.deadSpaceship, .spaceshipShot]:
            if let spaceship = bodyA.node as? Spaceship {
                spaceship.didEndContact(with: bodyB)
            }
            break

        case [.shot, .mothership]:
            if let mothership = bodyB.node as? Mothership {
                mothership.didEndContact(with: bodyA)
            }
            break

        case [.spaceshipShot, .mothership]:
            if let mothership = bodyB.node as? Mothership {
                mothership.didEndContact(with: bodyA)
            }
            break

        default:
            #if DEBUG
                var bodyAcategoryBitMask = ""
                var bodyBcategoryBitMask = ""

                switch bodyA.categoryBitMask {
                case categoryBitMask.world.rawValue:
                    bodyAcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyAcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyAcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.deadSpaceship.rawValue:
                    bodyAcategoryBitMask = "deadSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyAcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyAcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyAcategoryBitMask = "mothership"
                    break
                case categoryBitMask.deadMothership.rawValue:
                    bodyBcategoryBitMask = "deadMothership"
                    break
                default:
                    bodyAcategoryBitMask = "unknown"
                    break
                }

                switch bodyB.categoryBitMask {
                case categoryBitMask.world.rawValue:
                    bodyBcategoryBitMask = "world"
                    break
                case categoryBitMask.spaceship.rawValue:
                    bodyBcategoryBitMask = "spaceship"
                    break
                case categoryBitMask.mothershipSpaceship.rawValue:
                    bodyBcategoryBitMask = "mothershipSpaceship"
                    break
                case categoryBitMask.deadSpaceship.rawValue:
                    bodyAcategoryBitMask = "deadSpaceship"
                    break
                case categoryBitMask.shot.rawValue:
                    bodyBcategoryBitMask = "shot"
                    break
                case categoryBitMask.spaceshipShot.rawValue:
                    bodyBcategoryBitMask = "spaceshipShot"
                    break
                case categoryBitMask.mothership.rawValue:
                    bodyBcategoryBitMask = "mothership"
                    break
                case categoryBitMask.deadMothership.rawValue:
                    bodyBcategoryBitMask = "deadMothership"
                    break
                default:
                    bodyBcategoryBitMask = "unknown"
                    break
                }

                print("\(#function) case [.\(bodyAcategoryBitMask), .\(bodyBcategoryBitMask)]:")
                fatalError()
            #endif
            break
        }
    }

    struct categoryBitMask: OptionSet {
        let rawValue: UInt32

        static let world = categoryBitMask(rawValue: 1 << 0)
        static let spaceship = categoryBitMask(rawValue: 1 << 1)
        static let mothershipSpaceship = categoryBitMask(rawValue: 1 << 2)
        static let deadSpaceship = categoryBitMask(rawValue: 1 << 3)
        static let shot = categoryBitMask(rawValue: 1 << 4)
        static let spaceshipShot = categoryBitMask(rawValue: 1 << 5)
        static let mothership = categoryBitMask(rawValue: 1 << 6)
        static let deadMothership = categoryBitMask(rawValue: 1 << 7)
    }

    struct collisionBitMask {
        static let world: categoryBitMask = []
        static let spaceship: categoryBitMask = [.world, .spaceship, .mothershipSpaceship, .mothership]
        static let mothershipSpaceship: categoryBitMask = [.world, .spaceship, .mothershipSpaceship]
        static let deadSpaceship: categoryBitMask = []
        static let shot: categoryBitMask = []
        static let spaceshipShot: categoryBitMask = []
        static let mothership: categoryBitMask = []
        static let deadMothership: categoryBitMask = []
    }

    struct contactTestBitMask {
        static let world: categoryBitMask = []
        static let spaceship: categoryBitMask = [.shot, .spaceshipShot]
        static let mothershipSpaceship: categoryBitMask = [.shot, .spaceshipShot, .mothership]
        static let deadSpaceship: categoryBitMask = []
        static let shot: categoryBitMask = [.spaceship, .mothershipSpaceship, .mothership]
        static let spaceshipShot: categoryBitMask = [.spaceship, .mothershipSpaceship, .mothership]
        static let mothership: categoryBitMask = [.mothershipSpaceship, .shot, .spaceshipShot]
        static let deadMothership: categoryBitMask = []
    }
}
