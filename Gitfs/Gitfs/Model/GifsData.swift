//
//  GifsData.swift
//  Gitfs
//
//  Created by Sagar Arora on 18/05/23.
//

import Foundation


import Foundation

// MARK: - GifsData
class GifsData: NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: CodingKeys.data.rawValue)
        coder.encode(pagination, forKey: CodingKeys.pagination.rawValue)
    }
    
    required init?(coder: NSCoder) {
        data = coder.decodeObject(forKey: CodingKeys.data.rawValue) as? [Gifs] ?? []
        pagination = coder.decodeObject(forKey: CodingKeys.pagination.rawValue) as? Pagination ?? Pagination(totalCount: 0, count: 0, offset: 0)
    }
    
    let data: [Gifs]
    let pagination: Pagination

    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
    
    init(data: [Gifs], pagination: Pagination) {
        self.data = data
        self.pagination = pagination
    }
}

// MARK: - Gifs
class Gifs: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: CodingKeys.id.rawValue)
        coder.encode(images, forKey: CodingKeys.images.rawValue)
        coder.encode(isFavorite, forKey: "is_favorite")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: CodingKeys.id.rawValue) as? String ?? ""
        images = coder.decodeObject(forKey: CodingKeys.images.rawValue) as? Images ?? Images(fixedWidth: FixedWidth(height: "", width: "", url: ""))
        isFavorite = coder.decodeObject(forKey: "is_favorite") as? Bool ?? false
    }
    
    let id: String
    let images: Images
    var isFavorite = false

    var imageUrl: String {
        images.fixedWidth.url
    }

    var imageWidth: CGFloat {
        if let n = NumberFormatter().number(from: images.fixedWidth.width) {
            return CGFloat(truncating: n)
        }
        return 0
    }

    var imageHeight: CGFloat {
        if let n = NumberFormatter().number(from: images.fixedWidth.height) {
            return CGFloat(truncating: n)
        }
        return 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
    }

    init(id: String, images: Images) {
        self.id = id
        self.images = images
    }
}

// MARK: - Images
class Images: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(fixedWidth, forKey: CodingKeys.fixedWidth.rawValue)
    }
    
    required init?(coder: NSCoder) {
        fixedWidth = coder.decodeObject(forKey: CodingKeys.fixedWidth.rawValue) as? FixedWidth ?? FixedWidth(height: "", width: "", url: "")
    }
    
    let fixedWidth: FixedWidth

    enum CodingKeys: String, CodingKey {
        case fixedWidth = "fixed_width"
    }

    init(fixedWidth: FixedWidth) {
        self.fixedWidth = fixedWidth
    }
}


// MARK: - FixedHeight
class FixedWidth: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(height, forKey: CodingKeys.height.rawValue)
        coder.encode(width, forKey: CodingKeys.width.rawValue)
        coder.encode(url, forKey: CodingKeys.url.rawValue)
    }
    
    required init?(coder: NSCoder) {
        height = coder.decodeObject(forKey: CodingKeys.height.rawValue) as? String ?? ""
        width = coder.decodeObject(forKey: CodingKeys.width.rawValue) as? String ?? ""
        url = coder.decodeObject(forKey: CodingKeys.url.rawValue) as? String ?? ""
    }
    
    let height, width: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case height, width, url
    }

    init(height: String, width: String, url: String) {
        self.height = height
        self.width = width
        self.url = url
    }
}

// MARK: - Pagination
class Pagination: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(totalCount, forKey: CodingKeys.totalCount.rawValue)
        coder.encode(count, forKey: CodingKeys.count.rawValue)
        coder.encode(offset, forKey: CodingKeys.offset.rawValue)
    }
    
    required init?(coder: NSCoder) {
        totalCount = coder.decodeObject(forKey: CodingKeys.totalCount.rawValue) as? Int ?? 0
        count = coder.decodeObject(forKey: CodingKeys.count.rawValue) as? Int ?? 0
        offset = coder.decodeObject(forKey: CodingKeys.offset.rawValue) as? Int ?? 0
    }
    
    var totalCount, count, offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }

    init(totalCount: Int, count: Int, offset: Int) {
        self.totalCount = totalCount
        self.count = count
        self.offset = offset
    }
}
