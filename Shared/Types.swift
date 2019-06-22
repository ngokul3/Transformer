//
//  Types.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

enum Team: String {
    case autobots = "A"
    case decepticon = "D"
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
    case notAbleToGetKey
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



enum DetailVCType : String{
    case Add
    case Edit
}



struct TeamStatistics: TeamStatisticsDataSource {
    var team: Team
    var aliveCount: Int
    var diedCount: Int
    func reset() {
        
    }
}


struct FighterSetUp{
    var fighter1: Transformer?
    var fighter2: Transformer?
    var rank: Int?
    
    
    var fightDesc : String {
        let fighter1Name = fighter1?.transformerName ?? ""
        let fighter2Name = fighter2?.transformerName ?? ""
        
        if (fighter1Name.count != 0 && fighter2Name.count != 0){
            return "Rank \(rank ?? 1) - \(fighter1Name) Vs \(fighter2Name)"
        }
        else if (fighter1Name.count == 0 && fighter2Name.count != 0){
            return "Rank \(rank ?? 1) - \(fighter2Name)"
        }
        else if (fighter2Name.count == 0 && fighter1Name.count != 0){
            return "Rank \(rank ?? 1) - \(fighter1Name)"
        }else{
            return "Rank \(rank ?? 1) - No fighters"
        }
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
    func setUpTransformers()
    
}

protocol FightViewInput{
    func prepForFight()
    func displayStatistics(statistics: TeamStatisticsDataSource)
    
}

protocol TransformerViewOutput {
    func viewReady(view: TransformerViewInput)
    //func findFighters(for rank: Int)->(Transformer?, Transformer?)?
    func setUpFight(for rank: Int)
    func transformerInContext(transformer: Transformer, opType: DetailVCType, errorMsg: @escaping (Error?)->Void)
    func generateTransformerPrototype()->Transformer?
    func transformerCount()->Int
    func transformerAtIndex(index: Int)->Transformer?
    func getTeamIcon(id: String, completion: @escaping (Data?)->())
}

protocol FightViewOutput{
    func viewReady(view: FightViewInput)
    var fightSetArray : [FighterSetUp]{get}
    func updateView()
    func ranksAvailable(transformers: [Transformer])->Set<Int>
    func startFight()
    func fightAtIndex(index: Int)->FighterSetUp?
}

protocol CollectionDataProvider{
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func addTransformer(transformerOpt: Transformer?) throws
    func editTransformer(transformer: Transformer) throws
    func deleteTransformer(transformer: Transformer) throws
   
}


