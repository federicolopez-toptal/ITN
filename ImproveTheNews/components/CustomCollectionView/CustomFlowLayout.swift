//
//  CustomFlowLayout.swift
//  ImproveTheNews
//
//  Created by Federico Lopez on 05/10/2022.
//

import UIKit


class CustomFlowLayout: UICollectionViewFlowLayout {

    private var frames = [Int: CGRect]()

    func resetCache() {
        self.frames = [Int: CGRect]()
    }
    
    private func getFrame(index: Int) -> CGRect? {
        return self.frames[index]
    }

    // --------------------
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // We may not change the original layout attributes or UICollectionViewFlowLayout might complain.
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        let currentIndex = attributes.indexPath.row
        
        if let prevSetFrame = self.getFrame(index: currentIndex) {
            attributes.frame = prevSetFrame
            return attributes
        }
        
        // ------
        guard let cvWidth = collectionView?.frame.size.width else {
            return nil
        }
        
        if(currentIndex == 0) {
            attributes.frame.origin = .zero
            self.frames[currentIndex] = attributes.frame
        } else {
            if let prevFrame = self.getFrame(index: currentIndex-1) {
                let prevEndX = prevFrame.origin.x + prevFrame.size.width

                if(prevEndX + attributes.frame.size.width <= cvWidth) {
                    attributes.frame.origin = CGPoint(x: prevEndX, y: prevFrame.origin.y)
                    self.frames[currentIndex] = attributes.frame
                } else {
                    var prevEndY = prevFrame.origin.y + prevFrame.size.height
                    if(currentIndex > 1) {
                        if let prevFrame2 = self.getFrame(index: currentIndex-2) {
                            if(prevFrame2.origin.y == prevFrame.origin.y) {
                                let prevEndY2 = prevFrame2.origin.y + prevFrame2.size.height
                                if(prevEndY2 > prevEndY) { prevEndY = prevEndY2 }
                            }
                        }
                    }

                    attributes.frame.origin = CGPoint(x: 0, y: prevEndY)
                    self.frames[currentIndex] = attributes.frame
                }
            }
            
//            if let prevFrame = self.getFrame(index: currentIndex-1) {
//                var prevEndY = prevFrame.origin.y + prevFrame.size.height
//                attributes.frame.origin = CGPoint(x: 0, y: prevEndY)
//
//                self.frames[currentIndex] = attributes.frame
//            } else {
//                print("nope")
//            }
        }

        return attributes
    }

    // ----------------------
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // We may not change the original layout attributes or UICollectionViewFlowLayout might complain.
        let layoutAttributesObjects = copy(super.layoutAttributesForElements(in: rect))
        layoutAttributesObjects?.forEach({ (layoutAttributes) in
            setFrame(forLayoutAttributes: layoutAttributes)
        })
        return layoutAttributesObjects
    }
    
    private func copy(_ layoutAttributesArray: [UICollectionViewLayoutAttributes]?) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributesArray?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
    }
    
    private func setFrame(forLayoutAttributes layoutAttributes: UICollectionViewLayoutAttributes) {
        if layoutAttributes.representedElementCategory == .cell { // Do not modify header views etc.
            let indexPath = layoutAttributes.indexPath
            if let newFrame = layoutAttributesForItem(at: indexPath)?.frame {
                layoutAttributes.frame = newFrame
            }
        }
    }
}


