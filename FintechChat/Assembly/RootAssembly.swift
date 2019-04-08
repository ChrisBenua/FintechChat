//
//  RootAssembly.swift
//  FintechChat
//
//  Created by Ирина Улитина on 05/04/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation

protocol IRootAssembly {
    var serviceAssembly: IServiceAssembly { get set }
    var coreAssembly: ICoreAssembly { get set }
    var presentationAssembly: IPresentationAssembly { get set }
}

class RootAssembly: IRootAssembly {
    lazy var serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: self.coreAssembly)
    
    lazy var coreAssembly: ICoreAssembly = CoreAssembly()
    
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    
}
