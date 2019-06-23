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
    var statisticsArray = [FightStatistics]()
    
    @IBOutlet weak var fightPrepTableView: UITableView!
    @IBOutlet weak var fightResultTableView: UITableView!
    
    @IBAction func statrFightClick(_ sender: UIButton) {
        presenter?.startFight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewReady(view: self)
        presenter?.updateView()
        
        [ MessageType.transformerListChanged, MessageType.fightDone, MessageType.gameOver ].forEach {
            Center.addObserver(forName: $0.asNN, object: nil, queue: OperationQueue.main) {
                [weak self] (notification) in
                if(notification.name.rawValue == MessageType.fightDone.asNN.rawValue){
                    if let s = self{
                        let info0 = notification.userInfo?[Consts.KEY0]
                        let fightStatOpt = info0 as? FightStatistics
                        
                        guard let fightStat = fightStatOpt else{
                            return
                        }
                        
                        s.statisticsArray.append(fightStat)
                        s.fightResultTableView.reloadData()
                    }
                }
                self?.presenter?.updateView()
            }
        }
       
    }
}

extension FightVC: FightViewInput{
    func prepForFight() {
        self.fightPrepTableView.reloadData()
    }
 
}

extension FightVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == fightPrepTableView){
            return presenter?.fightSetArray.count ?? 0
        }else if(tableView == fightResultTableView){
            return self.statisticsArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if (tableView == fightPrepTableView){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fightCell", for: indexPath) as? FightViewCell else{
                preconditionFailure("Incorrect Cell provided")
            }
            if let fightSetUp = presenter?.fightAtIndex(index: indexPath.row) {
                cell.fightSetLabel.text = fightSetUp.fightDesc
                cell.resultLabel.text = fightSetUp.resultDesc
            }
            return cell
         }else if (tableView == fightResultTableView){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as? StatisticsViewCell else{
                preconditionFailure("Incorrect Cell provided")
            }
            if let stat = self.statisticsArray[safe: indexPath.row]{
                cell.battleLabel.text = "Battle: \(stat.battleNo)"
                cell.resultLabel.text = stat.winningTeam.rawValue
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension FightVC{
    var alertUser :  String{
        get{
            preconditionFailure("You cannot read from this object")
        }
        set{
            let alert = UIAlertController(title: "Game Over", message: newValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
