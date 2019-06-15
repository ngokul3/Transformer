//
//  Model.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

enum Team {
    case autobots
    case decepticon
}

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
    var teamIcon: String?
    
    init(_id: Int, _team: Team, _name: String, _strength: Int, _intelligence: Int, _speed: Int, _endurance: Int,
        _rank: Int, _courage: Int, _firepower: Int, _skill: Int, _teamIcon: String   ) {
        self.transformerId = _id
        self.transformerTeam = _team
        self.transformerName = _name
        self.strength = _strength
        self.intelligence = _intelligence
        self.speed = _speed
        self.endurance = _endurance
        self.rank = _rank
        self.courage = _courage
        self.firepower = _firepower
        self.skill = _skill
        self.teamIcon = _teamIcon
    }
}
