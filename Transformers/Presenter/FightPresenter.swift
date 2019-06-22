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
    
    init(model: ModelProtocol) {
        self.model = model
    }
    
    func viewReady(){
        self.updateView()
    }
    
    func updateView(){
        if let t = self.model?.transformerArray{
            print(t.count)
            let rankSet = ranksAvailable(transformers: t)
            var fightSetArray = [FighterSetUp]()
            for rank in rankSet{
                let fighters = findFighters(for: rank, transformers: t)
                fightSetArray.append(fighters)
            }
            self.view?.prepForFight(fightSetUpArray: fightSetArray)
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
    
    func findFighters(for rank: Int, transformers: [Transformer])->FighterSetUp{
        
        let fighter1 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .autobots
        }.first

        let fighter2 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .decepticon
        }.first
        
        let fighterSetUp = FighterSetUp(fighter1:fighter1, fighter2: fighter2, rank: rank )
        return fighterSetUp
        
    }
    
    func startFight() {
        
    }
}
