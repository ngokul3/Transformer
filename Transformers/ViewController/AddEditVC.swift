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
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var courageLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var firepowerLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var teamSegment: UISegmentedControl!
    
    var transformer: Transformer?
    var transformerVCType : DetailVCType?
    var saveDetailVC: ((Transformer?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let t = transformer{
            rankLabel.text = String(t.rank ?? 1)
            courageLabel.text = String(t.courage ?? 1)
            strengthLabel.text = String(t.strength ?? 1)
            skillLabel.text = String(t.skill ?? 1)
            speedLabel.text = String(t.speed ?? 1)
            intelligenceLabel.text = String(t.intelligence ?? 1)
            firepowerLabel.text = String(t.firepower ?? 1)
            ratingLabel.text = String(t.rating)
        }
            
    }
}


extension AddEditVC{
    @IBAction func rankStepperClick(_ sender: UIStepper) {
        rankLabel.text = String(sender.value)
    }
    
    @IBAction func courageStepperClick(_ sender: UIStepper) {
        courageLabel.text = String(sender.value)
    }
    
    @IBAction func strengthStepperClick(_ sender: UIStepper) {
        strengthLabel.text = String(sender.value)
    }
    
    @IBAction func skillStepperClick(_ sender: UIStepper) {
        skillLabel.text = String(sender.value)
    }
    
    @IBAction func speedStepperClick(_ sender: UIStepper) {
        speedLabel.text = String(sender.value)
    }
    
    @IBAction func intelligenceStepperClick(_ sender: UIStepper) {
        intelligenceLabel.text = String(sender.value)
    }
    
    @IBAction func firepowerStepperClick(_ sender: UIStepper) {
        firepowerLabel.text = String(sender.value)
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
