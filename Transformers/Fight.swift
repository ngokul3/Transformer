//
//  Fight.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/16/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation


class Fight: FightProtocol{
    var fighters: [Transformer]
    var statistics: [TeamStatisticsDataSource]?
    
   // var currentFighters: [Transformer]?
    
    init(fighters: [Transformer]){
        self.fighters = fighters
        // initialize statistics for both the teams
    }
}

extension Fight{
    func findOpponentFor(_ rank: Int) -> Transformer? {
        //Sort the fighters by rank -- This should be already done when transfer is created and added. SHould not be doen here
        //Get Transformer from the int.
        //Get the opponent Tramsformer from the other group based on the rank
        //populate currentFighters array with these 2 fighters
        return nil
    }
    
    func startFighting(rank: Int, fightOver: ()->Void) {
        
        let fighterRequestingFight = fighters.filter { (transformer) -> Bool in
            transformer.rank == rank
        }
        let opponentFighterOpt = self.findOpponentFor(rank)
        if let opponentFighter = opponentFighterOpt{
            
        }
        //Start the fight between fighters in current fighters
        //Use rules to determine the winner
        //update the statistics array
        fightOver()
    }
    
    func reset() {
        
    }
}
