//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IWebImagesDataSource: UICollectionViewDataSource, ISelectWebImageDelegate {
    var items: [PixabayImageInfo] { get set }

    var collection: UICollectionView! { get set }
    
    var onDequeudCellDelegate: IDequeuedItemInCollection? { get set }
}

class WebImageDataSource<T: IWebItemCollectionViewCell>: NSObject, IWebImagesDataSource {

    weak var onDequeudCellDelegate: IDequeuedItemInCollection?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("OBAMA, KAK TAK?, WRONG CELL TYPE")
        }
        cell.configure(with: self.items[indexPath.row], model: ImageDownloadingService())
        self.onDequeudCellDelegate?.didDequeuedCellAt(row: indexPath.row)
        return cell
    }

    
    func didFetchNewPage(imagesInfo: [PixabayImageInfo]) {
        DispatchQueue.main.async {
            for newImageInfo in imagesInfo {
                if !self.items.contains(newImageInfo) {
                    self.items.append(newImageInfo)
                    
                    self.collection.insertItems(at: [IndexPath(row: self.items.count - 1, section: 0)])
                    
                }
            }
        }
    }

    var items: [PixabayImageInfo] = []
    var collection: UICollectionView!
    
}
