//
//  TransformerMasterVC.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/18/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class MasterVC: UIViewController {
    var presenter: TransformerViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewReady()
     }
 }

extension MasterVC: TransformerViewInput{
    func setUpTransformers(transformers: [Transformer]) {
        
    }
}

extension MasterVC{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let identifier = segue.identifier else{
            preconditionFailure("No segue identifier")
        }
        
        guard let vc = segue.destination as? AddEditVC else{
            preconditionFailure("Could not find segue")
        }
        
        switch identifier{
        case "addSegue":
            vc.transformerVCType = DetailVCType.Add
            vc.transformer = presenter?.generateTransformerPrototype()
            vc.saveDetailVC = {[weak self] (transformerOpt) in
                if let transformer = transformerOpt{
                     self?.presenter?.addTransformer(transformer: transformer)
                }
            }
        case "editSegue":
            break
        default:
            break
        }
    }
}

extension MasterVC{
    var alertUser :  String{
        get{
            preconditionFailure("You cannot read from this object")
        }
        set{
            let alert = UIAlertController(title: "Changes not saved", message: newValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Stay", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Disregard", style: .default, handler: ({[weak self](arg) -> Void in
                self?.navigationController?.popViewController(animated: true)
            })))
            self.present(alert, animated: true)
        }
    }
}
