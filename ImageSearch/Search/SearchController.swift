//
//  SearchController.swift
//  Candyspace
//
//  Created by Mike Pollard on 12/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import Foundation

class SearchController {
    
    let searchURL = "https://pixabay.com/api/?key=13197033-03eec42c293d2323112b4cca6&q={{{SEARCH}}}&per_page=100&image_type="
    let searchCache = SearchCache()
    
    func search(searchText: String, searchCategories: String, completion: @escaping (SearchItem?)->()) {
        let trimmedString = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchString = trimmedString.replacingOccurrences(of: " ", with: "+")
        
        if let cache = self.searchCache.getCache(searchText: searchString, searchCategories: searchCategories) {
            completion(cache)
            return
        }
        
        var searchURL = self.searchURL.replacingOccurrences(of: "{{{SEARCH}}}", with: searchString)
        searchURL += searchCategories
        
        guard let url = URL(string: searchURL) else { return }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20.0
        let urlSession = URLSession(configuration: sessionConfig)
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(SearchResults.self, from: data)
                    self.searchCache.saveResult(searchText: searchString, searchCategories: searchCategories, result: results)
                    completion(self.searchCache.getCache(searchText: searchString, searchCategories: searchCategories))
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func reduceCache() {
        self.searchCache.reduceCache()
    }
    
}
