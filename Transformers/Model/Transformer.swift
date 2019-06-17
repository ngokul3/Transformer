//
//  Model.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

let superHeroes = ["Optimus Prime", "Predaking"]

class Transformer: NSObject, NSCoding{
    
    func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard
            let transId = aDecoder.decodeObject(forKey: "transformerId") as? Int,
            let transName = aDecoder.decodeObject(forKey: "transformerTeam") as? String
            else {
                return nil
        }
        
        transformerId = transId
        transformerName = transName
        strength = aDecoder.decodeInteger(forKey: "strength")
        intelligence = aDecoder.decodeInteger(forKey: "intelligence")
        speed = aDecoder.decodeInteger(forKey: "speed")
        endurance = aDecoder.decodeInteger(forKey: "endurance")
        rank = aDecoder.decodeInteger(forKey: "rank")
        courage = aDecoder.decodeInteger(forKey: "courage")
        firepower = aDecoder.decodeInteger(forKey: "firepower")
        skill = aDecoder.decodeInteger(forKey: "skill")
        teamIcon = aDecoder.decodeObject(forKey: "teamIcon") as? String
        super.init()
    }
    
    var transformerId: Int?
    var transformerTeam: Team?
    var transformerName: String?
    var strength: Int?
    var intelligence: Int?
    var speed: Int?
    var endurance: Int?
    var rank:Int?
    var courage: Int?
    var firepower:Int?
    var skill: Int?
    
    var rating: Int{
        let a = (strength ?? 0) + (speed ?? 0) + (endurance ?? 0)
        let b = (intelligence ?? 0) + (firepower ?? 0)
        return a + b
    }
    
    var isSuperHero: Bool{
        if(superHeroes.contains(transformerName ?? "")){
            return true
        }else{
            return false
        }
    }
    var teamIcon: String?
    var state: TransformerState?
    
    init(id: Int, team: Team, name: String, strength: Int, intelligence: Int, speed: Int, endurance: Int,
         rank: Int, courage: Int, firepower: Int, skill: Int, teamIcon: String  ) {
        self.transformerId = id
        self.transformerTeam = team
        self.transformerName = name
        self.strength = strength
        self.intelligence = intelligence
        self.speed = speed
        self.endurance = endurance
        self.rank = rank
        self.courage = courage
        self.firepower = firepower
        self.skill = skill
        self.teamIcon = teamIcon
        self.state = TransformerState.Born
    }
}

