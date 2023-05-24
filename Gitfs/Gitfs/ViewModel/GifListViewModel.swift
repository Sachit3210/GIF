//
//  GifListViewModel.swift
//  Gitfs
//
//  Created by Sagar Arora on 18/05/23.
//

import Foundation

internal protocol GifsCollectionViewCellDelegate {
    func updateFavoriteItem(item: Gifs)
}

internal class GifListViewModel: GifsCollectionViewCellDelegate {
    func updateFavoriteItem(item: Gifs) {
        if item.isFavorite {
            DataManager.deleteGif(item)
            updateData()
        } else {
            item.isFavorite = true
            DataManager.saveMyGif(item)
            self.gifs = gifs.map { gif in
                if gif.id == item.id {
                    return item
                }
                return gif
            }
        }
    }
    
    // Properties
    private var gifs: [Gifs] = []
    private var pagination: Pagination = Pagination(totalCount: 100, count: 20, offset: 0)
    private var favorites: [Gifs] = []
    
    // Callback closure for data updates
    internal var onDataUpdate: (() -> Void)?
    
    // Fetch data from a data source
    internal func fetchData(offset: Int = 0) {
        APIResources.shared.makeRequest(urlString: "https://api.giphy.com/v1/gifs/trending?offset=\(offset)&limit=\(pagination.count)&api_key=1D010kp1qRbjLTMRGZCLsqhfg9ltDsPZ", method: "GET") { [weak self] result in
            switch result {
            case .success(let data):
                
                if let data = try? JSONDecoder().decode(GifsData.self, from: data) {
                    self?.gifs.append(contentsOf: data.data)
                    self?.pagination = data.pagination
                    self?.updateData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    internal func updateData() {
        let favorites = DataManager.retrieveMyGifs()
        self.favorites = favorites
        let updatedData = gifs.map { gif in
            let newGif = gif
            if favorites.contains(where: { $0.id == gif.id }) {
                newGif.isFavorite = true
            }
            return newGif
        }
        self.gifs = updatedData
        self.onDataUpdate?()
    }
    
    // Get the number of items in the data
    internal func numberOfItems(_ showFavorites: Bool) -> Int {
        return showFavorites ? favorites.count : gifs.count
    }
    
    // Get the item at a specific index
    internal func item(at index: Int, onlyFavorites: Bool) -> Gifs? {
        if onlyFavorites {
            guard index >= 0 && index < favorites.count else { return nil }
            return favorites[index]
        } else {
            guard index >= 0 && index < gifs.count else { return nil }
            return gifs[index]
        }
    }
    
    internal func fetchMoreData(index: Int) {
        if gifs.count < pagination.totalCount, index == gifs.count - 2, gifs.count != 0 {
            pagination.offset += 10
            self.fetchData(offset: pagination.offset)
        }
    }
}
