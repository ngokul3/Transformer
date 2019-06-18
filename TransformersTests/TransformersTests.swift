//
//  TransformersTests.swift
//  TransformersTests
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import XCTest
@testable import Transformers

class TransformersTests: XCTestCase {
    var transformerArray = [Transformer]()
    let presenter = TransformerPresenter()
    
    override func setUp() {
        let transformer1 = Transformer(id: 0, team: Team.autobots, name: "A1", strength: 3, intelligence: 4, speed: 5, endurance: 3, rank: 5, courage: 5, firepower: 5, skill: 5, teamIcon: "")
        transformerArray.append(transformer1)
        
        let transformer2 = Transformer(id: 0, team: Team.decepticon, name: "D1", strength: 7, intelligence: 2, speed: 5, endurance: 3, rank: 5, courage: 5, firepower: 5, skill: 5, teamIcon: "")
        transformerArray.append(transformer2)
        
        presenter.transformersOpt = transformerArray
    }
    
//    let a = (strength ?? 0) + (speed ?? 0) + (endurance ?? 0)
//    let b = (intelligence ?? 0) + (firepower ?? 0)
//

    func testRankMatching(){
        let fighters = presenter.findFighters(for: 5)
        
        XCTAssert(fighters != nil)
        print(fighters!.0!)
        print(fighters!.1!)
        
    }
    
    func testBaseCase(){
        let fighters = presenter.findFighters(for: 5)
        
        let fight = Fight(fighter1: fighters!.0!, fighter2: fighters!.1!)
        
        fight.evaluateFighters {
            print("fight complete")
            XCTAssert(fight.fighter1.state == TransformerState.Died)
            XCTAssert(fight.fighter2.state == TransformerState.Alive)
        }
    }
}
