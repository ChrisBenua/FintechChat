//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IPassSelectedItemDelegate: class {
    func userDidSelect(item: IPixabyImageInfo?)
    func passLowResolutionImage(image: UIImage?)
}

protocol IHasSelectedItemDelegate: class {
    func hasSelectedItem(hasItem: Bool)
}

protocol ISelectImageFromWebModel: IDequeuedItemInCollection, IDidSelectItemDelegate {
    var imageService: IImageDownloadingService { get }
    var itemsService: ISelectWebImageService { get }
    var dataSource: IWebImagesDataSource { get } 
    var layout: ISelectImageFromWebFlowLayout { get }
    var selectedItem: IPixabyImageInfo? { get set }
    var hasSelectedItemDelegate: IHasSelectedItemDelegate? { get set }
    var onPassItemDelegate: IPassSelectedItemDelegate? { get set }
    
    func onViewWillDissappear()
}

class SelectImageFromWebModel: ISelectImageFromWebModel {
    
    func onViewWillDissappear() {
        self.onPassItemDelegate?.userDidSelect(item: self.selectedItem)
        if let selectedIndexPath = self.dataSource.collection.indexPathsForSelectedItems?.first {
            self.onPassItemDelegate?.passLowResolutionImage(image: (self.dataSource.collection.cellForItem(at: selectedIndexPath) as? IWebItemCollectionViewCell)?.cellImageView.image)
        }
    }
    
    weak var onPassItemDelegate: IPassSelectedItemDelegate?
    
    weak var hasSelectedItemDelegate: IHasSelectedItemDelegate?
    
    func didDeselectItem() {
        self.selectedItem = nil
    }

    var selectedItem: IPixabyImageInfo? {
        didSet {
            self.hasSelectedItemDelegate?.hasSelectedItem(hasItem: self.selectedItem != nil)
        }
    }
    
    func didSelectItem(item: IPixabyImageInfo?, indexPath: IndexPath) {
        self.selectedItem = item
    }
    
    var imageService: IImageDownloadingService
    
    var itemsService: ISelectWebImageService
    
    var dataSource: IWebImagesDataSource
    
    var layout: ISelectImageFromWebFlowLayout
    
    func didDequeuedCellAt(row: Int) {
        self.itemsService.didDequeuedCellAt(row: row)
    }
    
    init(imageService: IImageDownloadingService, itemsService: ISelectWebImageService, dataSource: IWebImagesDataSource, layout: ISelectImageFromWebFlowLayout) {
        self.imageService = imageService
        self.itemsService = itemsService
        self.dataSource = dataSource
        self.layout = layout
        self.itemsService.delegate = self.dataSource
        self.layout.delegate = self
    }

}
