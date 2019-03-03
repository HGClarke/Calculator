//
//  Calculator.swift
//  Calculator
//
//  Created by Holland Clarke on 2/28/19.
//  Copyright © 2019 Holland Clarke. All rights reserved.
//

import Foundation

struct Calculator {
        
    func add(_ n1: Double, _ n2: Double) -> Double {
        return n1 + n2
    }
    
    func subtract(_ n1: Double, _ n2: Double) -> Double {
        return n2 - n1
    }
    
    func multiply(_ n1: Double, _ n2: Double) -> Double {
        return n1 * n2
    }
    
    func divide(_ n1: Double, _ n2: Double) -> Double {
        
        if n1 != 0 {
            return ( n2 / n1)
        }
        return 0
    }
    
    func power(_ n1: Double, _ n2: Double) -> Double {
        return pow(n2, n1)
    }
    
    func modulo(_ n1: Double, _ n2: Double) -> Double {
        return n2.truncatingRemainder(dividingBy: n1)
    }
    
    
    
}
