//
//  TransformerModel.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/18/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

protocol ModelProtocol{
    func restorelocalFromDatabase()throws
    func generateTransformerPrototype()->Transformer
    func handleTransformer(transformer: Transformer, opType: DetailVCType , errorMsg: @escaping (Error?)->Void)
    func getTeamIcon(id: String,  completion: @escaping (Data?)->())
    var transformerArray: [Transformer]{get}
}

class TransformerModel:ModelProtocol {
    private var transformers = [Transformer]()
    private var network : NetworkProtocol?
    private var opQueue: DispatchQueue?
    private var idSet = Set<String>()
    
    init(networkModel: NetworkProtocol, queue: DispatchQueue){
        network = networkModel
        opQueue = queue
        
        enqueue {
            print("Thread for getting key \(Thread.current)")
            self.network?.getKey(finished: {(errorOpt) in
                if let _ = errorOpt{
                    preconditionFailure("Not able to get key")
                }else{
                    self.network?.getTransformersFromNetwork(finished: {[weak self] (dictionary, errorMsg) in
                        guard let transformerArray = dictionary?["transformers"] as? [ [String: AnyObject] ] else {
                            print("data format error: \(dictionary?.description ?? "[Missing dictionary]")")
                            return
                        }
                        
                        transformerArray.forEach { (arg) in
                            if let id = arg["id"] as? String{
                                self?.idSet.insert(id)
                            }
                        }
                    })
                }
            })
        }
    }
    
    var transformerArray: [Transformer]{
        return transformers
    }
    
    func enqueue(modelOp: @escaping () -> Void) {
        opQueue?.async(execute: modelOp)
    }
    
    func restorelocalFromDatabase(){
        enqueue {
            do{
                print("Thread for restoring \(Thread.current)")
                self.transformers = try Persistence.restore().sorted(by: { (arg1, arg2) -> Bool in
                    arg1.rank ?? 0 < arg2.rank ?? 0
                    
                })
                TransformerNotification.updateObservers(message: .transformerListChanged, data: nil)
            }
            catch (let error){
                print(error)
                //Custom handle exception
            }
        }
    }
    
    func handleTransformer(transformer: Transformer, opType: DetailVCType, errorMsg: @escaping (Error?)->Void){
        
        if(opType == .Result || !(idSet.contains(transformer.transformerId ?? ""))){
            do{
                try Persistence.save(transformer)
                self.restorelocalFromDatabase()
            }
            catch let error{
                errorMsg(error)
            }
            
            errorMsg(nil)
            return
        }
        
        network?.persistTransformer(transformer: transformer, opType: opType, finished: {[weak self](dictionary, error) in
            if let _ = error{
                errorMsg(error)
             }
            
            guard let transformerDict = dictionary as?  [String: Any]  else {
                print("data format error: \(dictionary?.description ?? "[Missing dictionary]")")
                return
            }
            self?.enqueue {
                if let transformerObject = self?.returnTransformerObjectFromDict(transformerDict: transformerDict){
                    do{
                        try Persistence.save(transformerObject)
                        self?.restorelocalFromDatabase()
                    }
                    catch let error{
                        print(error)
                    }
                }
            }
            
        })
    }
    
    
    func returnTransformerObjectFromDict(transformerDict: [String: Any])->Transformer{
        var teamImageURL: String = ""
        
        if let imageURL = transformerDict["team_icon"] as? String{
            teamImageURL = imageURL //Not guarding. Image URL isn't important
        }
        
        guard let name : String = transformerDict["name"] as? String else{
            preconditionFailure("Name not found in JSON")
        }
        
        guard let id : String = transformerDict["id"] as? String else{
            preconditionFailure("Id not found in JSON")
        }
        
        guard let strength : Int = transformerDict["strength"] as? Int else{
            preconditionFailure("strength not found in JSON")
        }
        
        guard let courage : Int = transformerDict["courage"] as? Int else{
            preconditionFailure("courage not found in JSON")
        }
        
        guard let skill : Int = transformerDict["skill"] as? Int else{
            preconditionFailure("skill not found in JSON")
        }
        
        guard let firepower : Int = transformerDict["firepower"] as? Int else{
            preconditionFailure("firePower not found in JSON")
        }
        
        guard let endurance : Int = transformerDict["endurance"] as? Int else{
            preconditionFailure("endurance not found in JSON")
        }
        
        guard let intelligence : Int = transformerDict["intelligence"] as? Int else{
            preconditionFailure("endurance not found in JSON")
        }
        
        guard let rank : Int = transformerDict["rank"] as? Int else{
            preconditionFailure("rank not found in JSON")
        }
        
        guard let speed : Int = transformerDict["speed"] as? Int else{
            preconditionFailure("speed not found in JSON")
        }
        
        
        guard let teamName = transformerDict["team"] as? String,
                let team = Team(rawValue: teamName)
            else{
            preconditionFailure("team not found in JSON")
        }
        
        
        let transformer = Transformer(id: id, team: team, name: name, strength: strength, intelligence: intelligence, speed: speed, endurance: endurance, rank: rank, courage: courage, firepower: firepower, skill: skill, teamIcon: teamImageURL)
        
        return transformer
        
    }
//
//    func getTransformers(){
//        network?.getTransformers(finished: { [weak self](dictionary, error) in
//
//            if let _ = error{
//                preconditionFailure("Could not fetch from web server")
//            }
//            guard let transformerArrayFromService = dictionary?["transformers"] as? [ [String: AnyObject] ] else {
//                print("data format error: \(dictionary?.description ?? "[Missing dictionary]")")
//                return
//            }
//
//           // OperationQueue.main.addOperation {
//                transformerArrayFromService.forEach({ (transformerDict) in
//
//                   let _ = self?.returnTransformerObjectFromDict(transformerDict: transformerDict)
//                    //self?.transformers.append(transformer)
//
//                    TransformerNotification.updateObservers(message: .transformerListChanged, data: nil)
//                })
//           // }
//        })
//    }
    
    func generateTransformerPrototype()->Transformer{
        return Transformer(id: "-1", team: .autobots, name: "", strength: 1, intelligence: 1, speed: 1, endurance: 1, rank: 1, courage: 1, firepower: 1, skill: 1, teamIcon: "")
    }
    
    func getTeamIcon(id: String,  completion: @escaping (Data?)->()){
        let transformer = self.transformerArray.filter { (arg) -> Bool in
            arg.transformerId == id
        }.first
        
        if let iconURL = transformer?.teamIcon{
            network?.getTeamImage(forTeamIconURL: iconURL, imageLoaded: { (data, responseOpt, error) in
                if let e = error {
                    print("Error downloading icon: \(e)")
                    //Take custom actions
                }else{
                    if let response = responseOpt {
                        
                        if let imageData = data {
                            completion(imageData)
                        }
                        else {
                            print(response)
                            completion(nil)
                        }
                    }
                    else {
                        print(error.debugDescription)
                        completion(nil)
                    }
                }
            })
        }
    }
}
