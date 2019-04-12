//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol ISelectWebImageDelegate: class {
    func didFetchNewPage(imagesInfo: [PixabayImageInfo])
}

protocol IDequeuedItemInCollection: class {
    func didDequeuedCellAt(row: Int)

}

protocol ISelectWebImageService: IPaginatingDelegate, IDequeuedItemInCollection {

    var requestSender: IRequestSender { get }

    var delegate: ISelectWebImageDelegate? { get set }
    
    var loadingDelegate: ILoadingItemsStateDelegate? { get set }

    var state: IPaginatingState { get }
}

protocol ILoadingItemsStateDelegate: class {
    func didStartLoading()
    func didFinishLoading()
}

class SelectWebImageService: ISelectWebImageService {

    weak var loadingDelegate: ILoadingItemsStateDelegate?
    
    weak var delegate: ISelectWebImageDelegate?

    var requestSender: IRequestSender

    var state: IPaginatingState

    init(requestSender: IRequestSender = DefaultRequestSender(), state: IPaginatingState) {
        self.requestSender = requestSender
        self.state = state
        self.state.delegate = self
    }

    func didDequeuedCellAt(row: Int) {
        //et neededPage = (row + 1) / self.state.itemsPerPage
        self.state.didRequestPage(item: row)
    }

    func shouldFetchNewPage(page: Int) {
        let config = RequestFactory.PixabayRequests.fetchPixabayImagesInfo(page: page)
        self.loadingDelegate?.didStartLoading()
        self.requestSender.send(requestConfig: config) { (result) in
            self.loadingDelegate?.didFinishLoading()
            switch result {
            case .success(let imagesInfo):
                self.delegate?.didFetchNewPage(imagesInfo: imagesInfo.hits)
            case .error(let errString):
                Logger.log(errString)
            }
        }
    }




}
