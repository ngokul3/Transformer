//
//  Rule.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/16/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

class Fight: FightProtocol{
    var fightResult: FightResult
    var delegate: FightCompleteDelegate
    
    var fighter1: Transformer
    var fighter2: Transformer
    
    init(fighter1: Transformer, fighter2: Transformer, delegate: FightCompleteDelegate){
        self.fighter1 = fighter1
        self.fighter2 = fighter2
        self.delegate = delegate
        fightResult = .NoWinner
    }
    
    private func checkCourageWithStrength(proceedToNextCheck: (Bool)->Void){
        switch ((fighter1.courage ?? 0) - (fighter2.courage  ?? 0), (fighter1.strength ?? 0) - (fighter2.strength ?? 0)) {
        case (4..., 3...):
            fighter1.state = .Alive
            fighter2.state = .Died
            fightResult = .AutobotsWon
            proceedToNextCheck(false)
        case (...(-4), ...(-3)):
            fighter2.state = .Alive
            fighter1.state = .Died
            fightResult = .DecepticonsWon
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
            fightResult = .AutobotsWon
            proceedToNextCheck(false)
        case ...(-3):
            fighter2.state = .Alive
            fighter1.state = .Died
            fightResult = .DecepticonsWon
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
            fightResult = .NoWinner
        case (true, _):
            fighter1.state = .Alive
            fighter2.state = .Died
            fightResult = .AutobotsWon
        case (false, _):
            fighter2.state = .Alive
            fighter1.state = .Died
            fightResult = .DecepticonsWon
         }
        
    }
    
    private func checkSuperHero(proceedToNextCheck: (Bool)->Void){
        switch (fighter1.isSuperHero, fighter2.isSuperHero) {
        case (true, false):
            fighter1.state = .Alive
            fighter2.state = .Died
            fightResult = .AutobotsWon
            proceedToNextCheck(false)
        case (false, true):
            fighter2.state = .Alive
            fighter1.state = .Died
            fightResult = .DecepticonsWon
            proceedToNextCheck(false)
        case (true, true):
            fighter1.state = .Died
            fighter2.state = .Died
            fightResult = .NoSurvivor
            self.delegate.fightOverBecauseOfNames()
            proceedToNextCheck(false)
        default:
            proceedToNextCheck(true)
        }
    }
    
    func evaluateFighters(evaluationComplete : (MessageType)->Void){
        checkSuperHero { (proceedToCheck2) in
            if !(proceedToCheck2) {
                evaluationComplete(MessageType.evaluatedByName)
            }else{
                checkCourageWithStrength { (proceedToCheck3) in
                    if !(proceedToCheck3){
                        evaluationComplete(MessageType.evaluatedByCourageStrength)
                    }else{
                        checkSkill{(proceedToCheck4) in
                            if !(proceedToCheck4){
                                evaluationComplete(MessageType.evaluatedBySkill)
                            }else{
                                checkRating()
                                evaluationComplete(MessageType.evaluatedByRating)
                            }
                        }
                    }
                }
            }
        }
    }
}

