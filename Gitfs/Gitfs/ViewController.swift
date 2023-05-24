//
//  ViewController.swift
//  Gitfs
//
//  Created by Sagar Arora on 17/05/23.
//

import UIKit

internal class ViewController: UIViewController {

    internal override func viewDidLoad() {
        super.viewDidLoad()
        pushTabbar()
    }

    private func pushTabbar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
        let vc1 = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc1.tabBarItem.title = "Home"
        vc1.tabBarItem.image = UIImage(named: "icon_home")
        
        let vc2 = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        vc2.tabBarItem.title = "Favorites"
        vc2.tabBarItem.image = UIImage(named: "icon_wishlist")?.withRenderingMode(.alwaysTemplate)
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [vc1, vc2]
        
        if let navigator = navigationController {
            navigator.pushViewController(tabBarController, animated: false)
        }
    }

}

