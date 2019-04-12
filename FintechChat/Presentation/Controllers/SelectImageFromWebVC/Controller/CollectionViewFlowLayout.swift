//
//  CollectionViewFlowLayout.swift
//  FintechChat
//
//  Created by Ирина Улитина on 11/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol IDidSelectItemDelegate: class {
    func didSelectItem(item: IPixabyImageInfo?, indexPath: IndexPath)
    func didDeselectItem()
}

protocol ISelectImageFromWebFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    var spacing: CGFloat { get set }
    var columnsCount: Int { get set }
    
    var delegate: IDidSelectItemDelegate? { get set }
    
    var dataSource: IWebImagesDataSource? { get set }
}


class SelectImageFromWebFlowLayout: NSObject, ISelectImageFromWebFlowLayout {
    
    weak var dataSource: IWebImagesDataSource?
    
    weak var delegate: IDidSelectItemDelegate?
    
    var spacing: CGFloat
    
    var columnsCount: Int
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        Logger.log(width.description)
        let itemWidth = (width - spacing * CGFloat(columnsCount + 1)) / CGFloat(columnsCount) - 1e-9
        Logger.log(itemWidth.description)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
            collectionView.deselectItem(at: indexPath, animated: false)
            self.delegate?.didDeselectItem()
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItem(item: self.dataSource?.items[indexPath.row], indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.didDeselectItem()
    }
    
    init(spacing: CGFloat, columnsCount: Int = 3) {
        self.spacing = spacing
        self.columnsCount = columnsCount
    }
}
