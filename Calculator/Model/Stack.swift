//
//  Stack.swift
//  Calculator
//
//  Created by Holland Clarke on 3/1/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

struct Stack<T> {
    
    fileprivate var array : [T] = []
    
    public func isEmpty() -> Bool {
        return array.isEmpty
    }
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
       
        if !isEmpty() {
            return array.popLast()
        } else {
            return nil
        }
    }
    
    public func peek() -> T? {
        if !isEmpty() {
            return array.last
        } else {
            return nil
        }
    }
}

extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator { curr.pop() }
    }
}
