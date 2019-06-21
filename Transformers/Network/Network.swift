
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
    func getKey(finished : @escaping (Error?)->Void)
    func getTransformers(finished: @escaping (_ dataDict: NSDictionary?, _ errorMsg: String?)  -> ())
    func createNewTransformer(transformer: Transformer, finished: @escaping(_ dataDict: NSDictionary? , _ errorMsg: Error?) -> ())
    func getTeamImage(forTeamIconURL iconURL : String, imageLoaded : @escaping (Data?, HTTPURLResponse?, Error?)->Void)
}

class NetworkModel: NetworkProtocol{
    
    private var baseURLOpt : String?
    private var transitJSONFileNameOpt : String?
    private var searchDistanceLimitOpt: Int?
    private static var instance: NetworkProtocol?
    
    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }()
    
    private var _apiKey: String?
    
    var transformerKey : String?{
        return _apiKey
    }
    
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
    
    func getKey(finished : @escaping (Error?)->Void){
        
        let keyURL = (self.baseURLOpt ?? "") + "allspark"
        if let url = URL(string: keyURL) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            Alamofire.request(urlRequest)
                .responseString { [weak self] response in
                    debugPrint(response)

                    if let status = response.response?.statusCode {
                        print("Response status: \(status)")
                    }

                    if let result = response.result.value {
                        self?._apiKey = "Bearer " + result
                        finished(nil)
                    }
                    else{
                        
                        finished(response.error)
                    }
            }
        }
    }
    
    func getTransformers(finished: @escaping (_ dataDict: NSDictionary?, _ errorMsg: String?)  -> ()){
        guard let myKey = transformerKey else{
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
    
    func createNewTransformer(transformer: Transformer, finished: @escaping(_ dataDict: NSDictionary? , _ errorMsg: Error?) -> ()){
        guard let myKey = transformerKey else{
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
        }
        
        Alamofire.request(httpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization" : myKey, "Content-Type" :  "application/json"])
            .responseJSON { response in
                print(response)
                
                if let status = response.response?.statusCode {
                    print("Response status: \(status)")
                }
                
                if let result = response.result.value {
                    let JSON = result as? NSDictionary
                    finished(JSON, nil)
                }
                else{
                    finished(nil, response.error)
                }
                
                
        }
        
    }
   
    func getTeamImage(forTeamIconURL iconURL : String, imageLoaded : @escaping (Data?, HTTPURLResponse?, Error?)->Void) {
        
        if let teamIconURL = URL(string: iconURL)
        {
            let downloadPicTask = session.dataTask(with: teamIconURL) { (data, responseOpt, error) in
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                }
                else {
                    if let response = responseOpt as? HTTPURLResponse {
                        
                        if let imageData = data {
                            imageLoaded(imageData, response, error)
                        }
                        else {
                            imageLoaded(nil, response, error)
                        }
                    }
                    else {
                        imageLoaded(nil, nil, error)
                    }
                }
            }
            downloadPicTask.resume()
        }
    }
    
}
