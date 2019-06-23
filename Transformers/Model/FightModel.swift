////
////  FightModel.swift
////  Transformers
////
////  Created by Gokula K Narasimhan on 6/22/19.
////  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
////
//
//import Foundation

struct TeamStatistics: TeamStatisticsDataSource {
    var team: Team
    var aliveCount: Int
    var diedCount: Int
    func reset() {
        
    }
}


struct FighterSetUp{
    var fighter1: Transformer?
    var fighter2: Transformer?
    var rank: Int?
    
    
    var fightDesc : String {
        let fighter1Name = fighter1?.transformerName ?? ""
        let fighter2Name = fighter2?.transformerName ?? ""
        
        if (fighter1Name.count != 0 && fighter2Name.count != 0){
            return "\(fighter1Name) Vs \(fighter2Name)"
        }
        else if (fighter1Name.count == 0 && fighter2Name.count != 0){
            return "\(fighter2Name)"
        }
        else if (fighter2Name.count == 0 && fighter1Name.count != 0){
            return "\(fighter1Name)"
        }else{
            return "No fighters Alive for this rank"
        }
    }
    
    var resultDesc: String{
        let fighter1State = fighter1?.state ?? TransformerState.Empty
        let fighter2State = fighter2?.state ?? TransformerState.Empty
        
        switch (fighter1State, fighter2State) {
        case (.Died, .Alive):
            return "\(fighter2?.transformerName ?? "") Win"
        case (.Alive, .Died):
            return "\(fighter1?.transformerName ?? "") Win"
        case (.Died, .Died):
            return "Both dead"
        case (_, .Empty), (.Empty, _):
            return "Not fighting"
        case (.Born, .Born):
            return "Not fought yet"
        default:
            return "Both Alive"
        }
       
        
    }
}
