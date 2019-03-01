//
//  ExpressiontTree.swift
//  Calculator
//
//  Created by Holland Clarke on 3/1/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

class ExpressionTree {
    
    var data: String!
    var leftChild: ExpressionTree?
    var rightChild: ExpressionTree?
    
    init() {
        self.data = ""
        self.leftChild = nil
        self.rightChild = nil
    }
}
