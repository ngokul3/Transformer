//
//  NotificationObserver.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/19/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation
struct Messages{
    static let TransformerReadyToBeSaved = "Transformer Ready To be Saved"
    static let TransformerListChanged = "Transformer List changed"
    static let TransformerDeleted = "Transformer Deleted"
    static let ModelChanged = "ModelChanged"
}

struct TransformerNotification {
    static let Center = NotificationCenter.default
    
    static func updateObservers(message: MessageType, data: Any? = nil) {
        Center.post(name: message.asNN, object: self, userInfo: {
            if let d = data {
                return ["data": d]
            }
            else {
                return nil
            }
        }())
    }
    
}
