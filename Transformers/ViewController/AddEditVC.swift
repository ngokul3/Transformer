//
//  AddVC.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/18/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class AddEditVC: UIViewController {

    
    
    @IBOutlet weak var teamIconView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    var transformer: Transformer?
    var transformerVCType : DetailVCType?
    var saveDetailVC: ((Transformer?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AddEditVC{
    @IBAction func btnBackClicked(_ sender: UIBarButtonItem) {
        if(transformer?.transformerName != nameText.text){
            alertUser = "Restaurant Name was changed"
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: UIBarButtonItem) {
        guard let name = nameText.text,
            !name.isEmpty else{
                alertUser = "Transformer Name cannot be empty"
                return
        }
        transformer?.transformerName = name
        
        saveDetailVC?(transformer)
        navigationController?.popViewController(animated: true)
        
    }
  
}

extension AddEditVC{
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
