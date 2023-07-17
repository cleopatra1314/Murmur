//
//  TagCollectionViewFlowLayout.swift
//  Murmur
//
//  Created by cleopatra on 2023/7/16.
//

import Foundation
import UIKit

//class TagCollectionViewFlowLayout: UICollectionViewFlowLayout {
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var attributes = super.layoutAttributesForElements(in: rect)
//
//        var leftMargin = sectionInset.left
//        var maxY: CGFloat = -1.0
//
//        let attributeOfItem = layoutAttributesForItem(at: <#T##IndexPath#>)
//        attributes?.forEach { layoutAttribute in
//            if layoutAttribute.frame.origin.y >= maxY {
//                leftMargin = sectionInset.left + 16
//            }
//
//            layoutAttribute.frame.origin.x = leftMargin
//
//            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
//            maxY = max(layoutAttribute.frame.maxY, maxY)
//        }
//
//        let headerIndexPath = IndexPath(item: 0, section: 0)
//        let attributeOfHeader = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath)
//        let attributeOfFooter = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: headerIndexPath)
//        attributes?.append(attributeOfHeader!)
//        attributes?.append(attributeOfFooter!)
//
//
//        return attributes
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
//            return nil
//        }
//
//        var leftMargin = sectionInset.left
//        var maxY: CGFloat = -1.0
//
//        if attributes.frame.origin.y >= maxY {
//            leftMargin = sectionInset.left + 16
//        }
//
//        attributes.frame.origin.x = leftMargin
//
//        leftMargin += attributes.frame.width + minimumInteritemSpacing
//        maxY = max(attributes.frame.maxY, maxY)
//
////        let headerIndexPath = IndexPath(item: 0, section: 0)
////        if let attribute = layoutAttributesForSupplementaryView(ofKind: <#T##String#>, at: headerIndexPath) {
////            attributes.append(attribute)
////        }
//
//        return attributes
//    }
//
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//            guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else {
//                return nil
//            }
//
//            if elementKind == UICollectionView.elementKindSectionHeader {
////                attributes.frame.origin.x = sectionInset.left
//                attributes.frame = CGRect(x: 0, y: 0, width: collectionView?.bounds.width ?? 0, height: 180)
//            } else if elementKind == UICollectionView.elementKindSectionFooter {
//                attributes.frame.origin.x = sectionInset.left
//                attributes.frame = CGRect(x: 0, y: 0, width: collectionView?.bounds.width ?? 0, height: 50)
//            }
//
//            return attributes
//        }
//
//}


class TagCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                //                let indexPath = layoutAttribute.indexPath
                //                if let modifiedAttribute = layoutAttributesForItem(at: indexPath) {
                //                    layoutAttribute.frame = modifiedAttribute.frame
                //                }
                
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left + 16
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                
                leftMargin += layoutAttribute.frame.width + 6
                maxY = max(layoutAttribute.frame.maxY, maxY)
                
            } else if layoutAttribute.representedElementCategory == .supplementaryView {
                let indexPath = layoutAttribute.indexPath
                if layoutAttribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                    if let modifiedAttribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                        layoutAttribute.frame = modifiedAttribute.frame
                    }
                } else if layoutAttribute.representedElementKind == UICollectionView.elementKindSectionFooter {
                    if let modifiedAttribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath) {
                        layoutAttribute.frame = modifiedAttribute.frame
                    }
                }
            }
        }

        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
                return nil
            }

            var leftMargin = sectionInset.left
            var maxY: CGFloat = -1.0

            if attributes.frame.origin.y >= maxY {
                leftMargin = sectionInset.left + 16
            }

            attributes.frame.origin.x = leftMargin

            leftMargin += attributes.frame.width + minimumInteritemSpacing
            maxY = max(attributes.frame.maxY, maxY)

            return attributes
        }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        if elementKind == UICollectionView.elementKindSectionHeader {
            attributes.frame = CGRect(x: 8, y: 0, width: collectionView?.bounds.width ?? 0, height: 72)
        }

        return attributes
    }
}
