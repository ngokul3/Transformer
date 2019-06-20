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
        network?.getTransformers(finished: { [weak self](dictionary, error) in
            print(dictionary)
//            guard let transformerArray = dictionary?["businesses"] as? [ [String: AnyObject] ] else {
//                print("data format error: \(dictionary?.description ?? "[Missing dictionary]")")
//                return
//            }
        })
        return transformerArray
    }
    
    func generateTransformerPrototype()->Transformer{
        return Transformer(id: -1, team: .autobots, name: "", strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1, teamIcon: "")
    }
}
