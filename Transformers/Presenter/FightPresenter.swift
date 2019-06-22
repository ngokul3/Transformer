//
//  FightPresenter.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/22/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class FightPresenter{
    var view: FightViewInput?
    let model: ModelProtocol?
    var fightProtocol: FightProtocol?
    var fightSetArray = [FighterSetUp]()
    
    init(model: ModelProtocol) {
        self.model = model
    }
    
    func viewReady(view: FightViewInput){
        self.view = view
    }
    
    
    func updateView(){
        if let t = self.model?.transformerArray{
            let rankSet = ranksAvailable(transformers: t)
            
            self.fightSetArray.removeAll()
            
            for rank in rankSet{
                
            let fighters = findFighters(for: rank, transformers: t)
                self.fightSetArray.append(fighters)
            }
            
            let restoffighters = t.filter { (trans) -> Bool in
                let s = self.fightSetArray.contains(where: { (arg) -> Bool in
                    return ((arg.fighter1?.transformerId == trans.transformerId ||
                            arg.fighter2?.transformerId == trans.transformerId))
                })

                return !s
            }
            
            let restFightArray = restoffighters.map { (fighter) -> FighterSetUp in
                return FighterSetUp(fighter1: fighter, fighter2: nil, rank: fighter.rank)
            }
            
            self.fightSetArray.append(contentsOf: restFightArray)
            self.view?.prepForFight()
        }
    }
    
}


extension FightPresenter: FightViewOutput
{
    func ranksAvailable(transformers: [Transformer])->Set<Int>{
        var rankSet = Set<Int>()
        
        transformers.forEach { (arg)  in
            rankSet.insert(arg.rank ?? 1)
        }
        
        return rankSet
    }
    
    func findFighters(for rank: Int,  transformers: [Transformer])->FighterSetUp{
        
        let fighter1 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .autobots
        }.first

        fighter1?.state = .Died
        
        let fighter2 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .decepticon
        }.first
        
        
        let fighterSetUp = FighterSetUp(fighter1:fighter1, fighter2: fighter2, rank: rank )
        return fighterSetUp
        
    }
    
    func fightAtIndex(index: Int)->FighterSetUp?{
        if(self.fightSetArray.count > index){
            return (self.fightSetArray[index])
        }
        else{
            return nil
        }
    }
    
    func startFight() {
        for fightSet in self.fightSetArray{
            if var fighter1 = fightSet.fighter1,
                var fighter2 = fightSet.fighter2{
                let fight = Fight(fighter1: fighter1, fighter2: fighter2)
                fight.evaluateFighters {
                    fighter1 = fight.fighter1
                    fighter2 = fight.fighter2
                }
            }
        }
    }
}
