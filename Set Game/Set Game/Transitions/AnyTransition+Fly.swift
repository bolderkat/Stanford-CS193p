//
//  AnyTransition+Fly.swift
//  Set Game
//
//  Created by Daniel Luo on 4/7/21.
//

import SwiftUI

extension AnyTransition {
    static func flyInOut(using bounds: CGRect) -> AnyTransition {
        let outsideLeft = Int.random(in: Int(-bounds.width) * 2...Int(-bounds.width))
        let outsideRight = Int.random(in: Int(bounds.width)...Int(bounds.width) * 2)
        let aboveTop = Int.random(in: Int(-bounds.height) * 2...Int(-bounds.height))
        let belowBottom = Int.random(in: Int(bounds.height)...Int(bounds.height) * 2)
        
        let horizontalStartPosition = [outsideLeft, outsideRight].randomElement()!
        let verticalStartPosition = [aboveTop, belowBottom].randomElement()!
        
        let offset = CGSize(width: horizontalStartPosition, height: verticalStartPosition)
        
        return .offset(offset)
    }
    
    static var flyInOut: AnyTransition {
        let offset = CGSize(width: Int.random(in: -800...800), height: Int.random(in: -800...800))
        return .offset(offset)
    }
}
