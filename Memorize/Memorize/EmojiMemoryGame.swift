//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//
// VIEW MODEL

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var game: MemoryGame<String> = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let themes = [
            MemoryGame.Theme(
                name: "Stonks",
                numberOfCardPairs: 6,
                contents: ["🚀", "💎" ,"🧻", "🙌", "🌝", "💰", "💸", "🤑", "🙀", "🌙", "🪐", "🍸"],
                color: .red
            ),
            MemoryGame.Theme(
                name: "Halloween",
                numberOfCardPairs: Int.random(in: 3...6),
                contents: ["🙀", "🕸", "👻", "🕷", "🙈", "😱", "👹", "💀", "🌚"],
                color: .orange
            ),
            MemoryGame.Theme(
                name: "Weather",
                numberOfCardPairs: 6,
                contents: ["🌪", "🌈", "☀️", "🌤", "☁️", "🌦", "🌧", "⛈", "🌨", "❄️", "🌬"],
                color: .blue
            ),
            MemoryGame.Theme(
                name: "Sports",
                numberOfCardPairs: 6,
                contents: ["🏀", "🏈", "⚽️", "⚾️", "🎱", "🛹", "🥊", "⛳️", "🧗", "🚴‍♀️", "🏂"],
                color: .yellow
            ),
            MemoryGame.Theme(
                name: "Buildings",
                numberOfCardPairs: 6,
                contents: ["🏨", "🕌", "🕍", "🛕", "🏦", "🏩", "🛖", "🏡", "🏭", "🏛"],
                color: .gray
            ),
            MemoryGame.Theme(
                name: "Food",
                numberOfCardPairs: 8,
                contents: ["🥟", "🍜", "🌮", "🌯", "🍕", "🥩", "🥙", "🥗", "🍆", "🍑", "🌽"],
                color: .green
            )
        ]
        let selectedTheme = themes.randomElement()!
        return MemoryGame<String>(theme: selectedTheme)
    }
    
    var cards: [MemoryGame<String>.Card] {
        game.cards
    }
    
    // MARK: - Intents
    
    func chooseCard(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }

    
}
