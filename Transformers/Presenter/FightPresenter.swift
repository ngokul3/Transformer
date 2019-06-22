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
    let model: FightModelProtocol?
    var fightProtocol: FightProtocol?
    
    init(model: FightModelProtocol) {
        self.model = model
        self.model?.restoreTransformers()
    }
    func viewReady(){
        self.updateView()
    }
    
    func updateView(){
        if let _ = self.model?.transformerArray{
            self.view?.prepForFight()
        }
    }
}


extension FightPresenter: FightViewOutput
{
    func startFight() {
        
    }
}
