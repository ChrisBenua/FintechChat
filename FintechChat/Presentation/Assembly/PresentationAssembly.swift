//
//  PresentationAssembly.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    func themesViewController(completionHandler: @escaping (UIColor) -> Void) -> ThemesViewController
    
    func conversationController(with conversation: Conversation, dialogTitle: String, connectedUserID: String) -> ConversationViewController
    
    func conversationListViewController() -> ConversationListViewController
    
    func profileViewController() -> ProfileViewController
    
    func setCommunicatorDelegate(delegate: CommunicatorDelegate)

    func setOnDisconnectDelegate(delegate: OnUserDisconnectedDelegate)
    
    func selectImageFromWebController() -> SelectImageFromWebViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    func selectImageFromWebController() -> SelectImageFromWebViewController {
        let itemsLoader = self.serviceAssembly.generateNewItemsLoader()
        let dataSource = WebImageDataSource<WebItemCollectionViewCell>()
        itemsLoader.delegate = dataSource
        let layout = SelectImageFromWebFlowLayout(spacing: 5)
        layout.dataSource = dataSource
        let model = SelectImageFromWebModel(imageService: self.serviceAssembly.imageLoaderService, itemsService: itemsLoader, dataSource: dataSource, layout: layout)
        let viewController = SelectImageFromWebViewController(model: model, cellClass: WebItemCollectionViewCell.self)
        dataSource.onDequeudCellDelegate = model
        model.hasSelectedItemDelegate = viewController
        itemsLoader.loadingDelegate = viewController
        return viewController
    }
    
    var conversationListModel: IConversationListModel!
    
    var conversationDataSource: IConversationTableViewDataSource!
    
    var conversationDataProvider: IConversationDataProvider!
    
    func setCommunicatorDelegate(delegate: CommunicatorDelegate) {
        self.serviceAssembly.communicator.contollerDataProvider = delegate
    }
    
    func setOnDisconnectDelegate(delegate: OnUserDisconnectedDelegate) {
        self.serviceAssembly.communicator.communicator.onDisconnectDelegate = delegate
    }
    
    private var serviceAssembly: IServiceAssembly
    
    func themesViewController(completionHandler: @escaping (UIColor) -> Void) -> ThemesViewController {
        return ThemesViewController(themesService: ThemeModel(service: ThemeViewControllerService()), completionHandler: completionHandler)
    }
    
    func conversationController(with conversation: Conversation, dialogTitle: String, connectedUserID: String) -> ConversationViewController {
        let discService = OnDisconnectedService()
        let convViewControllerModel = ConversationViewControllerModel(storage: self.serviceAssembly.storageCoordinator, communicator: self.serviceAssembly.communicator, disconnectService: discService, dialogTitle: dialogTitle, connectedUserID: connectedUserID)
        let viewController = ConversationViewController(conversationListDataProvider: self.conversationDataProvider, conversation: conversation, model: convViewControllerModel, assembly: self)
        discService.viewController = viewController
        
        return viewController
    }
    
    func conversationListViewController() -> ConversationListViewController {
        self.conversationListModel = ConversationListModel(storage: self.serviceAssembly.storageCoordinator, communicator: self.serviceAssembly.communicator, appearanceService: AppearanceService())
        self.conversationDataProvider = ConversationListDataProvider(model: ConversationListDataProviderModel(storageManager: self.serviceAssembly.storageCoordinator, communicator: self.serviceAssembly.communicator))
        self.conversationDataSource = ConversationDataSource(viewModel: self.conversationDataProvider)
        return ConversationListViewController(viewModel: self.conversationDataProvider, model: self.conversationListModel, assembly: self, conversationDataSource: self.conversationDataSource)
    }
    
    func profileViewController() -> ProfileViewController {
        var coordinator = self.serviceAssembly.photoActionCoordinator
        coordinator.presentationAssembly = self
        return ProfileViewController.init(profileModel: ProfileModel(imagePicker: self.serviceAssembly.imagePickerService, cameraService: self.serviceAssembly.cameraAccessService, photoService: self.serviceAssembly.photoActionService, galleryService: self.serviceAssembly.selectFromGalleryService, retryService: self.serviceAssembly.retryAlertService, storage: self.serviceAssembly.storageCoordinator, photoActionCoordinator: coordinator, communicator: self.serviceAssembly.communicator, imageDownloadingService: ImageDownloadingService()), assembly: self)
    }
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
}
