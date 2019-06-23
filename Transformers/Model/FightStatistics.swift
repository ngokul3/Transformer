//
//  FightStatistics.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/23/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation
class FightStatistics : FightStatisticsDataSource{
    var battleNo: Int = 0
    var fighter1: Transformer?
    var fighter2: Transformer?
    var winningTeam: FightResult = .NoWinner
    
}
