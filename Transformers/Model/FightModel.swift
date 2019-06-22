//
//  FightModel.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/22/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation

protocol FightModelProtocol{
    func restoreTransformers()
    var transformerArray: [Transformer]{get}
}
class FightModel{
    var transformers = [Transformer]()
    
    init(){
        
    }
    func restoreTransformers(){
            do{
                print("Thread for restoring \(Thread.current)")
                self.transformers = try Persistence.restore()
                TransformerNotification.updateObservers(message: .transformersReadyToFight, data: self.transformers)
            }
            catch (let error){
                print(error)
                //Custom handle exception
            }
        
    }
}
