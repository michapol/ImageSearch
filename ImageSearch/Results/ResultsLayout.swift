//
//  ResultsLayout.swift
//  Candyspace
//
//  Created by Mike Pollard on 12/10/2019.
//  Copyright © 2019 Mike Pollard. All rights reserved.
//

import UIKit

protocol ResultsLayoutDelegate: class {
    func collectionView(collectionView: UICollectionView, sizeForImageAt indexPath: IndexPath) -> CGSize
}

class ResultsLayout: UICollectionViewLayout {
    
    weak var resultLayoutDelegate: ResultsLayoutDelegate?
    
    private var attributeCache: [UICollectionViewLayoutAttributes] = []
    
    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0.0 }
        let contentInsets = collectionView.contentInset
        return collectionView.bounds.width - (contentInsets.left + contentInsets.right)
    }
    private var contentHeight: CGFloat = 0.0
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = self.collectionView else { return }
        guard let resultsDelegate = self.resultLayoutDelegate else { return }
        
        self.attributeCache.removeAll()
        
        let cellLabelHeight: CGFloat = 51.0
        
        let numberOfColumns: Int = 3
        let cellPadding: CGFloat = 5
        let cellWidth: CGFloat = (self.contentWidth - cellPadding * (CGFloat(numberOfColumns - 1))) / CGFloat(numberOfColumns)
        var currentColumn: Int = 0
        
        var yOffset: [CGFloat] = .init(repeating: collectionView.contentInset.top + cellPadding, count: numberOfColumns)
        
        // Assuming always 1 section
        for index in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let previewSize = resultsDelegate.collectionView(collectionView: collectionView, sizeForImageAt: indexPath)
            let previewRatio = previewSize.height / previewSize.width
            let cellHeight = cellWidth * previewRatio + cellLabelHeight
            
            let cellFrame = CGRect(
                x: CGFloat(currentColumn) * (cellWidth + cellPadding),
                y: yOffset[currentColumn],
                width: cellWidth,
                height: cellHeight
            )
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = cellFrame
            self.attributeCache.append(attribute)
            
            yOffset[currentColumn] += cellHeight + cellPadding
            currentColumn = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
//            currentColumn = currentColumn + 1 == numberOfColumns ? 0 : currentColumn + 1
        }
        
        self.contentHeight = yOffset.max() ?? 0.0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributeCache.filter({ $0.frame.intersects(rect) })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributeCache[indexPath.item]
    }
    
}
