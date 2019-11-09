//
//  ImageSearchTests.swift
//  ImageSearchTests
//
//  Created by Mike Pollard on 09/11/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import XCTest
@testable import ImageSearch

class ImageSearchTests: XCTestCase {

    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testNoCache() {
        let searchCache = SearchCache()
        XCTAssertNil(searchCache.getCache(searchText: "test", searchCategories: "photo"))
    }
    
    func testSaveAndGetFromCache() {
        let searchItem = SearchItem()
        searchItem.searchString = "test"
        searchItem.searchCategories = "photo"
        
        let searchCache = SearchCache()
        searchCache.items.append(searchItem)
        
        XCTAssertNil(searchCache.getCache(searchText: "notTest", searchCategories: "photo"))
        XCTAssertNotNil(searchCache.getCache(searchText: "test", searchCategories: "photo"))
        XCTAssertEqual(searchCache.getCache(searchText: "test", searchCategories: "photo"), searchItem)
        
        searchItem.searchString = "test1"
        XCTAssertNotEqual(searchCache.getCache(searchText: "test", searchCategories: "photo"), searchItem)
    }
    
    func testClearCache() {
        let searchItem = SearchItem()
        searchItem.searchString = "test"
        searchItem.searchCategories = "photo"
        
        let searchCache = SearchCache()
        searchCache.items.append(searchItem)
        
        searchCache.clearAllCache()
        
        XCTAssertNil(searchCache.getCache(searchText: "test", searchCategories: "photo"))
    }
    
    func testImageNoCache() {
        let searchItem = SearchItem()
        XCTAssertFalse(searchItem.getImage(imageURL: "https://cdn.pixabay.com/photo/2018/01/05/16/24/rose-3063284_150.jpg") { (image) in
            XCTAssertNotNil(image)
        })
    }
    
    func testImageCache() {
        let searchItem = SearchItem()
        _ = searchItem.getImage(imageURL: "https://cdn.pixabay.com/photo/2018/01/05/16/24/rose-3063284_150.jpg") { (image) in
            XCTAssertNotNil(image)
            XCTAssertTrue(searchItem.getImage(imageURL: "https://cdn.pixabay.com/photo/2018/01/05/16/24/rose-3063284_150.jpg") { (image) in
                XCTAssertNotNil(image)
            })
        }
    }
    
    func testSearchSpeed() {
        let searchController = SearchController()
        self.measure {
            searchController.search(searchText: "dog", searchCategories: "all", completion: { (searchItem) in
                XCTAssertNotNil(searchItem?.searchResult)
            })
        }
    }

}
