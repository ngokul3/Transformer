//
//  StatisticsViewCell.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/23/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class StatisticsViewCell: UITableViewCell {
    @IBOutlet weak var battleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
