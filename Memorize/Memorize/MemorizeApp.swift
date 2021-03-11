//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
