//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//
// VIEW MODEL

import Foundation

class EmojiMemoryGame: ObservableObject {
    @Published private var game: MemoryGame<String> = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["🚀", "💎" ,"🧻", "🙌", "🌝", "💰", "💸", "🤑", "🙀", "🌙", "🪐", "🍸"].shuffled()
        return MemoryGame<String>(numberOfCardPairs: Int.random(in: 2..<5)) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    var cards: [MemoryGame<String>.Card] {
        game.cards
    }
    
    // MARK: - Intents
    
    func chooseCard(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }
    
    
}
