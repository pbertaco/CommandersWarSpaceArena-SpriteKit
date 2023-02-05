//
//  Element.swift
//  CommandersWar
//
//  Created by Pablo Henrique Bertaco on 23/05/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

public enum Elements: String {
    case fire
    case ice
    case wind
    case earth
    case thunder
    case water
    case light
    case darkness
}

class Element {
    var element: Elements
    var strength: Elements
    var weakness: Elements
    var color: SKColor

    init(element: Elements, strength: Elements, weakness: Elements) {
        self.element = element
        self.strength = strength
        self.weakness = weakness

        var elementColor = GameColors.darkness

        switch element {
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
        self.color = elementColor
    }

    static var types: [Elements: Element] = [
        .fire: Element(element: .fire, strength: .ice, weakness: .water),
        .ice: Element(element: .ice, strength: .wind, weakness: .fire),
        .wind: Element(element: .wind, strength: .earth, weakness: .ice),
        .earth: Element(element: .earth, strength: .thunder, weakness: .wind),
        .thunder: Element(element: .thunder, strength: .water, weakness: .earth),
        .water: Element(element: .water, strength: .fire, weakness: .thunder),
        .light: Element(element: .light, strength: .light, weakness: .darkness),
        .darkness: Element(element: .darkness, strength: .darkness, weakness: .light),
    ]
}
