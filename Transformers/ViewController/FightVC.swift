//
//  FightVC.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/22/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import Foundation
import UIKit

class FightVC: UIViewController{
    var presenter: FightViewOutput?
    
    @IBOutlet weak var fightPrepTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let  s = 10
        print(s)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewReady()
        
        
        Center.addObserver(forName: MessageType.transformersReadyToFight.asNN, object: nil, queue: OperationQueue.main) {
            [weak self] (notification) in
            //self?.prepForFight()
        }
    }
}

extension FightVC: FightViewInput{
    func prepForFight(fightSetUpArray: [FighterSetUp]) {
        self.fightPrepTableView.reloadData()
    }
    
    func displayStatistics(statistics: TeamStatisticsDataSource) {
        
    }
}

extension FightVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return presenter?.transformerCount() ?? 0
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fightCell", for: indexPath) as? MasterViewCell else{
            preconditionFailure("Incorrect Cell provided")
        }
//        if let transformer = presenter?.transformerAtIndex(index: indexPath.row){
//            cell.nameLabel.text = transformer.transformerName
//
//            guard let teamIconURL = transformer.teamIcon as NSString? else{
//                return cell
//            }
//
//            if let imageFromCache = imageCache.object(forKey: teamIconURL as AnyObject) as? UIImage{
//                cell.teamIconView.image = imageFromCache
//            }else{
//                self.presenter?.getTeamIcon(id: transformer.transformerId ?? "", completion: { [weak self](dataOpt) in
//                    if let data = dataOpt{
//                        if let iconImage = UIImage(data: data){
//                            self?.imageCache.setObject(iconImage, forKey: (teamIconURL) as AnyObject)
//                            OperationQueue.main.addOperation {
//                                cell.teamIconView.image = iconImage
//                            }
//                        }
//                    }
//                })
//            }
//        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
