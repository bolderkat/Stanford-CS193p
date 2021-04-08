//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Daniel Luo on 4/8/21.
//

import Foundation

struct EmojiArt {
    var backgroundURL: URL?
    var emojis: [Emoji] = []
    private var uniqueEmojiId = 0
    
    struct Emoji: Identifiable, Equatable {
        let text: String
        
        // Implementing custom coordinate system using Ints with origin in center of screen
        var x: Int
        var y: Int
        var size: Int
        let id: Int // will handle id privately in EmojiArt
        
        // We don't want anyone but EmojiArt to create Emoji due to the way we're handling ids, so we will make the init fileprivate
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
}
