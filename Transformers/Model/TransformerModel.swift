//
//  TransformerModel.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/18/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation
class TransformerModel{
    var transformerArray = [Transformer]()
    var network: NetworkProtocol?
    
    func addNewTransformer(transformer: Transformer){
        network?.createNewTransformer(transformer: transformer, finished: {(arg1, arg2) in
            
        })
    }
    
    func getTransformers()->[Transformer]{
        return transformerArray
    }
    
}
