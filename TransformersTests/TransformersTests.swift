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
    
    override func setUp() {
        
    }

    func testBasicCase(){
        let transformer1 = Transformer(id: 0, team: Team.autobots, name: "A1", strength: 3, intelligence: 4, speed: 5, endurance: 3, rank: 5, courage: 5, firepower: 5, skill: 5, teamIcon: "")
        transformerArray.append(transformer1)
        
        let transformer2 = Transformer(id: 0, team: Team.autobots, name: "A1", strength: 3, intelligence: 4, speed: 5, endurance: 3, rank: 5, courage: 5, firepower: 5, skill: 5, teamIcon: "")
        transformerArray.append(transformer1)
        
        
    }

}
