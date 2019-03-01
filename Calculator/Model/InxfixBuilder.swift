//
//  ShuntingYard.swift
//  Calculator
//
//  Created by Holland Clarke on 3/1/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

internal enum Associativity {
    
    case leftAssociative
    case rightAssociative
    
}
// When the string is passed to the Post fix builder
// the possible types it will be is either an operation (e.g addition, subtraction etc.)
// Or a real number
public enum TokenType {
    
    case operation(OperatorToken)
    case number(Double)
    
    public var description : String {
        switch self {
        case .operation(let operatorToken):
            return operatorToken.description
        case .number(let value):
            return value.description
        }
    }
}

public enum Operations {
    
    case addition
    case subtraction
    case division
    case multiplication
    case modulo
    
    public var description: String {
        
        switch self {
        case .addition:
            return "+"
        case .subtraction:
            return "-"
        case .division:
            return "/"
        case.multiplication:
            return "*"
        case .modulo:
            return "%"
        }
        
    }
}

public struct OperatorToken {
    
    let operation: Operations
    
    init(operation: Operations) {
        self.operation = operation
    }
    
    // Addition and subtraction will have a lower precedence than
    // division, multiplication and modulo
    var tokenPrecedence: Int {
        var precedence = 0

        switch operation {
        // Assign va value of 0 for the precedence of addition and subtraction
        case .addition, .subtraction:
            precedence = 0
            
        // Assign a value of 5 for the precedence for operations:
        // multiplication, modulo and division
        case .multiplication, .modulo, .division:
            precedence = 5
        }
        return precedence
    }
    
    // Operation associativity
    var associativity: Associativity {
        switch operation {
        // All
        case .addition, .division, .subtraction, .multiplication, .modulo:
            return .leftAssociative
        
        // If exponent button is added to this calculator then we will modify
        // The calculator because exponses will have right associativity
      //  default:
        //    return .rightAssociative
        }
    }
    
    public var description: String {
        return operation.description
    }
}

func <= (leftOperationToken: OperatorToken, rightOperatorToken: OperatorToken) -> Bool {
    return leftOperationToken.tokenPrecedence <= rightOperatorToken.tokenPrecedence
}

func < (leftOperationToken: OperatorToken, rightOperatorToken: OperatorToken) -> Bool {
    return leftOperationToken.tokenPrecedence <= rightOperatorToken.tokenPrecedence
}

public struct Token {
   
    let tokenType: TokenType
    
    init (value: Double) {
        self.tokenType = .number(value)
    }
    
    init(operation: Operations) {
        self.tokenType = .operation(OperatorToken(operation: operation))
    }
    
    var isOperator: Bool {
        switch tokenType {
        case .operation(_):
            return true
        default:
            return false
        }
    }
    
    var operatorToken: OperatorToken? {
        switch tokenType {
        case .operation(let token):
            return token
        default:
            return nil
        }
    }
    
    public var description : String {
        return tokenType.description
    }
}

// Converts infix notation into postfix notation
public class InxfixBuilder {
    private var expression : [Token] = []
    
    func addOperatorToExpression(_ operation: Operations) -> InxfixBuilder {
        expression.append(Token(operation: operation))
        return self
    }
    
    func addOperandToExpression(_ operand: Double) -> InxfixBuilder {
        expression.append(Token(value: operand))
        return self
    }
    
    public func build() -> [Token] {
        // TODO: Ensure that the infix notation is validf
        return expression
    }
    
}
