//
//  PostFixBuilder.swift
//  Calculator
//
//  Created by Holland Clarke on 3/1/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

public func postFixBuilder(_ expression: [Token]) -> String {
    var stack = Stack<Token>()
    
    var postFixNotation = [Token]()
    
    for token in expression {
        
        switch token.tokenType {
        case .number(_):
            postFixNotation.append(token)
        
        case .operation(let operatorToken):
            for tempToken in stack.makeIterator() {
                
                if !tempToken.isOperator {
                    break
                }
                
                if let tempOperatorToken = tempToken.operatorToken {
                    let expression1 = operatorToken.associativity == .leftAssociative
                    let expression2 = operatorToken <= tempOperatorToken
                    let expression3 = operatorToken.associativity == .rightAssociative
                    let expression4 = operatorToken < tempOperatorToken
                    if  expression1 && expression2 || expression3 && expression4 {
                        postFixNotation.append(stack.pop()!)
                    } else {
                        break
                    }
                }
            }
            stack.push(token)
        }
    }
    
    while (!stack.isEmpty()) {
        postFixNotation.append(stack.pop()!)
    }
    return postFixNotation.map({token in token.description}).joined(separator: " ")
}
