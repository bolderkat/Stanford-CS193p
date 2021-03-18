//
//  MemoryGame.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//
// MODEL

import Foundation
import SwiftUI // for access to Color struct only

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: [Card]
    var themeName: String
    var themeColor: Color
    var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
        }
    }
    
    var indexOfSingleFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    init(theme: Theme) {
        cards = [Card]()
        themeName = theme.name
        themeColor = theme.color
        let emojis = theme.shuffledContents
        for pairIndex in 0..<theme.numberOfCardPairs {
            let content = emojis[pairIndex]
            cards.append(Card(content: content, color: theme.color))
            cards.append(Card(content: content, color: theme.color))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfSingleFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    score -= 1
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfSingleFaceUpCard = chosenIndex
            }
        }
    }
    
    struct Card: Identifiable {
        let id = UUID()
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var color: Color
    }
    
    struct Theme {
        let name: String
        let numberOfCardPairs: Int
        let contents: [CardContent]
        var shuffledContents: [CardContent] {
            contents.shuffled()
        }
        let color: Color
    }
}
