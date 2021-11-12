//
//  HangarScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/30/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
    enum zPosition: CGFloat {
        case blackSpriteNode = 100000
        case box = 1000000
    }
    
    enum state: String {
        case hangar
        case mainMenu
    }
    
    var state: state = .hangar
    var nextState: state = .hangar
    
    var cellIndexMothershipSlots = 0
    var cellIndexPlayerDataSpaceships = 0
    
    var scrollNodeMothershipSlots: ScrollNode!
    var scrollNodePlayerDataSpaceships: ScrollNode!
    
    weak var stars: Stars!
    
    weak var buttonLeft: Button?
    weak var buttonRight: Button?
    weak var buttonChange: Button?
    
    override func load() {
        super.load()
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.backgroundColor = GameColors.backgroundColor
        
        let stars = Stars()
        stars.position.x += GameScene.currentSize.width/2
        stars.position.y -= GameScene.currentSize.height/2
        self.addChild(stars)
        self.stars = stars
        
        let buttonBack = Button(imageNamed: "button_55x55", x: 8, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBack.setIcon(imageNamed: "Back")
        buttonBack.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonBack)
        buttonBack.addHandler { [weak self] in
            guard let `self` = self else { return }
            self.nextState = .mainMenu
        }
        
        self.loadMothershipSlots()
        
        self.loadPlayerDataSpaceships()
        
        self.loadButtonChange()
        
        let x: Int = Int(GameScene.currentSize.width) + 4
        let control = Control(imageNamed: "box_\(x)x89", x: 375/2, y: -2, horizontalAlignment: .center)
        control.control?.anchorPoint.x = 0.5
        self.addChild(control)
        
        let controlPremiumPoints = ControlPremiumPoints(x: 8, y: 15)
        controlPremiumPoints.setLabelPremiumPointsText(premiumPoints: playerData.premiumPoints)
        self.addChild(controlPremiumPoints)
        
        let controlPoints = ControlPoints(x: 223, y: 15, horizontalAlignment: .right)
        controlPoints.setLabelPointsText(points: playerData.points)
        self.addChild(controlPoints)
    }
    
    override func updateSize() {
        super.updateSize()
        self.stars.updateSize()
        self.stars.position.x += GameScene.currentSize.width/2
        self.stars.position.y -= GameScene.currentSize.height/2
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .hangar:
                break
                
            case .mainMenu:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .hangar:
                break
                
            case .mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
    
    override func fpsCountUpdate(fps: Int) {
        
        if fps >= 30 {
            if self.needMusic {
                self.needMusic = false
                Music.sharedInstance.playMusic(withType: .menu)
            }
        }
    }
    
    func loadButtonChange() {
        
        let buttonChange = Button(imageNamed: "button_233x55", x: 71, y: 306, horizontalAlignment: .center, verticalAlignment: .center)
        buttonChange.setIcon(imageNamed: "Data in Both Directions")
        buttonChange.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonChange)
        self.buttonChange = buttonChange
        
        buttonChange.addHandler { [weak self] in
            guard let this = self else { return }
            
            let a = this.scrollNodeMothershipSlots.cells[this.cellIndexMothershipSlots]
            let b = this.scrollNodePlayerDataSpaceships.cells[this.cellIndexPlayerDataSpaceships]
            
            if let b = b as? SpaceshipHangarCell {
                if b.spaceshipData() == nil {
                    return
                }
            }
            
            this.scrollNodeMothershipSlots.cells[this.cellIndexMothershipSlots] = b
            this.scrollNodePlayerDataSpaceships.cells[this.cellIndexPlayerDataSpaceships] = a
            
            if let aParent = a.parent {
                if let bParent = b.parent {
                    a.move(toParent: bParent)
                    b.move(toParent: aParent)
                    
                    let aMoveEffect = SKTMoveEffect(node: a, duration: 2, startPosition: aParent.convert(a.position, to: bParent), endPosition: a.position)
                    aMoveEffect.timingFunction = SKTTimingFunctionElasticEaseOut
                    let bMoveEffect = SKTMoveEffect(node: b, duration: 2, startPosition: bParent.convert(b.position, to: aParent), endPosition: b.position)
                    bMoveEffect.timingFunction = SKTTimingFunctionElasticEaseOut
                    
                    a.run(SKAction.actionWithEffect(aMoveEffect))
                    a.run(SKAction.actionWithEffect(bMoveEffect))
                }
            }
            
            if let a = a as? SpaceshipHangarCell {
                if let b = b as? SpaceshipHangarCell {
                    
                    if let aSpaceshipData = a.spaceshipData() {
                        if let bSpaceshipData = b.spaceshipData() {
                            
                            aSpaceshipData.parentMothershipSlot?.spaceship = bSpaceshipData
                            
                            let playerData = MemoryCard.sharedInstance.playerData!
                            playerData.removeFromSpaceships(bSpaceshipData)
                            playerData.addToSpaceships(aSpaceshipData)
                            
                            a.loadButtonSell(duration: 0.25, sellCompletion: {
                                this.sellCompletion()
                            })
                            b.loadControlSlot(duration: 0.25)
                        }
                    }
                }
            }
        }
        
        if scrollNodePlayerDataSpaceships.cells.count <= 0 {
            buttonChange.isHidden = true
        } else {
            self.compareShips()
        }
    }
    
    func sellCompletion() {
        self.scrollNodePlayerDataSpaceships.remove(at: self.cellIndexPlayerDataSpaceships)
        if self.cellIndexPlayerDataSpaceships >= self.scrollNodePlayerDataSpaceships.cells.count {
            self.cellIndexPlayerDataSpaceships = self.scrollNodePlayerDataSpaceships.cells.count - 1
            self.scrollNodePlayerDataSpaceships.back()
        }
        
        if self.cellIndexPlayerDataSpaceships <= 0 {
            self.buttonLeft?.isUserInteractionEnabled = false
            self.buttonLeft?.run(SKAction.fadeAlpha(to: 0, duration: 0.25))
        }
        
        if self.cellIndexPlayerDataSpaceships >= self.scrollNodePlayerDataSpaceships.cells.count - 1 {
            self.buttonRight?.isUserInteractionEnabled = false
            self.buttonRight?.run(SKAction.fadeAlpha(to: 0, duration: 0.25))
        }
        
        if self.scrollNodePlayerDataSpaceships.cells.count <= 0 {
            self.buttonChange?.isUserInteractionEnabled = false
            self.buttonChange?.run(SKAction.fadeAlpha(to: 0, duration: 0.25))
            
            let a = self.scrollNodeMothershipSlots.cells[self.cellIndexMothershipSlots]
            if let a = a as? SpaceshipHangarCell {
                a.clearLabelColors()
            }
        } else {
            self.compareShips()
        }
    }
    
    func compareShips() {
        if scrollNodePlayerDataSpaceships.cells.count > 0 {
            let a = self.scrollNodeMothershipSlots.cells[self.cellIndexMothershipSlots]
            let b = self.scrollNodePlayerDataSpaceships.cells[self.cellIndexPlayerDataSpaceships]
            
            if let a = a as? SpaceshipHangarCell {
                if let b = b as? SpaceshipHangarCell {
                    a.compareTo(spaceshipHangarCell: b)
                    b.compareTo(spaceshipHangarCell: a)
                }
            }
        }
    }
    
    func loadPlayerDataSpaceships() {
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var cellsPlayerDataSpaceships = [SpaceshipHangarCell]()
        
        if let playerDataSpaceships = (playerData.spaceships as? Set<SpaceshipData>)?.sorted(by: {
            $0.baseDamage > $1.baseDamage
        }) {
            for spaceshipData in playerDataSpaceships {
                let spaceship = Spaceship(spaceshipData: spaceshipData)
                cellsPlayerDataSpaceships.append(SpaceshipHangarCell(spaceship: spaceship, sellCompletion: { [weak self] in
                    guard let `self` = self else { return }
                    self.sellCompletion()
                }))
            }
        }
        
        let scrollNode = ScrollNode(cells: cellsPlayerDataSpaceships, spacing: 71, scrollDirection: .horizontal, x: 71, y: 369, horizontalAlignment: .center, verticalAlignment: .center)
        scrollNode.isUserInteractionEnabled = false
        self.addChild(scrollNode)
        
        let buttonLeft = Button(imageNamed: "button_55x55", x: 8, y: 414, horizontalAlignment: .center, verticalAlignment: .center)
        buttonLeft.setIcon(imageNamed: "Back")
        buttonLeft.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonLeft)
        self.buttonLeft = buttonLeft
        
        let buttonRight = Button(imageNamed: "button_55x55", x: 312, y: 414, horizontalAlignment: .center, verticalAlignment: .center)
        buttonRight.setIcon(imageNamed: "Forward")
        buttonRight.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonRight)
        self.buttonRight = buttonRight
        
        buttonLeft.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let `self` = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonRight.isUserInteractionEnabled = true
            buttonRight.run(SKAction.fadeAlpha(to: 1, duration: 0.25))
            
            if self.cellIndexPlayerDataSpaceships > 0 {
                
                let cell = self.scrollNodePlayerDataSpaceships.cells[self.cellIndexPlayerDataSpaceships]
                if let spaceshipHangarCell = cell as? SpaceshipHangarCell {
                    spaceshipHangarCell.clearLabelColors()
                }
                
                self.cellIndexPlayerDataSpaceships -= 1
                scrollNode.back()
                if self.cellIndexPlayerDataSpaceships <= 0 {
                    buttonLeft.isUserInteractionEnabled = false
                    buttonLeft.run(SKAction.fadeAlpha(to: 0, duration: 0.25))
                }
                
                self.compareShips()
            }
        }
        
        buttonRight.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let `self` = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonLeft.isUserInteractionEnabled = true
            buttonLeft.run(SKAction.fadeAlpha(to: 1, duration: 0.25))
            
            if self.cellIndexPlayerDataSpaceships < scrollNode.cells.count - 1 {
                
                let cell = self.scrollNodePlayerDataSpaceships.cells[self.cellIndexPlayerDataSpaceships]
                if let spaceshipHangarCell = cell as? SpaceshipHangarCell {
                    spaceshipHangarCell.clearLabelColors()
                }
                
                self.cellIndexPlayerDataSpaceships += 1
                scrollNode.forward()
                if self.cellIndexPlayerDataSpaceships >= scrollNode.cells.count - 1 {
                    buttonRight.isUserInteractionEnabled = false
                    buttonRight.run(SKAction.fadeAlpha(to: 0, duration: 0.25))
                }
                
                self.compareShips()
            }
        }
        
        buttonLeft.alpha = 0
        buttonLeft.isUserInteractionEnabled = false
        
        self.scrollNodePlayerDataSpaceships = scrollNode
        
        if scrollNode.cells.count <= 1 {
            buttonRight.alpha = 0
            buttonRight.isUserInteractionEnabled = false
        }
    }
    
    func loadMothershipSlots() {
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var cellsMothershipSlots = [SpaceshipHangarCell]()
        
        if let mothershipSlots = (playerData.mothership?.slots as? Set<MothershipSlotData>)?.sorted(by: {
        return $0.index < $1.index
        }) {
            for slot in mothershipSlots {
                if let spaceshipData = slot.spaceship {
                    let spaceship = Spaceship(spaceshipData: spaceshipData)
                    cellsMothershipSlots.append(SpaceshipHangarCell(spaceship: spaceship, sellCompletion: {}))
                }
            }
        }
        
        let scrollNode = ScrollNode(cells: cellsMothershipSlots, spacing: 71, scrollDirection: .horizontal, x: 71, y: 154, horizontalAlignment: .center, verticalAlignment: .center)
        scrollNode.isUserInteractionEnabled = false
        self.addChild(scrollNode)
        
        let buttonLeft = Button(imageNamed: "button_55x55", x: 8, y: 199, horizontalAlignment: .center, verticalAlignment: .center)
        buttonLeft.setIcon(imageNamed: "Back")
        buttonLeft.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonLeft)
        
        let buttonRight = Button(imageNamed: "button_55x55", x: 312, y: 199, horizontalAlignment: .center, verticalAlignment: .center)
        buttonRight.setIcon(imageNamed: "Forward")
        buttonRight.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonRight)
        
        buttonLeft.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let `self` = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonRight.isUserInteractionEnabled = true
            buttonRight.run(SKAction.fadeAlpha(to: 1, duration: 0.25))
            
            if self.cellIndexMothershipSlots > 0 {
                
                let cell = self.scrollNodeMothershipSlots.cells[self.cellIndexMothershipSlots]
                if let spaceshipHangarCell = cell as? SpaceshipHangarCell {
                    spaceshipHangarCell.clearLabelColors()
                }
                
                self.cellIndexMothershipSlots -= 1
                scrollNode.back()
                if self.cellIndexMothershipSlots <= 0 {
                    buttonLeft.isUserInteractionEnabled = false
                    buttonLeft.run(SKAction.fadeAlpha(to: 0, duration: 0.25))
                }
                
                self.compareShips()
            }
        }
        
        buttonRight.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let `self` = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonLeft.isUserInteractionEnabled = true
            buttonLeft.run(SKAction.fadeAlpha(to: 1, duration: 0.25))
            
            if self.cellIndexMothershipSlots < scrollNode.cells.count - 1 {
                
                let cell = self.scrollNodeMothershipSlots.cells[self.cellIndexMothershipSlots]
                if let spaceshipHangarCell = cell as? SpaceshipHangarCell {
                    spaceshipHangarCell.clearLabelColors()
                }
                
                self.cellIndexMothershipSlots += 1
                scrollNode.forward()
                if self.cellIndexMothershipSlots >= scrollNode.cells.count - 1 {
                    buttonRight.isUserInteractionEnabled = false
                    buttonRight.run(SKAction.fadeAlpha(to: 0, duration: 0.25))
                }
                
                self.compareShips()
            }
        }
        
        buttonLeft.alpha = 0
        buttonLeft.isUserInteractionEnabled = false
        
        self.scrollNodeMothershipSlots = scrollNode
    }
}
