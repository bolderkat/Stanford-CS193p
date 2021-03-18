//
//  MemoryGame.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//
// MODEL

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: [Card]
    
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
    
    init(numberOfCardPairs: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        
        for pairIndex in 0..<numberOfCardPairs {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
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
    }
}
