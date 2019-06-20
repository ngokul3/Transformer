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
    let model: ModelProtocol?
    var fightProtocol: FightProtocol?
    
    init(model: ModelProtocol) {
       self.model = model
    }
    
    
    func viewReady(){
        self.updateView()
       // let transformerArray = self.model
    }
    
    func updateView(){
        if let transformerArray = self.model?.getTransformers(){
            self.view?.setUpTransformers(transformers: transformerArray)
        }
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
    
    func addTransformer(transformer: Transformer){
        model?.addNewTransformer(transformer: transformer)
    }
    
    func generateTransformerPrototype()->Transformer?{
        return self.model?.generateTransformerPrototype()
    }
}
