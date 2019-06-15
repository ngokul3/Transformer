//
//  Persistence.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class Persistence {
    
    static func delete(_ transformer: Transformer) throws{
        
        guard let alreadySavedData = UserDefaults.standard.data(forKey: "transformers") else{
            return
        }
        
        if let alreadySavedTransformers = NSKeyedUnarchiver.unarchiveObject(with: alreadySavedData) as? [Transformer] {
            if(alreadySavedTransformers.contains{$0.transformerId == transformer.transformerId}){
                let transformersSaved = alreadySavedTransformers.filter({($0.transformerId != transformer.transformerId)})
                let savedData = NSKeyedArchiver.archivedData(withRootObject: transformersSaved)
                UserDefaults.standard.set(savedData, forKey: "transformers")
            }
            else{
                throw TransformerError.notAbleToDelete(name: transformer.transformerName ?? "")
            }
        }
      //  transformer.isFavorite = false
    }
    
    static func save(_ transformer: Transformer) throws {
        var savedTransformers = [Transformer]()
        
        if let alreadySavedData = UserDefaults.standard.data(forKey: "transformers") {
            if let alreadySavedTransformers = NSKeyedUnarchiver.unarchiveObject(with: alreadySavedData) as? [Transformer] {
                alreadySavedTransformers.forEach {
                    savedTransformers.append($0)
                }
            }
        }
        
        if(savedTransformers.filter({$0.transformerId == transformer.transformerId}).count != 0){
            savedTransformers.forEach({(trans) in
                if(trans.transformerId == transformer.transformerId){
//                    rest.transformerName = transformer.transformerName
//                    rest.dateVisited = transformer.dateVisited
//                    rest.comments = transformer.comments
//                    rest.givenRating = transformer.givenRating
//                    rest.myRating = transformer.myRating
                }
            })
        }
        else{
            savedTransformers.append(transformer)
        }
        
        let savedData = NSKeyedArchiver.archivedData(withRootObject: savedTransformers)
        UserDefaults.standard.set(savedData, forKey: "transformers")
    }
    
    static func restore() throws -> [Transformer] {
        var savedTransformers = [Transformer]()
        
        guard let alreadySavedData = UserDefaults.standard.data(forKey: "transformers") else{
            return savedTransformers
        }
        
        if let alreadySavedTransformers = NSKeyedUnarchiver.unarchiveObject(with: alreadySavedData) as? [Transformer] {
            savedTransformers = alreadySavedTransformers
        }
        
        return savedTransformers
    }
}

