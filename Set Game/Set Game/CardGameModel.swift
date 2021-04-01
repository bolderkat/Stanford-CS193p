//
//  CardGameModel.swift
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
    let minimumDealAmount: Int
    
    init(maxCardsOnTable: Int, minimumDealAmount: Int, cardFactory: () -> [CardContent]) {
        self.maxCardsOnTable = maxCardsOnTable
        self.minimumDealAmount = minimumDealAmount
        createCards(with: cardFactory)
    }
    
    private mutating func createCards(with cardFactory: () -> [CardContent]) {
        cardDeck = []
        for card in cardFactory() {
            cardDeck.append(Card(content: card))
        }
        cardDeck.shuffle()
    }
    
    mutating func deal(_ numberOfCards: Int) {
        guard cardDeck.count >= numberOfCards,
              numberOfCards >= minimumDealAmount else { return }
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

