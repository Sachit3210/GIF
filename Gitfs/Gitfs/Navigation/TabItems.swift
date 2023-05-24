//
//  TabItems.swift
//  Gitfs
//
//  Created by Sagar Arora on 17/05/23.
//

import UIKit

struct TabItem {
    var viewController: UIViewController?
    var icon = UIImageView(image: UIImage(named: "icon_home"))
    var title = ""
    
    init(_ vc : UIViewController, _ icon: UIImageView, _ title: String) {
        self.viewController = vc
        self.icon = icon
        self.icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        self.icon.tintColor = .gray
        self.title = title
    }
}
