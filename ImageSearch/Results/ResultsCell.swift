//
//  ResultsCell.swift
//  Candyspace
//
//  Created by Mike Pollard on 12/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit

class ResultsCell: UICollectionViewCell {
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    func setup(hit: SearchHit, cache: SearchItem) {
        
        if let previewImage = self.previewImage {
            _ = cache.getImage(imageURL: hit.webformatURL) { (image) in
                DispatchQueue.main.async {
                    previewImage.image = image
                }
            }
        }
        
        if let typeLabel = self.typeLabel {
            typeLabel.text = "Type: \(hit.type)"
        }
        
        if let sizeLabel = self.sizeLabel {
            sizeLabel.text = "Size: \(hit.imageWidth)x\(hit.imageHeight)"
        }
        
    }
    
    override func prepareForReuse() {
        if let previewImage = self.previewImage {
            previewImage.image = nil
        }
        
        if let typeLabel = self.typeLabel {
            typeLabel.text = nil
        }
        
        if let sizeLabel = self.sizeLabel {
            sizeLabel.text = nil
        }
    }
    
}
