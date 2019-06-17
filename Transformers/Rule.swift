//
//  Rule.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/16/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class Rule: RuleProtocol{
    let Center = NotificationCenter.default
    var fighter1: Transformer
    var fighter2: Transformer
    
    init(fighter1: Transformer, fighter2: Transformer){
        self.fighter1 = fighter1
        self.fighter2 = fighter2
    }
    
    func checkCourageWithStrength(proceedToNextCheck: (Bool?)->Void){
        switch ((fighter1.courage ?? 0) - (fighter2.courage  ?? 0), (fighter1.strength ?? 0) - (fighter2.strength ?? 0)) {
        case (4..., 3...):
            self.updateObservers(message: .winnerFound, data: fighter1)
            proceedToNextCheck(false)
        case (...(-4), ...(-3)):
            self.updateObservers(message: .winnerFound, data: fighter2)
            proceedToNextCheck(false)
        default:
            proceedToNextCheck(true)
        }
    }
    
    func checkSkill(proceedToNextCheck: (Bool?)->Void){
        switch (fighter1.skill ?? 0) - (fighter2.skill ?? 0){
        case 3...:
            self.updateObservers(message: .winnerFound, data: fighter1)
            proceedToNextCheck(false)
        case ...(-3):
            self.updateObservers(message: .winnerFound, data: fighter1)
            proceedToNextCheck(false)
        default:
            proceedToNextCheck(true)
        }
    }
    
    func checkRating(){
        switch (fighter1.rating > fighter2.rating, fighter1.rating - fighter2.rating) {
        case (_, 0):
            self.updateObservers(message: .bothDead, data: [fighter1, fighter2])
        case (true, _):
            self.updateObservers(message: .winnerFound, data: fighter1)
        case (false, _):
            self.updateObservers(message: .winnerFound, data: fighter2)
         }
    }
    
    func checkSuperHero(proceedToNextCheck: (Bool?)->Void){
        switch (fighter1.isSuperHero, fighter2.isSuperHero) {
        case (true, false):
            self.updateObservers(message: .winnerFound, data: fighter1)
            proceedToNextCheck(false)
        case (false, true):
            self.updateObservers(message: .winnerFound, data: fighter2)
            proceedToNextCheck(false)
        case (true, true):
            self.updateObservers(message: .gameOver, data: nil)
            proceedToNextCheck(false)
        default:
            proceedToNextCheck(true)
        }
    }
    
    func evaluateFighters(){
        checkSuperHero { (check1) in
            if let _ = check1 {
                return
            }else{
                checkCourageWithStrength { (check2) in
                    if let _ = check2{
                        return
                    }else{
                        checkSkill{(check3) in
                            if let _ = check3{
                                return
                            }else{
                                checkRating()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Rule{
    private func updateObservers(message: MessageType, data: Any? = nil) {
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
