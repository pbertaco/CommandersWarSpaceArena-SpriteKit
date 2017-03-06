//
//  HangarScene.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/30/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
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
    
    override func load() {
        super.load()
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        self.backgroundColor = GameColors.backgroundColor
        
        let stars = Stars()
        stars.position.x = stars.position.x + GameScene.currentSize.width/2
        stars.position.y = stars.position.y - GameScene.currentSize.height/2
        self.addChild(stars)
        
        let buttonBack = Button(imageNamed: "button55x55", x: 8, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonBack.setIcon(imageNamed: "Back")
        buttonBack.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonBack)
        buttonBack.addHandler { [weak self] in
            self?.nextState = .mainMenu
        }
        
        self.loadMothershipSlots()
        
        self.loadPlayerDataSpaceships()
        
        self.loadButtonChange()
        
        
        let control = Control(imageNamed: "box89x89", x: 375/2, y: -2, horizontalAlignment: .center)
        control.anchorPoint.x = 0.5
        control.size.width = GameScene.currentSize.width * 3
        self.addChild(control)
        
        let controlPremiumPoints = ControlPremiumPoints(x: 8, y: 15)
        controlPremiumPoints.setLabelPremiumPointsText(premiumPoints: playerData.premiumPoints)
        self.addChild(controlPremiumPoints)
        
        let controlPoints = ControlPoints(x: 223, y: 15, horizontalAlignment: .right)
        controlPoints.setLabelPointsText(points: playerData.points)
        self.addChild(controlPoints)
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
    
    func loadButtonChange() {
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let buttonChange = Button(imageNamed: "button233x55", x: 71, y: 306, horizontalAlignment: .center, verticalAlignment: .center)
        buttonChange.setIcon(imageNamed: "Data in Both Directions")
        buttonChange.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonChange)
        
        buttonChange.addHandler { [weak self, weak playerData] in
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
                    
                    let aPosition = a.position
                    let bPosition = b.position
                    a.position = bPosition
                    b.position = aPosition
                }
            }
            
            if let a = a as? SpaceshipHangarCell {
                if let b = b as? SpaceshipHangarCell {
                    
                    if let aSpaceshipData = a.spaceshipData() {
                        if let bSpaceshipData = b.spaceshipData() {
                            
                            aSpaceshipData.parentMothershipSlot?.spaceship = bSpaceshipData
                            playerData?.removeFromSpaceships(bSpaceshipData)
                            playerData?.addToSpaceships(aSpaceshipData)
                            
                            a.loadButtonSell()
                            b.loadControlSlot()
                        }
                    }
                }
            }
        }
        
        if scrollNodePlayerDataSpaceships.cells.count <= 0 {
            buttonChange.isHidden = true
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
                cellsPlayerDataSpaceships.append(SpaceshipHangarCell(spaceship: spaceship))
            }
        }
        
        let scrollNode = ScrollNode(cells: cellsPlayerDataSpaceships, spacing: 71, scrollDirection: .horizontal, x: 71, y: 369, horizontalAlignment: .center, verticalAlignment: .center)
        scrollNode.isUserInteractionEnabled = false
        self.addChild(scrollNode)
        
        let buttonLeft = Button(imageNamed: "button55x55", x: 8, y: 414, horizontalAlignment: .center, verticalAlignment: .center)
        buttonLeft.setIcon(imageNamed: "Back")
        buttonLeft.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonLeft)
        
        let buttonRight = Button(imageNamed: "button55x55", x: 312, y: 414, horizontalAlignment: .center, verticalAlignment: .center)
        buttonRight.setIcon(imageNamed: "Forward")
        buttonRight.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonRight)
        
        buttonLeft.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let this = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonRight.isHidden = false
            
            if this.cellIndexPlayerDataSpaceships > 0 {
                this.cellIndexPlayerDataSpaceships = this.cellIndexPlayerDataSpaceships - 1
                scrollNode.touchMoved(touchDelta: CGPoint(x: -304/2, y: 0))
                if this.cellIndexPlayerDataSpaceships <= 0 {
                    buttonLeft.isHidden = true
                }
            }
        }
        
        buttonRight.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let this = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonLeft.isHidden = false
            
            if this.cellIndexPlayerDataSpaceships < cellsPlayerDataSpaceships.count - 1 {
                this.cellIndexPlayerDataSpaceships = this.cellIndexPlayerDataSpaceships + 1
                scrollNode.touchMoved(touchDelta: CGPoint(x: 304/2, y: 0))
                if this.cellIndexPlayerDataSpaceships >= cellsPlayerDataSpaceships.count - 1 {
                    buttonRight.isHidden = true
                }
            }
        }
        
        buttonLeft.isHidden = true
        
        self.scrollNodePlayerDataSpaceships = scrollNode
        
        if scrollNode.cells.count <= 1 {
            buttonRight.isHidden = true
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
                    cellsMothershipSlots.append(SpaceshipHangarCell(spaceship: spaceship))
                }
            }
        }
        
        let scrollNode = ScrollNode(cells: cellsMothershipSlots, spacing: 71, scrollDirection: .horizontal, x: 71, y: 154, horizontalAlignment: .center, verticalAlignment: .center)
        scrollNode.isUserInteractionEnabled = false
        self.addChild(scrollNode)
        
        let buttonLeft = Button(imageNamed: "button55x55", x: 8, y: 199, horizontalAlignment: .center, verticalAlignment: .center)
        buttonLeft.setIcon(imageNamed: "Back")
        buttonLeft.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonLeft)
        
        let buttonRight = Button(imageNamed: "button55x55", x: 312, y: 199, horizontalAlignment: .center, verticalAlignment: .center)
        buttonRight.setIcon(imageNamed: "Forward")
        buttonRight.set(color: GameColors.controlBlue, blendMode: .add)
        self.addChild(buttonRight)
        
        buttonLeft.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let this = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonRight.isHidden = false
            
            if this.cellIndexMothershipSlots > 0 {
                this.cellIndexMothershipSlots = this.cellIndexMothershipSlots - 1
                scrollNode.touchMoved(touchDelta: CGPoint(x: -304/2, y: 0))
                if this.cellIndexMothershipSlots <= 0 {
                    buttonLeft.isHidden = true
                }
            }
        }
        
        buttonRight.addHandler { [weak self, weak scrollNode, weak buttonLeft, weak buttonRight] in
            guard let this = self else { return }
            guard let scrollNode = scrollNode else { return }
            guard let buttonLeft = buttonLeft else { return }
            guard let buttonRight = buttonRight else { return }
            
            buttonLeft.isHidden = false
            
            if this.cellIndexMothershipSlots < cellsMothershipSlots.count - 1 {
                this.cellIndexMothershipSlots = this.cellIndexMothershipSlots + 1
                scrollNode.touchMoved(touchDelta: CGPoint(x: 304/2, y: 0))
                if this.cellIndexMothershipSlots >= cellsMothershipSlots.count - 1 {
                    buttonRight.isHidden = true
                }
            }
        }
        
        buttonLeft.isHidden = true
        
        self.scrollNodeMothershipSlots = scrollNode
    }
}
