//
//  GifCellViewController.swift
//  Gitfs
//
//  Created by Sagar Arora on 21/05/23.
//

import UIKit

class GifCellViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = GifListViewModel()
    internal var showFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setLoader()
        // Assign a closure to onDataUpdate to handle data updates
        viewModel.onDataUpdate = { [weak self] in
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                let itemCount = self.viewModel.numberOfItems(self.showFavorites)
                if (itemCount == 0) {
                    self.collectionView.setEmptyMessage("Nothing to show :(")
                } else {
                    self.collectionView.restore()
                }
                self.collectionView.reloadData()
            }
        }
        
        // Fetch data
        if showFavorites {
            viewModel.updateData()
        } else {
            viewModel.fetchData()
        }
    }
}


extension GifCellViewController: PinterestLayoutDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let width = (UIScreen.main.bounds.width - 3) / 2
        var height = width

        let item = viewModel.item(at: indexPath.row, onlyFavorites: showFavorites)
        if let h = NumberFormatter().number(from: item!.images.fixedWidth.height),
           let w = NumberFormatter().number(from: item!.images.fixedWidth.width){
            height = width * CGFloat(truncating: h) / CGFloat(truncating: w)
        }
        return height
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 3) / 2
        var height = width

        let item = viewModel.item(at: indexPath.row, onlyFavorites: showFavorites)
        if let h = NumberFormatter().number(from: item!.images.fixedWidth.height),
           let w = NumberFormatter().number(from: item!.images.fixedWidth.width){
            height = width * CGFloat(truncating: h) / CGFloat(truncating: w)
        }
          return CGSize(width: width, height: height)
      }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !showFavorites {
            viewModel.fetchMoreData(index: indexPath.row)
        }
    }
}

extension GifCellViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(showFavorites)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifsCollectionViewCell", for: indexPath) as? GifsCollectionViewCell,
            let item = viewModel.item(at: indexPath.row, onlyFavorites: showFavorites) {
            cell.loadGif(item)
            cell.delegate = viewModel
            return cell
        }
        return UICollectionViewCell()
    }
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }
    
    func setLoader() {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .white
        self.backgroundView = loader
    }

    func restore() {
        self.backgroundView = nil
    }
}
