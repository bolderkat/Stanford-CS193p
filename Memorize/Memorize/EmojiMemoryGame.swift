//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//
// VIEW MODEL

import Foundation

class EmojiMemoryGame {
    private var game: MemoryGame<String> = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["🚀", "💎" ,"🧻", "🙌", "🌝", "💰", "💸", "🤑"]
        return MemoryGame<String>(numberOfCardPairs: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    var cards: [MemoryGame<String>.Card] {
        game.cards
    }
    
    // MARK: - Intents
    
    func chooseCard(card: MemoryGame<String>.Card) {
        game.choose(card: card)
    }
    
    
}
