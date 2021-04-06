//
//  SetGameModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

struct SetGameModel<CardContent> where CardContent: Hashable {
    var cardDeck: [Card] = []
    var cardsOnTable: [Card] = []
    var matchedCards: Set<Card> = []
    
    let maxCardsOnTable: Int
    let minimumDealAmount: Int
    // Number of cards to complete a set
    let completeSelectionAmount: Int
    let isSetSelected: ([Card]) -> Bool
    
    
    var isSelectionComplete: Bool {
        // O(n)
        cardsOnTable.filter { $0.isSelected }.count == completeSelectionAmount
    }
    
    init(
        maxCardsOnTable: Int,
        minimumDealAmount: Int,
        completeSelectionAmount: Int,
        isSetSelected: @escaping ([Card]) -> Bool,
        cardFactory: () -> [CardContent]
    ) {
        self.maxCardsOnTable = maxCardsOnTable
        self.minimumDealAmount = minimumDealAmount
        self.completeSelectionAmount = completeSelectionAmount
        self.isSetSelected = isSetSelected
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
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cardsOnTable.firstIndex(of: card),
           !cardsOnTable[chosenIndex].isMatched {
            cardsOnTable[chosenIndex].isSelected.toggle()
            
            if isSelectionComplete {
                checkForSet()
            }
        }
    }
    
    mutating func checkForSet() {
        let selectedCards = cardsOnTable.filter { $0.isSelected }
        if isSetSelected(selectedCards) {
            for card in selectedCards {
                if let index = cardsOnTable.firstIndex(of: card) {
                    cardsOnTable[index].isMatched = true
                }
            }
        }
    }
    
    struct Card: Identifiable, Hashable {
        let id = UUID()
        let content: CardContent
        var isSelected = false
        var isMatched = false
    }
    
}

