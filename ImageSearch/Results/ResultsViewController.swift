//
//  ResultsViewController.swift
//  Candyspace
//
//  Created by Mike Pollard on 12/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cache: SearchItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.cache != nil {
            collectionView.register(UINib(nibName: "ResultsCell", bundle: .main), forCellWithReuseIdentifier: "ResultsCell")
            (collectionView.collectionViewLayout as? ResultsLayout)?.resultLayoutDelegate = self
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
}


extension ResultsViewController: ResultsLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, sizeForImageAt indexPath: IndexPath) -> CGSize {
        guard let results = self.cache?.searchResult else { return CGSize.zero }
        guard indexPath.item < results.hits.count else { return CGSize.zero }
        
        let hit = results.hits[indexPath.item]
        
        return CGSize(width: hit.previewWidth, height: hit.previewHeight)
    }
    
}


extension ResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let results = self.cache?.searchResult else { return 0 }
        return results.hits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultsCell", for: indexPath)
        
        if let cell = cell as? ResultsCell, let cache = self.cache, let results = cache.searchResult, indexPath.item < results.hits.count {
            let hit = results.hits[indexPath.item]
            cell.setup(hit: hit, cache: cache)
        }
        
        return cell
    }
    
}
