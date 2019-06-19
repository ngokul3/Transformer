//
//  TransformerModel.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/18/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

protocol ModelProtocol{
    func generateTransformerPrototype()->Transformer
    func addNewTransformer(transformer: Transformer)
    func getTransformers()->[Transformer]
}


class TransformerModel:ModelProtocol {
    var transformerArray = [Transformer]()
    private var network : NetworkProtocol?
    
    init(networkModel: NetworkProtocol){
        network = networkModel
    }
    
    func addNewTransformer(transformer: Transformer){
        network?.createNewTransformer(transformer: transformer, finished: {(arg1, arg2) in
            
        })
    }
    
    func getTransformers()->[Transformer]{
        return transformerArray
    }
    
    func generateTransformerPrototype()->Transformer{
        return Transformer(id: -1, team: .autobots, name: "", strength: 0, intelligence: 0, speed: 0, endurance: 0, rank: 0, courage: 0, firepower: 0, skill: 0, teamIcon: "")
    }
}
