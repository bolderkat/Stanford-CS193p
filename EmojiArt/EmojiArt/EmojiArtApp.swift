//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Daniel Luo on 4/8/21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
