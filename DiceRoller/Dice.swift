//
//  Dice.swift
//  DiceRoller
//
//  Created by Christopher Fouts on 1/24/22.
//

import Foundation
import SwiftUI


struct Die: Hashable {
    static func == (lhs: Die, rhs: Die) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let id = UUID()
    let sides: Int
    let roll: Int
    
    init() {
        sides = 6
        self.roll = Int.random(in: 1...sides)
    }
    
    init(sides: Int) {
        self.sides = sides
        self.roll = Int.random(in: 1...sides)
    }
    
    func rollDice() -> Int {
        return Int.random(in: 1...sides)
    }
}
