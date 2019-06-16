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

class ModelManager{
    var transformerArray: [Transformer]
    
    init() {
        transformerArray = [Transformer]()
    }
    
    func addTransformer(transformerOpt: Transformer?) throws{
        
        guard let transformer =  transformerOpt else{
            throw TransformerError.invalidTransformer
        }
        
        transformerArray.append(transformer)
        //transformerArray.sort(by: <#T##(Transformer, Transformer) throws -> Bool#>)
        
        let nsNotification = NSNotification(name: NSNotification.Name(rawValue: Messages.TransformerReadyToBeSaved), object: nil)
        NotificationCenter.default.post(name: nsNotification.name, object: nil, userInfo:[Consts.KEY0: transformer])
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.TransformerListChanged), object: self))
    }
    
    func restoreTransformers(transformers : [Transformer]){
        transformerArray = transformers
    }
    
    func editTransformer(transformer: Transformer) throws{
        
        guard transformerArray.contains(transformer) else{
            throw TransformerError.notAbleToEdit(name: transformer.transformerName ?? "")
        }
        
        let nsNotification = NSNotification(name: NSNotification.Name(rawValue: Messages.TransformerReadyToBeSaved), object: nil)
        NotificationCenter.default.post(name: nsNotification.name, object: nil, userInfo:[Consts.KEY0: transformer])
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.TransformerListChanged), object: self))
    }
    
    func deleteRestaurantFromFavorite(transformer: Transformer) throws{
        
        if(transformerArray.contains{$0.transformerId == transformer.transformerId}){
            transformerArray = transformerArray.filter({($0.transformerId != transformer.transformerId)})
        }
        else{
            throw TransformerError.notAbleToDelete(name: transformer.transformerName ?? "")
        }
        
         let nsNotification1 = NSNotification(name: NSNotification.Name(rawValue: Messages.TransformerDeleted), object: nil)
        
        NotificationCenter.default.post(name: nsNotification1.name, object: nil, userInfo:[Consts.KEY0: transformer])
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.TransformerListChanged), object: self))
    }
    
}


struct TeamStatistics: TeamStatisticsDataSource {
    var team: Team
    var aliveCount: Int
    var diedCount: Int
    func reset() {
        
    }
}

class FightModel: FightDataSource{
    var fighters: [Transformer]?
    var statistics: [TeamStatisticsDataSource]?
    var currentFighters: [Transformer]?
    
    init(fighters: [Transformer]){
        self.fighters = fighters
        // initialize statistics for both the teams
    }
}

extension FightModel{
    func findOpponentFor(_ transformer1: Int) -> Transformer? {
        //Sort the fighters by rank -- This should be already done when transfer is created and added. SHould not be doen here
        //Get Transformer from the int.
        //Get the opponent Tramsformer from the other group based on the rank
        //populate currentFighters array with these 2 fighters
        return nil
    }
    
    func startFighting(fightOver: ()->Void) {
        //Start the fight between fighters in current fighters
        //Use rules to determine the winner
        //update the statistics array
        fightOver()
    }
    
    func reset() {
        
    }
}
