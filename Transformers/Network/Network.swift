
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
    
    func getKey(finished : @escaping (String?)->Void){
        guard let myKey = apiKey else{
            return
        }
        let keyURL = self.baseURLOpt ?? "" + "allspark"
        if let url = URL(string: keyURL) {
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
        
        let keyURL = self.baseURLOpt ?? "" + "transformers"
        
        if let url = URL(string: keyURL) {
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
   
    
}
