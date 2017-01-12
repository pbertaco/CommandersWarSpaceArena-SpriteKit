//
//  MothershipSlotData.swift
//  GameVI
//
//  Created by Pablo Henrique Bertaco on 1/11/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import CoreData

extension MemoryCard {
    
    func newMothershipSlotData() -> MothershipSlotData {
        let mothershipSlotData: MothershipSlotData = self.insertNewObject()
        
        return mothershipSlotData
    }
}
