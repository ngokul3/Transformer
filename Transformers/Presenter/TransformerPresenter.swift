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
    var model: ModelProtocol?
    
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
   
  
    func transformerInContext(transformer: Transformer, opType: DetailVCType, errorMsg: @escaping (Error?)->Void){
        model?.handleTransformer(transformer: transformer, opType: opType, errorMsg: errorMsg)
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

