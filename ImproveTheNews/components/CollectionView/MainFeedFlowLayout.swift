//
//  MainFeedFlowLayout.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 27/09/2022.
//

import Foundation
import UIKit


class MainFeedFlowLayout: UICollectionViewFlowLayout {
    
}



class CustomFlowLayout: UICollectionViewFlowLayout {
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
//        layoutAttributesObjects?.forEach({ layoutAttributes in
//            if layoutAttributes.representedElementCategory == .cell {
//                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
//                    layoutAttributes.frame = newFrame
//                }
//            }
//        })
//        return layoutAttributesObjects
//    }
//    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
//        else { return nil }
//        
////        let cell = self.collectionView!.cellForItem(at: indexPath)
////
////
////        if let _cell = cell as? ArticleCO_cell {
////            attributes.frame.origin.x = (SCREEN_SIZE().width/2) * CGFloat(_cell.column-1)
////        }
//        
//        attributes.frame.origin.x = 0
//        
//        return attributes
//    }
    
}



class CustomFlowLayout_B: AlignedCollectionViewFlowLayout {
//class CustomFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        return layoutAttributesObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
//        let cell = collectionView!.cellForItem(at: indexPath)
//
//        var W = SCREEN_SIZE().width
//        var X: CGFloat = 0
//        if(cell is StoryCO_cell || cell is ArticleCO_cell) {
//            W /= 2
//            let column = (cell as! StoryCO_cell).column
//            X = W * CGFloat(column - 1)
//        }
//
//        currentAttributes.frame.origin.x = X
//        currentAttributes.frame.size.width = W


        guard let currentAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        currentAttributes.frame.size.width = SCREEN_SIZE().width

        return currentAttributes
        
         


//        guard let collectionView = collectionView else { fatalError() }
//
//        var prevAttributes: UICollectionViewLayoutAttributes?
//
//        if(indexPath.row>0) {
//            let prevIndexPath = IndexPath(row: indexPath.row-1, section: indexPath.section)
//            prevAttributes = super.layoutAttributesForItem(at: prevIndexPath)?.copy() as? UICollectionViewLayoutAttributes
//        }
//
//
//
//
//        guard let currentAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
//            return nil
//        }
//
//
//        var W: CGFloat = SCREEN_SIZE().width
//        var X: CGFloat = 0
//
//        if(prevAttributes != nil) {
//            print(indexPath.row)
//            print(prevAttributes!.frame)
//            print("----------------")
//        }
//
//        if let _cell = collectionView.cellForItem(at: indexPath) as? StoryCO_cell {
//            W = W/2
//        }
//
//        currentAttributes.frame.origin.x = X
//        currentAttributes.frame.size.width = W
//
//        return currentAttributes
    }
    
}

//class CustomFlowLayout: AlignedCollectionViewFlowLayout {
//
//    init() {
//        super.init(horizontalAlignment: .left, verticalAlignment: .top)
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
