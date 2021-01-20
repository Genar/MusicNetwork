//
//  AsyncOperation.swift
//  MusicNetwork
//
//  Created by Genar Codina Reverter on 13/1/21.
//  Copyright © 2021 Genar Codina Reverter. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    
    enum State: String {
        
        case ready, executing, finished

        fileprivate var keyPath: String {
            
            return "is\(rawValue.capitalized)"
        }
    }

    var state = State.ready {
        
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    // It is mandatory that you include a check to the base class' isReady method
    // as your code isn’t aware of everything that goes on while
    //the scheduler determines whether or not it is ready to find your operation a thread to use.
    override var isReady: Bool {
        
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        
        return state == .executing
    }

    override var isFinished: Bool {
        
        return state == .finished
    }

    // Specify that you are in fact using an asynchronous operation
    override var isAsynchronous: Bool {
        
        return true
    }

    // MARK: - Use in case we do not need to cancel an operation
//    override func start() {
//
//        main()
//        state = .executing
//    }
    
    // MARK: - Use in case we want to cancel an operation
    override func start() {
        
        if isCancelled {
            
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
}
