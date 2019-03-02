//
//  ExpressiontTree.swift
//  Calculator
//
//  Created by Holland Clarke on 3/1/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

public class ExpressionTree {
    
    var data: String!
    var leftChild: ExpressionTree?
    var rightChild: ExpressionTree?
    
    init() {
        self.data = ""
        self.leftChild = nil
        self.rightChild = nil
    }
}

fileprivate func isOperator(str: String) -> Bool {
    var isOperator = false
    
    if str == "*" { isOperator = true }
    if str == "/" { isOperator = true }
    if str == "+" { isOperator = true }
    if str == "%" { isOperator = true }
    if str == "-" { isOperator = true }
    if str == "^" { isOperator = true }
    
    return isOperator
}

fileprivate func createNewNode(str: String) -> ExpressionTree {
    let newNode = ExpressionTree()
    newNode.data = str
    return newNode
}

public func constructTree(str: String) -> ExpressionTree {
    
    var treeStack = Stack<ExpressionTree>()
    var t, t1, t2 : ExpressionTree
    
    for token in str.split(separator: " ") {
        let tokenToString = String(token)
        if (!isOperator(str: tokenToString)) {
            t = createNewNode(str: tokenToString)
            treeStack.push(t)
        } else {
            t = createNewNode(str: tokenToString)
            
            // Pop the two nodes from the stack
            // We know that we will have at least two variables in the stack because
            // the representation of the postfix will put the operator after the two digitis
            
            t1 = treeStack.peek()!
            _ = treeStack.pop()
            t2 = treeStack.peek()!
            _ = treeStack.pop()
            t.leftChild = t1
            t.rightChild = t2
            
            treeStack.push(t)
        }
    }
    t = treeStack.peek()!
    _ = treeStack.pop()
    
    return t
}

public func evaluateTree(_ tree: ExpressionTree?) -> Double {
    let calculator = Calculator()
    if tree == nil {
        return 0.0
    }
    if tree?.leftChild == nil && tree?.rightChild == nil {
        return Double(tree!.data) ?? 0
    }
    
    let leftVal = evaluateTree(tree?.leftChild)
    let rightVal = evaluateTree(tree?.rightChild)
    var ans: Double = 0
    
    if tree?.data == "+" { ans = calculator.add(leftVal, rightVal)}
    if tree?.data == "-" { ans = calculator.subtract(rightVal, leftVal)}
    if tree?.data == "*" { ans = calculator.multiply(leftVal, rightVal)}
    if tree?.data == "/" { ans = calculator.divide(rightVal, leftVal)}
    if tree?.data == "%" { ans = calculator.modulo(rightVal, leftVal)}
    if tree?.data == "^" { ans = calculator.power(rightVal, leftVal)}
    return ans
}


