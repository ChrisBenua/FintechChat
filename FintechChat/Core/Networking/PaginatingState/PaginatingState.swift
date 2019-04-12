//
// Created by Ирина Улитина on 2019-04-11.
// Copyright (c) 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IPaginatingDelegate: class {
    func shouldFetchNewPage(page: Int)
}

protocol IPaginatingState {
    var itemsPerPage: Int { get }

    var lastLoadedPage: Int { get set }

    func didLeaveController()

    func didRequestPage(item: Int)

    var delegate: IPaginatingDelegate? { get set }
}

class PaginatingState: IPaginatingState {

    func didRequestPage(item: Int) {
        let prevVal = self.lastLoadedPage
        self.lastLoadedPage = max((item + 1 + self.itemsPerPage) / self.itemsPerPage, self.lastLoadedPage)
        if self.lastLoadedPage > prevVal {
            self.delegate?.shouldFetchNewPage(page: self.lastLoadedPage)
        }
    }

    var itemsPerPage: Int = 20

    var lastLoadedPage: Int = 0

    func didLeaveController() {
        self.lastLoadedPage = 0
    }

    weak var delegate: IPaginatingDelegate?

    init(delegate: IPaginatingDelegate?) {
        self.delegate = delegate
    }
    
    init() {
        
    }
}
