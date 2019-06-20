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
        return Transformer(id: -1, team: .autobots, name: "", strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1, teamIcon: "")
    }
}
