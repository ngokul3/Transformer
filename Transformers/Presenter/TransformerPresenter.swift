//
//  TransformerPresenter.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/17/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class TransformerPresenter{
    var view: TransformerViewInput?
    var transformersOpt: [Transformer]?
    
    var fightProtocol: FightProtocol?
    
    init() {
       
    }
    
    
    func viewReady(){
        
    }
}

extension TransformerPresenter: TransformerViewOutput{
    
    func findFighters(for rank: Int)->(Transformer?, Transformer?)?{
        guard let transformers = transformersOpt else{
            return nil
        }
        
        let fighter1 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .autobots
        }.first
        
        let fighter2 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .decepticon
        }.first
        
        return (fighter1, fighter2)
    }
    
    func setUpFight(for rank: Int) {
        fightProtocol?.evaluateFighters {
            
        }
    }
}
