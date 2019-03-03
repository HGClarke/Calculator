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

// Functions evaluates the post fix string to ensure
// that it is valid
public func isValidPostFix(_ str: String) -> Bool {
    // initialize the counter to 0
    var counter = 0
    
    // Check every literal or operator in the string
    for token in str.split(separator: " ") {
        let tokenToString = String(token)
        
        // If the token is an operator we decrement the counter by two
        // then increment it by 1
        if tokenToString == "*" {
            counter = counter - 2
            counter = counter + 1

        }
        else if tokenToString == "/" {
            counter = counter - 2
            counter = counter + 1

        }
        else if tokenToString == "%" {
            counter = counter - 2
            counter = counter + 1
        }
        else if tokenToString == "+" {
            counter = counter - 2
            counter = counter + 1
            
        }
        else if tokenToString == "-" {
            counter = counter - 2
            counter = counter + 1
            
        }
            
        else if tokenToString == "^" {
            counter = counter - 2
            counter = counter + 1
            
        }
        // If the token is a digit we increment it by one
        else { counter = counter + 1 }
    }
    
    // if counter is equal to 1 at the end of this operation then
    // the string is a valid postfix representation
    return counter == 1
}
