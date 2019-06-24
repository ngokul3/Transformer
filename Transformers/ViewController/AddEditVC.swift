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
    @IBOutlet weak var enduranceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var teamSegment: UISegmentedControl!

    @IBOutlet weak var iboScrollView: UIScrollView!
    @IBOutlet weak var rankStepper: UIStepper!
    @IBOutlet weak var courageStepper: UIStepper!
    @IBOutlet weak var strengthStepper: UIStepper!
    @IBOutlet weak var skillStepper: UIStepper!
    @IBOutlet weak var speedStepper: UIStepper!
    @IBOutlet weak var intelligenceStepper: UIStepper!
    @IBOutlet weak var firepowerStepper: UIStepper!
    @IBOutlet weak var enduranceStepper: UIStepper!
    
    var transformer: Transformer?
    var transformerVCType : DetailVCType?
    var saveDetailVC: ((Transformer?) -> Void)?
    var loadImage:(()->Void)?
    
    @IBAction func rankStepperClick(_ sender: UIStepper) {
        rankLabel.text = String(Int(sender.value))
        transformer?.rank = Int(rankLabel.text ?? "")
    }
    
    @IBAction func courageStepperClick(_ sender: UIStepper) {
        courageLabel.text = String(Int(sender.value))
        transformer?.courage = Int(courageLabel.text ?? "")
    }
    
    @IBAction func strengthStepperClick(_ sender: UIStepper) {
        strengthLabel.text = String(Int(sender.value))
        transformer?.strength = Int(strengthLabel.text ?? "")
        transformer?.transformerName = nameText.text
        loadTransformer()
    }
    
    @IBAction func skillStepperClick(_ sender: UIStepper) {
        skillLabel.text = String(Int(sender.value))
        transformer?.skill = Int(skillLabel.text ?? "")
    }
    
    @IBAction func speedStepperClick(_ sender: UIStepper) {
        speedLabel.text = String(Int(sender.value))
        transformer?.speed = Int(speedLabel.text ?? "")
        transformer?.transformerName = nameText.text
        loadTransformer()
    }
    
    @IBAction func intelligenceStepperClick(_ sender: UIStepper) {
        intelligenceLabel.text = String(Int(sender.value))
        transformer?.intelligence = Int(intelligenceLabel.text ?? "")
        transformer?.transformerName = nameText.text
        loadTransformer()
    }
    
    @IBAction func firepowerStepperClick(_ sender: UIStepper) {
        firepowerLabel.text = String(Int(sender.value))
        transformer?.firepower = Int(firepowerLabel.text ?? "")
        transformer?.transformerName = nameText.text
        loadTransformer()
    }
    
    @IBAction func enduranceStepperClick(_ sender: UIStepper) {
        enduranceLabel.text = String(Int(sender.value))
        transformer?.endurance = Int(enduranceLabel.text ?? "")
        transformer?.transformerName = nameText.text
        loadTransformer()
    }
    
    @IBAction func teamSegmentChange(_ sender: UISegmentedControl) {
        switch teamSegment.selectedSegmentIndex
        {
        case 0:
            transformer?.transformerTeam = .autobots
            loadImage?()
        case 1:
            transformer?.transformerTeam = .decepticon
            loadImage?()
        default:
            break
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIBarButtonItem) {
        if(transformer?.transformerName != nameText.text){
            alertUser = "Transformer Name was changed"
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: UIBarButtonItem) {
        if let state = transformer?.state{
            if (state == .Died){
                alertUser = "Can't save dead transformers"
                return
            }
        }
        
        guard let name = nameText.text,
            !name.isEmpty else{
                alertUser = "Transformer Name cannot be empty"
                return
        }
        transformer?.transformerName = nameText.text
        switch self.teamSegment.selectedSegmentIndex{
        case 0 :
            transformer?.transformerTeam = Team.autobots
        case 1:
            transformer?.transformerTeam = Team.decepticon
        default:
            break
        }
        
        saveDetailVC?(transformer)
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTransformer()
        self.iboScrollView.isScrollEnabled = true
        self.iboScrollView.isUserInteractionEnabled = true
        
    }
    
    func loadTransformer(){
        if let t = transformer{
            rankStepper.value = Double(t.rank ?? 1)
            courageStepper.value = Double(t.courage ?? 1)
            strengthStepper.value = Double(t.strength ?? 1)
            skillStepper.value = Double(t.skill ?? 1)
            speedStepper.value = Double(t.speed ?? 1)
            intelligenceStepper.value = Double(t.intelligence ?? 1)
            enduranceStepper.value = Double(t.endurance ?? 1)
            firepowerStepper.value = Double(t.firepower ?? 1)
            
            nameText.text = t.transformerName ?? ""
            rankLabel.text = String(t.rank ?? 1)
            courageLabel.text = String(t.courage ?? 1)
            strengthLabel.text = String(t.strength ?? 1)
            skillLabel.text = String(t.skill ?? 1)
            speedLabel.text = String(t.speed ?? 1)
            intelligenceLabel.text = String(t.intelligence ?? 1)
            firepowerLabel.text = String(t.firepower ?? 1)
            ratingLabel.text = String(t.rating)
            enduranceLabel.text = String(t.endurance ?? 1)
            if let team = t.transformerTeam {
                switch team{
                case .autobots:
                    teamSegment.selectedSegmentIndex = 0
                case .decepticon:
                    teamSegment.selectedSegmentIndex = 1
                }
            }
            loadImage?()
        }
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
