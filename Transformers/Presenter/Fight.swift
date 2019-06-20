//
//  Rule.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/16/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class Fight: FightProtocol{
    //let Center = NotificationCenter.default
    var fighter1: Transformer
    var fighter2: Transformer
    
    init(fighter1: Transformer, fighter2: Transformer){
        self.fighter1 = fighter1
        self.fighter2 = fighter2
    }
    
    private func checkCourageWithStrength(proceedToNextCheck: (Bool)->Void){
        switch ((fighter1.courage ?? 0) - (fighter2.courage  ?? 0), (fighter1.strength ?? 0) - (fighter2.strength ?? 0)) {
        case (4..., 3...):
            fighter1.state = .Alive
            fighter2.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByCourage, data: [fighter1, fighter2])
            proceedToNextCheck(false)
        case (...(-4), ...(-3)):
            fighter2.state = .Alive
            fighter1.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByCourage, data: [fighter1, fighter2])
            proceedToNextCheck(false)
        default:
            proceedToNextCheck(true)
        }
    }
    
    private func checkSkill(proceedToNextCheck: (Bool)->Void){
        switch (fighter1.skill ?? 0) - (fighter2.skill ?? 0){
        case 3...:
            fighter1.state = .Alive
            fighter2.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedBySkill, data: [fighter1, fighter2])
            proceedToNextCheck(false)
        case ...(-3):
            fighter2.state = .Alive
            fighter1.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedBySkill, data: [fighter1, fighter2])
            proceedToNextCheck(false)
        default:
            proceedToNextCheck(true)
        }
    }
    
    private func checkRating(){
        switch (fighter1.rating > fighter2.rating, fighter1.rating - fighter2.rating) {
        case (_, 0):
            fighter2.state = .Died
            fighter1.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByRating, data: [fighter1, fighter2])
        case (true, _):
            fighter1.state = .Alive
            fighter2.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByRating, data: [fighter1, fighter2])
        case (false, _):
            fighter2.state = .Alive
            fighter1.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByRating, data: [fighter1, fighter2])
         }
        
    }
    
    private func checkSuperHero(proceedToNextCheck: (Bool)->Void){
        switch (fighter1.isSuperHero, fighter2.isSuperHero) {
        case (true, false):
            fighter1.state = .Alive
            fighter2.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByName, data: [fighter1, fighter2])
            proceedToNextCheck(false)
        case (false, true):
            fighter2.state = .Alive
            fighter1.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByName, data: [fighter1, fighter2])
            proceedToNextCheck(false)
        case (true, true):
            fighter1.state = .Died
            fighter2.state = .Died
            TransformerNotification.updateObservers(message: .evaluatedByName, data: nil)
            proceedToNextCheck(false)
        default:
            proceedToNextCheck(true)
        }
    }
    
    func evaluateFighters(evaluationComplete : ()->Void){
        checkSuperHero { (proceedToCheck2) in
            if !(proceedToCheck2) {
                evaluationComplete()
            }else{
                checkCourageWithStrength { (proceedToCheck3) in
                    if !(proceedToCheck3){
                        evaluationComplete()
                    }else{
                        checkSkill{(proceedToCheck4) in
                            if !(proceedToCheck4){
                                evaluationComplete()
                            }else{
                                checkRating()
                                evaluationComplete()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Fight{
//    private func updateObservers(message: MessageType, data: Any? = nil) {
//        Center.post(name: message.asNN, object: self, userInfo: {
//            if let d = data {
//                return ["data": d]
//            }
//            else {
//                return nil
//            }
//        }())
//    }
}
