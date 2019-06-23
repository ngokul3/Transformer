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


enum TransformerState: String {
    case Alive = "Alive"
    case Died = "Died"
    case Born = "Born"
    case Empty = "Empty"
    
    var isAlive: Bool {
        return self == .Alive || self == .Born
    }
}

enum DetailVCType : String{
    case Add
    case Edit
    case Result
}

struct Consts{
    static let KEY0 = "Key0"

}

protocol TeamStatisticsDataSource {
    var team: Team {get set}
    var aliveCount: Int { get }
    var diedCount: Int { get }

}


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
    //func setUpFight(for rank: Int)
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
