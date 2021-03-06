//
//  CutomTabBarController.swift
//  facebookfeed
//
//  Created by Harry Tennent on 03/04/2017.
//  Copyright © 2017 Harry Tennent. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestsController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestsController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        
        
        let messengerVC = UIViewController()
        messengerVC.navigationItem.title = "Messenger"
        let messengerNavigationController = UINavigationController(rootViewController: messengerVC)
        messengerNavigationController.title = "Messenger"
        messengerNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationsVC = UIViewController()
        notificationsVC.navigationItem.title = "Notifications"
        let notificationsNavigationController = UINavigationController(rootViewController: notificationsVC)
        notificationsNavigationController.title = "Notifications"
        notificationsNavigationController.tabBarItem.image = UIImage(named: "globe_icon")
        
        let moreVC = UIViewController()
        moreVC.navigationItem.title = "More"
        let moreNavigationController = UINavigationController(rootViewController: moreVC)
        moreNavigationController.title = "More"
        moreNavigationController.tabBarItem.image = UIImage(named:"more_icon")
            
            
        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavigationController, moreNavigationController]
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
    }
}





