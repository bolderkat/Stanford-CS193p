//
//  AnyTransition+Fly.swift
//  Set Game
//
//  Created by Daniel Luo on 4/7/21.
//

import SwiftUI

extension AnyTransition {
    static var fly: AnyTransition {
        let offset = CGSize(width: Int.random(in: -800...800), height: Int.random(in: -800...800))
        return .offset(offset)
    }
}
