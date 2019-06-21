////
////  ModelManager.swift
////  Transformers
////
////  Created by Gokula K Narasimhan on 6/16/19.
////  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
////
//
//import Foundation
//
//
//class ModelManager{
//    var transformerArray: [Transformer]
//
//    init() {
//        transformerArray = [Transformer]()
//    }
//
//    func addTransformer(transformerOpt: Transformer?) throws{
//
//        guard let transformer =  transformerOpt else{
//            throw TransformerError.invalidTransformer
//        }
//
//        transformerArray.append(transformer)
//        //transformerArray.sort(by: <#T##(Transformer, Transformer) throws -> Bool#>)
//
//        let nsNotification = NSNotification(name: NSNotification.Name(rawValue: Messages.TransformerReadyToBeSaved), object: nil)
//        NotificationCenter.default.post(name: nsNotification.name, object: nil, userInfo:[Consts.KEY0: transformer])
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.TransformerListChanged), object: self))
//    }
//
//    func restoreTransformers(transformers : [Transformer]){
//        transformerArray = transformers
//    }
//
//    func editTransformer(transformer: Transformer) throws{
//
//        guard transformerArray.contains(transformer) else{
//            throw TransformerError.notAbleToEdit(name: transformer.transformerName ?? "")
//        }
//
//        let nsNotification = NSNotification(name: NSNotification.Name(rawValue: Messages.TransformerReadyToBeSaved), object: nil)
//        NotificationCenter.default.post(name: nsNotification.name, object: nil, userInfo:[Consts.KEY0: transformer])
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.TransformerListChanged), object: self))
//    }
//
//    func deleteTransformer(transformer: Transformer) throws{
//
//        if(transformerArray.contains{$0.transformerId == transformer.transformerId}){
//            transformerArray = transformerArray.filter({($0.transformerId != transformer.transformerId)})
//        }
//        else{
//            throw TransformerError.notAbleToDelete(name: transformer.transformerName ?? "")
//        }
//
//        let nsNotification1 = NSNotification(name: NSNotification.Name(rawValue: Messages.TransformerDeleted), object: nil)
//
//        NotificationCenter.default.post(name: nsNotification1.name, object: nil, userInfo:[Consts.KEY0: transformer])
//        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Messages.TransformerListChanged), object: self))
//    }
//
//}
