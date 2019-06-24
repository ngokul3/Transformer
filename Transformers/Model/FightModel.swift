////
////  FightModel.swift
////  Transformers
////
////  Created by Gokula K Narasimhan on 6/22/19.
////  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
////
//
//import Foundation


struct FighterSetUp{
    var fighter1: Transformer?
    var fighter2: Transformer?
    var rank: Int?
    
    var isBothDead: Bool{
        return ((fighter1?.state?.isAlive ?? false == false) &&
                ((fighter2?.state?.isAlive ?? false == false))
                )
    }
    
    var fightDesc : String {
        let fighter1Name = fighter1?.transformerName ?? ""
        let fighter2Name = fighter2?.transformerName ?? ""
        
        if (fighter1Name.count != 0 && fighter2Name.count != 0){
            return "Rank \(rank ?? 0): \(fighter1Name) Vs \(fighter2Name)"
        }
        else if (fighter1Name.count == 0 && fighter2Name.count != 0){
            return "Rank \(rank ?? 0): \(fighter2Name)"
        }
        else if (fighter2Name.count == 0 && fighter1Name.count != 0){
            return "Rank \(rank ?? 0): \(fighter1Name)"
        }else{
            return "No fighters Alive for this rank"
        }
    }
    
    var resultDesc: String{
        let fighter1State = fighter1?.state ?? TransformerState.Empty
        let fighter2State = fighter2?.state ?? TransformerState.Empty
        
        switch (fighter1State, fighter2State) {
        case (.Died, .Empty),(.Empty, .Died) :
            return "Dead"
        case (.Alive, .Empty), (.Empty, .Alive):
            return "Alive"
        case (_, .Empty), (.Empty, _):
            return "Not fighting"
        case (.Born, .Born):
            return "Ready"
        default:
            return "Both Alive"
        }
    }
    
   
}
