//
//  NotificationObserver.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/19/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

let Center = NotificationCenter.default

enum MessageType: String{
    case evaluatedByStrength = "Strength rule"
    case evaluatedByCourage = "Courage rule"
    case evaluatedBySkill = "Skill rule"
    case evaluatedByRank = "Rank rule"
    case evaluatedByRating = "Rating rule"
    case evaluatedByName = "Name rule"
    case evaluatedByCourageStrength = "Courage and Strength"
    case winnerFound = "Winner among Transformer"
    case bothDead = "Both Transformers are dead"
    case gameOver = "All Transformers are dead"
    case transformerListChanged = "Transformer Ready To be Saved"
    case fightDone = "Fight done"
    case filterChanged = "filter change"
    
    var asNN: Notification.Name {
        return Notification.Name(self.rawValue)
    }
    var asNotification: Notification {
        return Notification(name: asNN)
    }
}



struct TransformerNotification {
    static func updateObservers(message: MessageType, data: Any? = nil) {
        Center.post(name: message.asNN, object: self, userInfo: {
            if let d = data {
                return [Consts.KEY0: d]
            }
            else {
                return nil
            }
        }())
    }
    
}
