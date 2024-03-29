//
//  Model.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

let superHeroes = ["Optimus Prime", "Predaking"]

class Transformer: NSObject, NSCoding,NSSecureCoding{
    static var supportsSecureCoding: Bool{
        return true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(transformerId, forKey: "transformerId")
        aCoder.encode(transformerName, forKey: "transformerName")
        aCoder.encode(strength, forKey: "strength")
        aCoder.encode(intelligence, forKey: "intelligence")
        aCoder.encode(speed, forKey: "speed")
        aCoder.encode(rank, forKey: "rank")
        aCoder.encode(courage, forKey: "courage")
        aCoder.encode(skill, forKey: "skill")
        aCoder.encode(teamIcon, forKey: "teamIcon")
        aCoder.encode(endurance, forKey: "endurance")
        aCoder.encode(firepower, forKey: "firepower")
        aCoder.encode((state ?? TransformerState.Born).rawValue, forKey: "state")
        aCoder.encode((transformerTeam ?? Team.autobots).rawValue, forKey: "transformerTeam")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard
            let transId = aDecoder.decodeObject(forKey: "transformerId") as? String,
            let transName = aDecoder.decodeObject(forKey: "transformerName") as? String
            else {
                return nil
        }
        
        transformerId = transId
        transformerName = transName
        strength = aDecoder.decodeObject(forKey: "strength") as? Int
        intelligence = aDecoder.decodeObject(forKey: "intelligence") as? Int
        speed = aDecoder.decodeObject(forKey: "speed") as? Int
        endurance = aDecoder.decodeObject(forKey: "endurance") as? Int
        rank = aDecoder.decodeObject(forKey: "rank") as? Int
        courage = aDecoder.decodeObject(forKey: "courage") as? Int
        firepower = aDecoder.decodeObject(forKey: "firepower") as? Int
        skill = aDecoder.decodeObject(forKey: "skill") as? Int
        teamIcon = aDecoder.decodeObject(forKey: "teamIcon") as? String
        let team = aDecoder.decodeObject(forKey: "transformerTeam") as? String
        transformerTeam = Team(rawValue: team ?? "A")
        let s = aDecoder.decodeObject(forKey: "state") as? String
        state = TransformerState(rawValue: s ?? "Born")
         super.init()
    }
    
    var transformerId: String?
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
    
    init(id: String, team: Team, name: String, strength: Int, intelligence: Int, speed: Int, endurance: Int,
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

