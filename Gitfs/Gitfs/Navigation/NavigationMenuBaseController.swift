//
//  NavigationMenuBaseController.swift
//  Gitfs
//
//  Created by Sagar Arora on 17/05/23.
//

import UIKit

class NavigationMenuBaseController: UITabBarController {

    public static var shared = NavigationMenuBaseController()
    var customTabBar: TabNavigationMenu!
    var tabBarHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    func loadTabBar() {
        
        var tabItems: [TabItem] = []
        self.viewControllers = []
        
        if let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            let iconHome = UIImageView(image: UIImage(named: "icon_home"))
            let tabItem = TabItem(homeVC, iconHome, "Home")
            tabItems.append(tabItem)
        }
        
        if let wishlistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
            let iconWishlist = UIImageView(image: UIImage(named: "icon_wishlist"))
            let tabItem = TabItem(wishlistVC, iconWishlist, "Favorites")
            tabItems.append(tabItem)
        }
        
        self.setupCustomTabMenu(tabItems, completion: {
            (controllers) in
        })

        self.selectedIndex = 0 // default our selected index to the first item
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        // hide the tab bar
        tabBar.isHidden = true
        var bottomPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
        }
        self.customTabBar = TabNavigationMenu(menuItems: menuItems, frame:  CGRect(x: 0, y: self.view.frame.height - tabBarHeight - bottomPadding, width: self.view.frame.width, height: tabBarHeight + bottomPadding))
        tabBarHeight += bottomPadding
//        self.customTabBarView = CustomTabBar(frame: CGRect(x: -5, y: self.view.frame.height - 60 - bottomPadding, width: self.view.frame.width + 10, height: 60))
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab
//        self.customTabBar.addBorders([.top], 1, .grey)
        // Add it to the view
        self.view.addSubview(customTabBar)
        // Add positioning constraints to place the nav menu right where the tab bar should be
        NSLayoutConstraint.activate([
            self.customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            self.customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            self.customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            self.customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
        for i in 0 ..< menuItems.count {
            controllers.append(menuItems[i].viewController ?? UIViewController()) // we fetch the matching view controller and append here
        }
        self.view.layoutIfNeeded() // important step
        completion(controllers) // setup complete. handoff here
    }
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
}
