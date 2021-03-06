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
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let themes = [
            MemoryGame.Theme(
                name: "Stonks",
                numberOfCardPairs: 6,
                contents: ["๐", "๐" ,"๐งป", "๐", "๐", "๐ฐ", "๐ธ", "๐ค", "๐", "๐", "๐ช", "๐ธ"],
                color: .red
            ),
            MemoryGame.Theme(
                name: "Halloween",
                numberOfCardPairs: Int.random(in: 3...6),
                contents: ["๐", "๐ธ", "๐ป", "๐ท", "๐", "๐ฑ", "๐น", "๐", "๐"],
                color: .orange
            ),
            MemoryGame.Theme(
                name: "Weather",
                numberOfCardPairs: 6,
                contents: ["๐ช", "๐", "โ๏ธ", "๐ค", "โ๏ธ", "๐ฆ", "๐ง", "โ", "๐จ", "โ๏ธ", "๐ฌ"],
                color: .blue
            ),
            MemoryGame.Theme(
                name: "Sports",
                numberOfCardPairs: 6,
                contents: ["๐", "๐", "โฝ๏ธ", "โพ๏ธ", "๐ฑ", "๐น", "๐ฅ", "โณ๏ธ", "๐ง", "๐ดโโ๏ธ", "๐"],
                color: .yellow
            ),
            MemoryGame.Theme(
                name: "Buildings",
                numberOfCardPairs: 6,
                contents: ["๐จ", "๐", "๐", "๐", "๐ฆ", "๐ฉ", "๐", "๐ก", "๐ญ", "๐"],
                color: .gray
            ),
            MemoryGame.Theme(
                name: "Food",
                numberOfCardPairs: 7,
                contents: ["๐ฅ", "๐", "๐ฎ", "๐ฏ", "๐", "๐ฅฉ", "๐ฅ", "๐ฅ", "๐", "๐", "๐ฝ"],
                color: .green
            )
        ]
        let selectedTheme = themes.randomElement()!
        return MemoryGame<String>(theme: selectedTheme)
    }
    
    var cards: [MemoryGame<String>.Card] { game.cards }
    var themeName: String { game.themeName }
    var themeColor: Color { game.themeColor }
    var score: Int { game.score }
    
    // MARK: - Intents
    
    func chooseCard(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }
    
    func startNewGame() {
        game = EmojiMemoryGame.createMemoryGame()
    }

    
}
