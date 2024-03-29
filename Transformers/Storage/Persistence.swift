//
//  Persistence.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class Persistence {
    
    static func save(_ transformer: Transformer) throws {
        var savedTransformers = [Transformer]()
        if let alreadySavedData = UserDefaults.standard.data(forKey: NSKeyedArchiveRootObjectKey) {
            if let alreadySavedTransformers = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(alreadySavedData) as? [Transformer] {
                alreadySavedTransformers.forEach {
                    savedTransformers.append($0)
                }
            }
        }
        
        if(savedTransformers.filter({$0.transformerId == transformer.transformerId}).count != 0){
            savedTransformers.forEach({(trans) in
                if(trans.transformerId == transformer.transformerId){
                    trans.transformerName = transformer.transformerName
                    trans.courage = transformer.courage
                    trans.strength = transformer.strength
                    trans.skill = transformer.skill
                    trans.rank = transformer.rank
                    trans.firepower = transformer.firepower
                    trans.endurance = transformer.endurance
                    trans.intelligence = transformer.intelligence
                    trans.transformerTeam = transformer.transformerTeam
                    trans.teamIcon = transformer.teamIcon
                    trans.state = transformer.state
                }
            })
        }
        else{
            savedTransformers.append(transformer)
        }
        
        let savedData = try NSKeyedArchiver.archivedData(withRootObject: savedTransformers, requiringSecureCoding: true)
        UserDefaults.standard.set(savedData, forKey: NSKeyedArchiveRootObjectKey)
    }
    
    static func restore() throws -> [Transformer] {
        var savedTransformers = [Transformer]()
        
        guard let alreadySavedData = UserDefaults.standard.data(forKey: NSKeyedArchiveRootObjectKey) else{
            return savedTransformers
        }
        if let alreadySavedTransformers = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(alreadySavedData) as? [Transformer] {
            savedTransformers = alreadySavedTransformers
        }
        return savedTransformers
    }
}

