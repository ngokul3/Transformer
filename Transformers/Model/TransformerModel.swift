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
    func addNewTransformer(transformer: Transformer)
    func getTeamIcon(id: String,  completion: @escaping (Data?)->())
    var transformerArray: [Transformer]{get}
    
}


class TransformerModel:ModelProtocol {
    private var transformers = [Transformer]()
    private var network : NetworkProtocol?
    
    init(networkModel: NetworkProtocol){
        network = networkModel
        
        network?.getKey(finished: {(errorOpt) in
            if let _ = errorOpt{
                preconditionFailure("Not able to get key")
            }
        })
    }
    
    
    var transformerArray: [Transformer]{
        return transformers
    }
    
    
    func restorelocalFromDatabase()throws{
        transformers = try Persistence.restore()
    }
    
    func addNewTransformer(transformer: Transformer){
        network?.createNewTransformer(transformer: transformer, finished: {[weak self](arg1, arg2) in
            self?.getTransformers()
        })
    }
    
    func getTransformers(){
        network?.getTransformers(finished: { [weak self](dictionary, error) in
            
            if let _ = error{
                preconditionFailure("Could not fetch from web server")
            }
            guard let transformerArrayFromService = dictionary?["transformer"] as? [ [String: AnyObject] ] else {
                print("data format error: \(dictionary?.description ?? "[Missing dictionary]")")
                return
            }
            
            OperationQueue.main.addOperation {
                print("Passing restaurant results to main operation queue: \(Thread.current)")
                
                transformerArrayFromService.forEach({ (transformer) in
                    var teamImageURL: String = ""
                    
                    if let imageURL = transformer["team_icon"] as? String{
                        teamImageURL = imageURL //Not guarding. Image URL isn't important
                    }
                    
                    guard let name : String = transformer["name"] as? String else{
                        preconditionFailure("Name not found in JSON")
                    }
                    
                    guard let id : String = transformer["id"] as? String else{
                        preconditionFailure("Id not found in JSON")
                    }
                    
                    guard let strength : Int = transformer["strength"] as? Int else{
                        preconditionFailure("strength not found in JSON")
                    }
                    
                    guard let courage : Int = transformer["courage"] as? Int else{
                        preconditionFailure("courage not found in JSON")
                    }
                    
                    guard let skill : Int = transformer["skill"] as? Int else{
                        preconditionFailure("skill not found in JSON")
                    }
                    
                    guard let firePower : Int = transformer["firePower"] as? Int else{
                        preconditionFailure("firePower not found in JSON")
                    }
                    
                    guard let endurance : Int = transformer["endurance"] as? Int else{
                        preconditionFailure("endurance not found in JSON")
                    }
                    
                    guard let intelligence : Int = transformer["intelligence"] as? Int else{
                        preconditionFailure("endurance not found in JSON")
                    }
                    
                    guard let rank : Int = transformer["rank"] as? Int else{
                        preconditionFailure("rank not found in JSON")
                    }
                    
                    guard let speed : Int = transformer["speed"] as? Int else{
                        preconditionFailure("speed not found in JSON")
                    }
                    
                    let transformer = Transformer(id: id, team: .autobots, name: name, strength: strength, intelligence: intelligence, speed: speed, endurance: endurance, rank: rank, courage: courage, firepower: firePower, skill: skill, teamIcon: teamImageURL)
                    
                    self?.transformers.append(transformer)
                     
                    TransformerNotification.updateObservers(message: .transformerListChanged, data: nil)
                })
            }
        })
    }
    
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
