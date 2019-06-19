
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
        return self.baseURLOpt ?? "" + "transformers"
    }()
    
    init()
    {
        self.getKey { [weak self](keyOpt) in
            self?.apiKey = keyOpt
        }
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRootOpt = NSDictionary(contentsOfFile: path)
            
            guard let dict = dictRootOpt else{
                preconditionFailure("Transformer API URL is not available")
            }
            self.baseURLOpt = dict["TransformerAPIURL"] as? String
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
        
        let keyURL = self.baseURLOpt ?? "" + "allspark"
        if let url = URL(string: keyURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            Alamofire.request(urlRequest)
                .responseJSON { response in
                    debugPrint(response)

                    if let status = response.response?.statusCode {
                        print("Response status: \(status)")
                    }

                    if let result = response.result.value {
                        
                        finished(result as? String)
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
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
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
            "strength" : transformer.strength ?? 0,
            "speed" : transformer.speed  ?? 0,
            "endurance" : transformer.endurance ?? 0,
            "rank" : transformer.rank ?? 0,
            "courage": transformer.courage ?? 0,
            "firepower": transformer.firepower ?? 0,
            "skill": transformer.skill ?? 0,
            "team": transformer.transformerTeam.debugDescription
        ]
        
        if let url = URL(string: httpURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.addValue(myKey, forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpBody = parameters.debugDescription.data(using: .utf8)
                
            Alamofire.request(urlRequest)
                .responseJSON { response in
                    debugPrint(response)
                    
                    if let status = response.response?.statusCode {
                        print("Response status: \(status)")
                    }
            }
        }
        
        Alamofire.request("http://myserver.com", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
        }
        
    }
   
    
}
