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
    private(set) var cards: [Card]
    var themeName: String
    var themeColor: Color
    var score = 0
    
    private var indexOfSingleFaceUpCard: Int? {
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
                // When choosing a second card
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    // If we have a match
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                // Choosing a first card
                indexOfSingleFaceUpCard = chosenIndex
            }
            
            // Penalize if user has already seen the card before and didn't match
            if cards[chosenIndex].hasBeenSeen,
               !cards[chosenIndex].isMatched {
                score -= 1
            }
            // Always set hasBeenSeen to true after flipping a card
            cards[chosenIndex].hasBeenSeen = true
        }
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
    
    struct Card: Identifiable {
        let id = UUID()
        var isFaceUp = false {
            didSet {
                isFaceUp ? startUsingBonusTime() : stopUsingBonusTime()
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var hasBeenSeen = false
        var content: CardContent
        var color: Color
        
        // MARK:- Bonus Time
        // Awarded if user makes a match quickly
        
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date? // The last time this card was turned face up (and is still face up)
        var pastFaceUpTime: TimeInterval = 0 // Accumulated face up time not including current face up time
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        var hasEarnedBonus: Bool {
            isMatched && bonusRemaining > 0
        }
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
