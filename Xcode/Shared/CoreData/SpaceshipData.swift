//
//  SpaceshipData.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData

extension MemoryCard {
    
    func newSpaceshipData() -> SpaceshipData {
        let spaceshipData: SpaceshipData = self.insertNewObject()
        
        spaceshipData.level = 1
        
        return spaceshipData
    }
}
