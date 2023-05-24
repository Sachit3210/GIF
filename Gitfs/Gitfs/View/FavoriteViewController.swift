//
//  FavoriteViewController.swift
//  Gitfs
//
//  Created by Sagar Arora on 17/05/23.
//

import Foundation
import UIKit

internal class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        loadGifs()
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.title = ""
        
        view.backgroundColor = .gray
    }
    
    func loadGifs() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GifCellViewController") as? GifCellViewController {
            
            vc.showFavorites = true
            
            self.addChild(vc)
            vc.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            self.containerView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
}
