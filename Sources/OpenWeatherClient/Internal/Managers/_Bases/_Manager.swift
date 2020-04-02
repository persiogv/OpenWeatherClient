//
//  _Manager.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 16/03/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

class Manager: OperationQueue {
    
    override init() {
        super.init()
        name = String(describing: self)
    }
    
    func executeInMainQueue(operation: Operation) {
        OperationQueue.main.addOperation(operation)
    }
    
    deinit {
        cancelAllOperations()
    }
}
