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
    var stats: FightStatisticsDataSource
    var blocks: [DispatchWorkItem] = []
    let fightGroup = DispatchGroup()
    
    init(model: ModelProtocol) {
        self.model = model
        self.stats = FightStatistics()
    }
    
    func viewReady(view: FightViewInput){
        self.view = view
    }
    
    
    func updateView(){
      
        if let t = self.model?.transformerArray{
            let rankSet = ranksAvailable(transformers: t)
            
            self.fightSetArray.removeAll()
            var setId = Set<String>()
            
            for rank in rankSet{
                let fighters = findFighters(for: rank, transformers: t)
                    if !fighters.isBothDead{
                        self.fightSetArray.append(fighters)
                        setId.insert(fighters.fighter1?.transformerId ?? "0")
                        setId.insert(fighters.fighter2?.transformerId ?? "0")
                    }
            }
            
            let restoffighters = t.filter { (trans) -> Bool in
                let s = setId.contains(trans.transformerId ?? "0")
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
    var statistics: FightStatisticsDataSource {
        return stats
    }
    
    func ranksAvailable(transformers: [Transformer])->Set<Int>{
        var rankSet = Set<Int>()
        
        transformers.forEach { (arg)  in
            rankSet.insert(arg.rank ?? 1)
        }
        
        return rankSet
    }
    
    func findFighters(for rank: Int,  transformers: [Transformer])->FighterSetUp{
        
        let fighter1 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .autobots && (arg.state?.isAlive ?? false)
        }.first

        let fighter2 = transformers.filter { (arg) -> Bool in
            arg.rank == rank && arg.transformerTeam == .decepticon && (arg.state?.isAlive ?? false)
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
    
    func gameOver(){
        OperationQueue.main.addOperation {
            self.model?.transformerArray.forEach({ (transformer) in
                transformer.state = .Died
                self.model?.handleTransformer(transformer: transformer, opType: .Result, errorMsg: {(error) in
                    if let e = error{
                        print(e)
                        //Custom handle
                    }else{
                        // TransformerNotification.updateObservers(message: .gameOver, data: self?.stats)
                    }
                })
            })
        }
     
    }
    
    
    func startFight() {
        blocks = [DispatchWorkItem]()
        
        for fightSet in self.fightSetArray{
            let block = DispatchWorkItem(flags: .inheritQoS) {
                if var fighter1 = fightSet.fighter1,
                    var fighter2 = fightSet.fighter2{
                    let fight = Fight(fighter1: fighter1, fighter2: fighter2, delegate: self)
                    
                    self.stats.battleNo += 1
                    
                    fight.evaluateFighters { (evaluationMethod) in
                        fighter1 = fight.fighter1
                        fighter2 = fight.fighter2
                        
                        self.stats.fighter1 = fighter1
                        self.stats.fighter2 = fighter2
                        
                        self.stats.winningTeam = fight.fightResult
                        
                        [fighter1, fighter2].forEach({ (transformer) in
                            self.model?.handleTransformer(transformer: transformer, opType: .Result, errorMsg: { (error) in
                                if let e = error{
                                    print(e)
                                    //Custom handle
                                }
                            })
                        })
                        
                        TransformerNotification.updateObservers(message: .fightDone, data: self.stats)
                        
                    }
                }
            }
            blocks.append(block)
            DispatchQueue.main.async(execute: block)
        }
    }

}


extension FightPresenter: FightCompleteDelegate{
    func fightOverBecauseOfNames() {
        for block in blocks[1..<blocks.count] {
            block.cancel()
        }
        gameOver()
    }
    
    
}
