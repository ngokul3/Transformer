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

    @IBAction func statrFightClick(_ sender: UIButton) {
        presenter?.startFight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewReady(view: self)
        presenter?.updateView()
        
        Center.addObserver(forName: MessageType.transformerListChanged.asNN, object: nil, queue: OperationQueue.main) {
            [weak self] (notification) in
            self?.presenter?.updateView()
        }
    }
}

extension FightVC: FightViewInput{
    func prepForFight() {
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
        return presenter?.fightSetArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fightCell", for: indexPath) as? FightViewCell else{
            preconditionFailure("Incorrect Cell provided")
        }
        if let fightSetUp = presenter?.fightAtIndex(index: indexPath.row) {
            cell.fightSetLabel.text = fightSetUp.fightDesc
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}
