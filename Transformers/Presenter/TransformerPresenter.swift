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
    //var transformersOpt: [Transformer]?
    let model: ModelProtocol?
    var fightProtocol: FightProtocol?
    
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
        
        Center.addObserver(forName: MessageType.transformerListChanged.asNN, object: nil, queue: OperationQueue.main) {
            [weak self] (notification) in
            self?.updateView()
        }

    }
    
    
    func viewReady(){
        self.updateView()
       
    }
    
    func updateView(){
        if let transformerArray = self.model?.transformerArray{
            self.view?.setUpTransformers(transformers: transformerArray)
        }
    }
}

extension TransformerPresenter: TransformerViewOutput{
    
    
    
    func findFighters(for rank: Int)->(Transformer?, Transformer?)?{
//        guard let transformers = transformersOpt else{
//            return nil
//        }
//
//        let fighter1 = transformers.filter { (arg) -> Bool in
//            arg.rank == rank && arg.transformerTeam == .autobots
//        }.first
//
//        let fighter2 = transformers.filter { (arg) -> Bool in
//            arg.rank == rank && arg.transformerTeam == .decepticon
//        }.first
//
//        return (fighter1, fighter2)
        return(nil, nil)
    }
    
    func setUpFight(for rank: Int) {
        fightProtocol?.evaluateFighters {
            
        }
    }
    
    func addTransformer(transformer: Transformer){
        model?.addNewTransformer(transformer: transformer)
    }
    
    func generateTransformerPrototype()->Transformer?{
        return self.model?.generateTransformerPrototype()
    }
    
    func transformerCount()->Int{
        return self.model?.transformerArray.count ?? 0
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

