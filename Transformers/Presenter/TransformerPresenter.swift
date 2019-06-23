//
//  TransformerPresenter.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/17/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class TransformerPresenter{
    var view: TransformerViewInput?
    let model: ModelProtocol?
    var fightProtocol: FightProtocol?
      var filterBy : String?
    init(model: ModelProtocol) {
       self.model = model
        do{
            try self.model?.restorelocalFromDatabase()
        }
        catch(TransformerError.notAbleToRestore){
            // Perform custom action
        }
        
        catch{
            // Perform custom action
        }
    }
    
    func viewReady(view: TransformerViewInput){
        self.view = view
     }
    
    func updateView(){
        if let _ = self.model?.transformerArray{
            self.view?.setUpTransformers()
        }
    }
}

extension TransformerPresenter: TransformerViewOutput{
    var filterCriteria: String {
        get {
            return filterBy ?? "All"
        }
        set {
            filterBy = newValue
        }
    }
    
    func setUpFight(for rank: Int) {
        fightProtocol?.evaluateFighters {
            
        }
    }
    
    func transformerInContext(transformer: Transformer, opType: DetailVCType, errorMsg: @escaping (Error?)->Void){
        model?.handleTransformer(transformer: transformer, opType: opType, errorMsg: errorMsg)
    }
    
    func generateTransformerPrototype()->Transformer?{
        return self.model?.generateTransformerPrototype()
    }
    
    func transformerCount()->Int{
        return self.model?.transformerArray.count ?? 0
//        switch self.filterBy{
//        case "All":
//            return self.model?.transformerArray.count ?? 0
//        case "Autobots":
//            let autobotsArray = self.model?.transformerArray.filter{($0.transformerTeam ?? Team.autobots) == .autobots}
//            return autobotsArray?.transformerArray.count ?? 0
//        case "Decepticons":
//            let decepticonsArray = self.model?.transformerArray.filter{($0.transformerTeam ?? Team.autobots) == .decepticons}
//            return decepticonsArray?.transformerArray.count ?? 0
//        default: break
//        }
        
    }
    
    
    func transformerAtIndex(index: Int)->Transformer?{
        if(self.model?.transformerArray.count ?? 0 > index){
            return (self.model?.transformerArray[index])
        }
        
        return nil
    }
    
    func getTeamIcon(id: String, completion: @escaping (Data?)->()){
        self.model?.getTeamIcon(id: id, completion: { (data) in
             completion(data)
            
        })
    }
}

