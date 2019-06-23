//
//  AppDelegate.swift
//  Transformers
//
//  Created by Gokula K Narasimhan on 6/15/19.
//  Copyright © 2019 Gokul K Narasimhan. All rights reserved.
//

import UIKit
import CoreData
var AppDel: AppDelegate {
    get {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var tansformerModel: TransformerModel = {
       return TransformerModel(networkModel: NetworkModel.getInstance(), queue: DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
    }()
    
    lazy var masterPresenter: TransformerPresenter = {
        return TransformerPresenter(model: tansformerModel)
    }()
    
    
    lazy var fightPresenter: FightPresenter = {
        return FightPresenter(model: tansformerModel)
    }()
    
//    var masterPresenter = TransformerPresenter(model: TransformerModel(networkModel: NetworkModel.getInstance(), queue: DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)))
//
//    var fightPresenter = FightPresenter(model: TransformerModel(networkModel: NetworkModel.getInstance(), queue: DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)))
//
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarVC = window!.rootViewController as! UITabBarController
        let nav1 = tabBarVC.viewControllers![0] as! UINavigationController
        let masterVC = nav1.viewControllers[0] as! MasterVC
        masterVC.presenter = AppDel.masterPresenter
        
        let nav2 = tabBarVC.viewControllers![1] as! UINavigationController
        let fightVC = nav2.viewControllers[0] as! FightVC
        fightVC.presenter = AppDel.fightPresenter
        
         return true
    }
   

}

