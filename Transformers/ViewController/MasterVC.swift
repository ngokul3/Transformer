//
//  TransformerMasterVC.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/18/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit

class MasterVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var presenter: TransformerViewOutput?
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewReady(view: self)
         [ MessageType.transformerListChanged, MessageType.fightDone ].forEach {
            Center.addObserver(forName: $0.asNN, object: nil, queue: OperationQueue.main) {
                [weak self] (notification) in
                    self?.setUpTransformers()
            }
        }
     }
 }

extension MasterVC: TransformerViewInput{
    func setUpTransformers() {
         self.tableView.reloadData()
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
                    self?.presenter?.transformerInContext(transformer: transformer, opType: .Add, errorMsg: {(error) in
                        if let _ = error{
                            self?.alertUser = "Not able to Add"
                        }
                    })
                }
            }
        case "editSegue":
            guard let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell) else{
                    preconditionFailure("Segue from unexpected object: \(sender ?? "sender = nil")")
            }
            
            do{
                if let transformer = presenter?.transformerAtIndex(index: indexPath.row){
                    vc.transformer = transformer
                    vc.transformerVCType = DetailVCType.Edit
                    vc.loadImage = {[weak self] in
                        
                        if let imageFromCache = self?.imageCache.object(forKey: (transformer.transformerTeam ?? Team.autobots) as AnyObject) as? UIImage{
                            OperationQueue.main.addOperation {
                                vc.teamIconView.image = imageFromCache
                            }
                        }
                    }
                    vc.saveDetailVC = {[weak self] (transOpt) in
                        if let trans = transOpt{
                            self?.presenter?.transformerInContext(transformer: trans, opType: .Edit, errorMsg: {(error) in
                                if let _ = error{
                                    self?.alertUser = "Not able to Edit"
                                }
                            })
                        }else{
                            self?.alertUser = "Could not edit this Transformer"
                        }
                    }
                }
                
            }
            
            break
        default:
            break
        }
    }
}

extension MasterVC{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.transformerCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transformerCell", for: indexPath) as? MasterViewCell else{
            preconditionFailure("Incorrect Cell provided")
        }
        if let transformer = presenter?.transformerAtIndex(index: indexPath.row){
            cell.nameLabel.text = transformer.transformerName
            cell.stateLabel.text = transformer.state?.rawValue

            guard
                let team = transformer.transformerTeam else{
                return cell
            }
            
            if let imageFromCache = imageCache.object(forKey: team as AnyObject) as? UIImage{
                 cell.teamIconView.image = imageFromCache
            }else{
                self.presenter?.getTeamIcon(id: transformer.transformerId ?? "", completion: { [weak self](dataOpt) in
                    if let data = dataOpt{
                        if let iconImage = UIImage(data: data){
                            self?.imageCache.setObject(iconImage, forKey: (team) as AnyObject)
                            OperationQueue.main.addOperation {
                                cell.teamIconView.image = iconImage
                            }
                        }
                    }
                })
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension MasterVC{
    var alertUser :  String{
        get{
            preconditionFailure("You cannot read from this object")
        }
        set{
            let alert = UIAlertController(title: "Changes not saved", message: newValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
