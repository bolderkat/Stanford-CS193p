//
//  SetModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

struct CardGameModel<CardContent> where CardContent: Hashable {
    var cardDeck: [Card] = []
    var cardsOnTable: [Card] = []
    var matchedCards: Set<Card> = []
    
    let maxCardsOnTable: Int
    let minimumDealThreshold: Int
    
    mutating func createCards(with contents: [CardContent]) {
        for content in contents {
            cardDeck.append(Card(content: content))
        }
    }
    
    mutating func deal(_ numberOfCards: Int) {
        guard cardDeck.count >= numberOfCards,
              cardDeck.count >= minimumDealThreshold else { return }
        for _ in 1...numberOfCards {
            cardsOnTable.append(cardDeck.popLast()!)
        }
    }
    
    struct Card: Identifiable, Hashable {
        let id = UUID()
        let content: CardContent
        var isSelected = false
        var isMatched = false
    }
}

