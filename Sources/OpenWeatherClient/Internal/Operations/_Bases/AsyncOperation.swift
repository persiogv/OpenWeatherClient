//
//  AsyncOperation.swift
//  OpenWeatherClient
//
//  Created by Pérsio on 23/10/19.
//  Copyright © 2019 Persio Vieira. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    public enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
        case cancelled = "isCancelled"
    }

    var state: State = .ready {
        willSet {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: state.rawValue)
            didChangeValue(forKey: oldValue.rawValue)
        }
    }
    
    override func main() {
        state = isCancelled
            ? .finished
            : .executing
    }
    
    final func finish() {
        state = .finished
    }

    override var isReady: Bool {
        if state == .ready {
            return super.isReady
        }
        
        return state == .ready
    }

    override var isExecuting: Bool {
        if state == .executing {
            return super.isExecuting
        }
        
        return state == .executing
    }

    override var isFinished: Bool {
        if state == .finished {
            return super.isFinished
        }
        
        return state == .finished
    }

    override var isCancelled: Bool {
        if state == .cancelled {
            return super.isCancelled
        }
        
        return state == .cancelled
    }

    override var isAsynchronous: Bool {
        return true
    }
}
