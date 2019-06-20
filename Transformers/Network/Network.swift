
//
//  Network.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
    static func getInstance() -> NetworkProtocol
    func getTransformers(finished: @escaping (_ dataDict: NSDictionary?, _ errorMsg: String?)  -> ())
    func createNewTransformer(transformer: Transformer, finished: @escaping(_ response: String? , _ errorMsg: String?) -> ())
}

class NetworkModel: NetworkProtocol{
    
    private var baseURLOpt : String?
    private var transitJSONFileNameOpt : String?
    private var searchDistanceLimitOpt: Int?
    private static var instance: NetworkProtocol?
    
    var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    var apiKey: String?
    
    lazy var httpURL: String = {
        return (self.baseURLOpt ?? "") + "transformers"
    }()
    
    init()
    {
       
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRootOpt = NSDictionary(contentsOfFile: path)
            
            guard let dict = dictRootOpt else{
                preconditionFailure("Transformer API URL is not available")
            }
            self.baseURLOpt = dict["TransformerAPIURL"] as? String
        }
        self.getKey { [weak self](keyOpt) in
            self?.apiKey = "Bearer " + (    keyOpt ?? "")
        }
    }
}


extension NetworkModel{
    static func getInstance() -> NetworkProtocol {
        
        if let inst = NetworkModel.instance {
            return inst
        }
        let inst = NetworkModel()
        NetworkModel.instance = inst
        return inst
    }
}


extension NetworkModel{
    
    func getKey(finished : @escaping (String?)->Void){
        
        let keyURL = (self.baseURLOpt ?? "") + "allspark"
        if let url = URL(string: keyURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            Alamofire.request(urlRequest)
                .responseString { response in
                    debugPrint(response)

                    if let status = response.response?.statusCode {
                        print("Response status: \(status)")
                    }

                    if let result = response.result.value {
                        
                        finished(result)
                    }
                    else{
                        finished(nil)
                    }
            }
        }
    }
    
    func getTransformers(finished: @escaping (_ dataDict: NSDictionary?, _ errorMsg: String?)  -> ()){
        guard let myKey = apiKey else{
            return
        }
        
        if let url = URL(string: httpURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest.addValue(myKey, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            Alamofire.request(urlRequest)
                .responseJSON { response in
                    debugPrint(response)
                    
                    if let status = response.response?.statusCode {
                        print("Response status: \(status)")
                    }
                    
                    if let result = response.result.value {
                        let JSON = result as? NSDictionary
                        finished(JSON, nil)
                    }
                    else{
                        finished(nil, "Json crashed")
                    }
            }
        }
    }
    
    func createNewTransformer(transformer: Transformer, finished: @escaping(_ response: String? , _ errorMsg: String?) -> ()){
        guard let myKey = apiKey else{
            return
        }
        
        let parameters: [String: Any] = [
            
            "name" : transformer.transformerName ?? "",
            "strength" : transformer.strength ?? 2,
            "speed" : transformer.speed  ?? 2,
            "endurance" : transformer.endurance ?? 2,
            "rank" : transformer.rank ?? 2,
            "courage": transformer.courage ?? 2,
            "firepower": transformer.firepower ?? 2,
            "skill": transformer.skill ?? 2,
            "intelligence": transformer.intelligence ?? 0,
            "team": "D" //transformer.transformerTeam.debugDescription ?? """
        ]
        
        if let url = URL(string: httpURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.addValue(myKey, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = parameters.debugDescription.data(using: .utf8)
            
//            Alamofire.request(urlRequest)
//                .responseString { response in
//                    debugPrint(response)
//
//                    if let status = response.response?.statusCode {
//                        print("Response status: \(status)")
//                    }
//            }
        }
        
        Alamofire.request(httpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization" : myKey, "Content-Type" :  "application/json"])
            .responseString { response in
                print(response)
        }
        
    }
   
    
}
