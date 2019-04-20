//
//  SelectImageFromWebViewController.swift
//  FintechChat
//
//  Created by Ирина Улитина on 11/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class SelectImageFromWebViewController: UIViewController {
    var logoService: ITinkoffLogosService = TinkoffLogosService()
    var model: ISelectImageFromWebModel
    var cellClass: IWebItemCollectionViewCell.Type
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        return indicator
    }()
    
    lazy var collectionView: UICollectionView = {
        let colView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        colView.dataSource = self.model.dataSource
        colView.delegate = self.model.layout
        colView.translatesAutoresizingMaskIntoConstraints = false
        colView.register(self.cellClass, forCellWithReuseIdentifier: self.cellClass.reuseIdentifier)
        
        return colView
    }()
    
    lazy var doneBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonOnClick(_:)))
        button.isEnabled = false
        return button
    }()
    
    init(model: ISelectImageFromWebModel, cellClass: IWebItemCollectionViewCell.Type) {
        self.model = model
        self.cellClass = cellClass
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func backButtonOnClick(_ sender: Any?) {
        self.model.selectedItem = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonOnClick(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.model.onViewWillDissappear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pixabay"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonOnClick(_:)))
        self.navigationItem.rightBarButtonItem = self.doneBarButton
        
        self.model.dataSource.collection = self.collectionView
        self.view.addSubview(collectionView)
        collectionView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //fetch initial data
        self.model.didDequeuedCellAt(row: 0)
        self.addTinkoffTapListener()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectImageFromWebViewController: IHasSelectedItemDelegate {
    func hasSelectedItem(hasItem: Bool) {
        self.doneBarButton.isEnabled = hasItem
    }
}

extension SelectImageFromWebViewController: ILoadingItemsStateDelegate {
    func didStartLoading() {
        self.showActivityIndicator()
    }
    
    func didFinishLoading() {
        self.dismissActivityIndicator()
    }
}

// MARK: - Activity Indicator
extension SelectImageFromWebViewController {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.frame = CGRect(x: (self.view.bounds.width) / 2 - 20, y: (self.view.bounds.height) / 2 - 20, width: 40, height: 40)
            self.activityIndicator.startAnimating()
        }
    }
    
    func dismissActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}

extension SelectImageFromWebViewController: ITinkoffLogosController {
    func addTinkoffTapListener() {
        logoService.setup(view: self.view, time: 0.2)
    }
    
    
}
