//
//  Types.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

enum TransformerError: Error{
    case invalidTransformer
    case invalidRowSelection
    case zeroCount
    case notAbleToPopulateTransformers
    case notAbleToAdd(name : String)
    case notAbleToEdit(name: String)
    case notAbleToDelete(name: String)
    case notAbleToSave(name: String)
    case notAbleToRestore
    case notAbleToCreateEmptyTransformer
}


enum TransformerState: Int {
    case Alive
    case Died
    case Born
    case Empty
    
    var isAlive: Bool {
        return self == .Alive || self == .Born
    }
}

struct Messages {
    static let TransformerReadyToBeSaved = "Transformer Ready To be Saved"
    static let TransformerListChanged = "Transformer List changed"
    static let TransformerDeleted = "Transformer Deleted"
//    static let RestaurantCanBeRemovedFromFavorite = "Restaurant can be Deleted from Saved list"
//    static let ImageArrived = "Image arrived"
    
}

struct Consts{
    static let KEY0 = "Key0"

}

protocol TeamStatisticsDataSource {
    var team: Team {get set}
    var aliveCount: Int { get }
    var diedCount: Int { get }
  //  mutating func reset()
    //var stasis: Bool { get }
}


protocol FightDataSource: class{
    func findOpponentFor(_ transformer1: Int)-> Transformer?
    func startFighting(fightOver: ()->Void)
    func reset()
    var statistics: [TeamStatisticsDataSource]? { get }
    var fighters: [Transformer]? {get set}
   
}
