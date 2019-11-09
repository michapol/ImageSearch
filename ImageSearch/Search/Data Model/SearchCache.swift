//
//  SearchCache.swift
//  Candyspace
//
//  Created by Mike Pollard on 12/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit

class SearchCache {
    
    var items: [SearchItem] = []
    
    func getCache(searchText: String, searchCategories: String) -> SearchItem? {        
        return items.first(where: { $0.searchString == searchText && $0.searchCategories == searchCategories })
    }
    
    func saveResult(searchText: String, searchCategories: String, result: SearchResults) {
        let searchItem = SearchItem(searchString: searchText, searchCategories: searchCategories, searchResult: result)
        self.items.append(searchItem)
    }
    
    func clearAllCache() {
        self.items.removeAll()
    }
    
    func reduceCache() {
        guard self.items.count > 3 else {
            self.clearAllCache()
            return
        }

        self.items = Array(self.items.prefix(3))
    }
    
}

class ImageCache {
    
    var imageURL: String = ""
    var image: UIImage?
    
    init(imageURL: String, image: UIImage) {
        self.imageURL = imageURL
        self.image = image
    }
}

class SearchItem: Equatable {

    var searchString: String = ""
    var searchCategories: String = ""
    var searchResult: SearchResults?
    var images: [ImageCache] = []
    
    init() {

    }
    
    init(searchString: String, searchCategories: String, searchResult: SearchResults) {
        self.searchString = searchString
        self.searchCategories = searchCategories
        self.searchResult = searchResult
    }
    
    static func == (lhs: SearchItem, rhs: SearchItem) -> Bool {
        if
            lhs.searchString == rhs.searchString,
            lhs.searchCategories == rhs.searchCategories
        {
            return true
        }
        return false
    }

    typealias ImageCompletion = (UIImage?)->()
    func getImage(imageURL: String, completion: @escaping ImageCompletion) -> Bool {
        if let image = images.first(where: { $0.imageURL == imageURL })?.image {
            completion(image)
            return true
        }
        
        guard let url = URL(string: imageURL) else { completion(nil); return false }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                self.saveImage(imageURL: imageURL, image: image)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
        
        return false
    }
    
    private func saveImage(imageURL: String, image: UIImage?) {
        guard let image = image else { return }
        let imageCache = ImageCache(imageURL: imageURL, image: image)
        self.images.append(imageCache)
    }
}


