//
//  Diamond.swift
//  Set Game
//
//  Created by Daniel Luo on 4/6/21.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addLines([
            CGPoint(x: rect.width / 2, y: 0),
            CGPoint(x: rect.width, y: rect.height / 2),
            CGPoint(x: rect.width / 2, y: rect.height),
            CGPoint(x: 0, y: rect.height / 2),
            CGPoint(x: rect.width / 2, y: 0)
        ])
        return path
    }
    
    
}
