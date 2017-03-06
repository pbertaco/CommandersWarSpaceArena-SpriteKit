//
//  MothershipData.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData

extension MemoryCard {
    
    func newMothershipData() -> MothershipData {
        let mothershipData: MothershipData = self.insertNewObject()
        
        return mothershipData
    }
}
