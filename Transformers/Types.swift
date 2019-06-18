//
//  Types.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

enum Team {
    case autobots
    case decepticon
}

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

enum MessageType: String{
    case evaluatedByStrength = "Strength rule"
    case evaluatedByCourage = "Courage rule"
    case evaluatedBySkill = "Skill rule"
    case evaluatedByRank = "Rank rule"
    case evaluatedByRating = "Rating rule"
    case evaluatedByName = "Name rule"
    case winnerFound = "Winner among Transformer"
    case bothDead = "Both Transformers are dead"
    case gameOver = "All Transformers are dead"
    
    var asNN: Notification.Name {
        return Notification.Name(self.rawValue)
    }
    var asNotification: Notification {
        return Notification(name: asNN)
    }
}
struct Messages{
    static let TransformerReadyToBeSaved = "Transformer Ready To be Saved"
    static let TransformerListChanged = "Transformer List changed"
    static let TransformerDeleted = "Transformer Deleted"
    
//    static let RestaurantCanBeRemovedFromFavorite = "Restaurant can be Deleted from Saved list"
//    static let ImageArrived = "Image arrived"
    
}

struct TeamStatistics: TeamStatisticsDataSource {
    var team: Team
    var aliveCount: Int
    var diedCount: Int
    func reset() {
        
    }
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


//protocol FightProtocol: class{
//   // func findOpponentFor(_ transformer1: Int)-> Transformer?
//    func startFighting(rank: Int, fightOver: ()->Void)
//    func reset()
//    var statistics: [TeamStatisticsDataSource]? { get }
//    var fighters: [Transformer] {get set}
//}

protocol FightProtocol: class{
    func evaluateFighters(evaluationComplete : ()->Void)
}

protocol TransformerViewInput{
    func setUpTransformers(transformers: [Transformer])
    func displayStatistics(statistics: TeamStatisticsDataSource)
}

protocol TransformerViewOutput {
    func findFighters(for rank: Int)->(Transformer?, Transformer?)?
    func setUpFight(for rank: Int)
    
}

protocol CollectionDataProvider{
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func addTransformer(transformerOpt: Transformer?) throws
    func editTransformer(transformer: Transformer) throws
    func deleteTransformer(transformer: Transformer) throws
   
}
