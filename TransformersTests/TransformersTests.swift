//
//  TransformersTests.swift
//  TransformersTests
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import XCTest
@testable import Transformers

class TransformersTests: XCTestCase, FightCompleteDelegate {
    func fightOverBecauseOfNames() {
        print("Game over")
    }
    
    var transformerArray = [Transformer]()
    override func setUp() {
       
    }

    func testBaseCase(){
        let transformer1 = Transformer(id: "0", team: Team.autobots, name: "A1", strength: 3, intelligence: 4, speed: 5, endurance: 3, rank: 5, courage: 5, firepower: 5, skill: 5, teamIcon: "")
        transformerArray.append(transformer1)
        
        let transformer2 = Transformer(id: "0", team: Team.decepticon, name: "D1", strength: 8, intelligence: 2, speed: 5, endurance: 3, rank: 5, courage: 10, firepower: 5, skill: 5, teamIcon: "")
        transformerArray.append(transformer2)
        
        let fight = Fight(fighter1: transformer1, fighter2: transformer2, delegate: self)
        
        fight.evaluateFighters { (arg) in
            print("fight complete")
            XCTAssert(fight.fighter1.state == TransformerState.Died)
            XCTAssert(fight.fighter2.state == TransformerState.Alive)
            XCTAssert(arg == MessageType.evaluatedByCourageStrength)
        }
    }
    
    func testRatingCase(){
        let transformer1 = Transformer(id: "0", team: Team.autobots, name: "A1", strength: 1, intelligence: 1, speed: 2, endurance: 1, rank: 2, courage: 1, firepower: 1, skill: 1, teamIcon: "")
        transformerArray.append(transformer1)
        
        let transformer2 = Transformer(id: "0", team: Team.decepticon, name: "D1", strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 2, courage: 1, firepower: 1, skill: 1, teamIcon: "")
        transformerArray.append(transformer2)
        
        let fight = Fight(fighter1: transformer1, fighter2: transformer2, delegate: self)
        
        fight.evaluateFighters {(arg) in
            print("fight complete")
            XCTAssert(fight.fighter1.state == TransformerState.Alive)
            XCTAssert(fight.fighter2.state == TransformerState.Died)
            XCTAssert(arg == MessageType.evaluatedByRating)
        }
    }
    
    func testNameCase1(){
        let transformer1 = Transformer(id: "0", team: Team.autobots, name: "Predaking", strength: 1, intelligence: 1, speed: 2, endurance: 1, rank: 2, courage: 1, firepower: 1, skill: 1, teamIcon: "")
        transformerArray.append(transformer1)
        
        let transformer2 = Transformer(id: "0", team: Team.decepticon, name: "D1", strength: 10, intelligence: 10, speed: 1, endurance: 1, rank: 2, courage: 10, firepower: 1, skill: 1, teamIcon: "")
        transformerArray.append(transformer2)
        
        let fight = Fight(fighter1: transformer1, fighter2: transformer2, delegate: self)
        
        fight.evaluateFighters {(arg) in
            print("fight complete")
            XCTAssert(fight.fighter1.state == TransformerState.Alive)
            XCTAssert(fight.fighter2.state == TransformerState.Died)
            XCTAssert(arg == MessageType.evaluatedByName)
        }
    }
    
    func testNameCase2(){
        let transformer1 = Transformer(id: "0", team: Team.autobots, name: "Predaking", strength: 1, intelligence: 1, speed: 2, endurance: 1, rank: 2, courage: 1, firepower: 1, skill: 1, teamIcon: "")
        transformerArray.append(transformer1)
        
        let transformer2 = Transformer(id: "0", team: Team.decepticon, name: "Predaking", strength: 10, intelligence: 10, speed: 1, endurance: 1, rank: 2, courage: 10, firepower: 1, skill: 1, teamIcon: "")
        transformerArray.append(transformer2)
        
        let fight = Fight(fighter1: transformer1, fighter2: transformer2, delegate: self)
        
        fight.evaluateFighters {(arg) in
            print("fight complete")
            XCTAssert(fight.fighter1.state == TransformerState.Died)
            XCTAssert(fight.fighter2.state == TransformerState.Died)
            XCTAssert(arg == MessageType.evaluatedByName)
        }
    }
}
