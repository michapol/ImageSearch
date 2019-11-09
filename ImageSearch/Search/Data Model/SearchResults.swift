//
//  SearchResults.swift
//  Candyspace
//
//  Created by Mike Pollard on 12/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import Foundation

class SearchResults: Codable {
    
    var totalHits: Int
    var hits: [SearchHit]
    
}

class SearchHit: Codable {
 
    var id: Int
    var user_id: Int
    var user: String
    var userImageURL: String
    
    var largeImageURL: String
    var imageWidth: Int
    var imageHeight: Int
    
    var webformatURL: String
    var webformatWidth: Int
    var webformatHeight: Int
    
    var previewURL: String
    var previewWidth: Int
    var previewHeight: Int
    
    var likes: Int
    var views: Int
    var comments: Int
    var pageURL: String
    var type: String
    var tags: String
    var downloads: Int
    var favorites: Int
    var imageSize: Int

}
