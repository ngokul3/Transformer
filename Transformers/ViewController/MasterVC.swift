//
//  TransformerMasterVC.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/18/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class TransformerMasterVC: UIViewController {
    var presenter: TransformerViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewReady()
     }
    

}

extension TransformerMasterVC: TransformerViewInput{
    func setUpTransformers(transformers: [Transformer]) {
        
    }
   
    
}
