//
//  GifsCollectionViewCell.swift
//  Gitfs
//
//  Created by Sagar Arora on 18/05/23.
//

import UIKit
import SwiftyGif

class GifsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!

    var delegate: GifsCollectionViewCellDelegate?
    var isFavorite = false
    var gif: Gifs?

    override func prepareForReuse() {
        preview.image = nil
        gif = nil
        btnFavorite.tintColor = .gray
    }
    
    func loadGif(_ gif: Gifs) {
        self.isFavorite = gif.isFavorite
        self.gif = gif
        let url = URL(string: gif.imageUrl)
        let loader = UIActivityIndicatorView(style: .medium)
        preview.setGifFromURL(url!, customLoader: loader)

        btnFavorite.setTitle("", for: .normal)
        let image = UIImage(named: "icon_wishlist")?.withRenderingMode(.alwaysTemplate)
        btnFavorite.setImage(image, for: .normal)
        updateButtonState()
    }

    private func updateButtonState() {
        btnFavorite.tintColor = isFavorite ? .red : .gray
    }

    @IBAction func onTapBtnFavorite(_ sender: UIButton) {
        if let gif {
            delegate?.updateFavoriteItem(item: gif)
        }

        isFavorite = !isFavorite
        updateButtonState()
    }
}

//class GifsCollectionViewCell: UICollectionViewCell {
//    let previewImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.clear
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    let likeButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("", for: .normal)
//        let image = UIImage(named: "icon_wishlist")?.withRenderingMode(.alwaysTemplate)
//        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    var delegate: GifsCollectionViewCellDelegate?
//    var isFavorite = false
//    var gif: Gifs?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addViews()
//    }
//    
    
//
//    func addViews(){
//        backgroundColor = UIColor.white
//
//        contentView.addSubview(previewImageView)
//        contentView.addSubview(likeButton)
//
//        previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        previewImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        previewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2).isActive = true
//        previewImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//
//        previewImageView.widthAnchor.constraint(equalToConstant: 400).isActive = true
//        likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
//        likeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
//        likeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        likeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        previewImageView.layer.cornerRadius = 4
//        likeButton.addTarget(self, action: #selector(self.onTapBtnFavorite(sender:)), for: .touchUpInside)
//    }
//        
//    func loadGif(_ gif: Gifs) {
//        self.isFavorite = gif.isFavorite
//        self.gif = gif
//        let url = URL(string: gif.imageUrl)
//        let loader = UIActivityIndicatorView(style: .medium)
//        previewImageView.setGifFromURL(url!, customLoader: loader)
//        updateButtonState()
//        calculateSize()
//    }
//    
//    private func calculateSize() {
//        let width = (UIScreen.main.bounds.width - 3) / 2
//        var height = width
////        if let imageHeight = gif?.imageHeight, let imageWidth = gif?.imageWidth {
////            height = width * imageHeight / imageWidth
////        }
//        
//        previewImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
//        previewImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
//    }
//    
//    @objc func onTapBtnFavorite(sender: UIButton) {
//        if let gif {
//            delegate?.updateFavoriteItem(item: gif)
//        }
//        
//        isFavorite = !isFavorite
//        updateButtonState()
//    }
//    
//    private func updateButtonState() {
//        likeButton.tintColor = isFavorite ? .red : .gray
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
