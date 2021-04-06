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
    
    var selectedCards: [Card] {
        cardsOnTable.filter { $0.isSelected }
    }
    var isSelectionComplete: Bool {
        selectedCards.count == completeSelectionAmount
    }
    var isSelectionASet: Bool {
        selectedCards.filter { $0.isMatched }.count == completeSelectionAmount
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
        if isSelectionComplete,
           isSelectionASet,
           !selectedCards.contains(card) {
            clearMatchedCards()
            deal(3)
        } else if isSelectionComplete {
            deselectAllCards()
        }
        
        if let chosenIndex = cardsOnTable.firstIndex(of: card),
           !cardsOnTable[chosenIndex].isMatched {
            cardsOnTable[chosenIndex].isSelected.toggle()
            
            if isSelectionComplete {
                checkForSet()
            }
        }
    }
    
    mutating func deselectAllCards() {
        for card in selectedCards {
            if let index = cardsOnTable.firstIndex(of: card) {
                cardsOnTable[index].isSelected = false
            }
        }
    }
    
    mutating func checkForSet() {
        if isSetSelected(selectedCards) {
            for card in selectedCards {
                if let index = cardsOnTable.firstIndex(of: card) {
                    cardsOnTable[index].isMatched = true
                }
            }
        }
    }
    
    mutating func clearMatchedCards() {
        for card in selectedCards {
            if let index = cardsOnTable.firstIndex(of: card) {
                matchedCards.insert(card)
                cardsOnTable.remove(at: index)
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

