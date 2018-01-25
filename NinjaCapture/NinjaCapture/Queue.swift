//
//  Queue.swift by swift-algorithm-club
//  NinjaCapture
//
//  Created by Igor Yunash on 25.01.18.
//  Copyright © 2018 Igralino. All rights reserved.
//

public struct Queue<T> {
    var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public var front: T? {
        return array.first
    }
}
