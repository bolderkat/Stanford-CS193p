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
    let checkForSetWith: ([Card]) -> Bool
    
    var selectedCards: [Card] {
        cardsOnTable.filter { $0.status != .unselected }
    }
    var isSelectionComplete: Bool {
        selectedCards.count == completeSelectionAmount
    }
    var isSelectionASet: Bool {
        selectedCards.filter { $0.status == .matched }.count == completeSelectionAmount
    }
    
    init(
        maxCardsOnTable: Int,
        minimumDealAmount: Int,
        completeSelectionAmount: Int,
        checkForSetWith: @escaping ([Card]) -> Bool,
        cardFactory: () -> [CardContent]
    ) {
        self.maxCardsOnTable = maxCardsOnTable
        self.minimumDealAmount = minimumDealAmount
        self.completeSelectionAmount = completeSelectionAmount
        self.checkForSetWith = checkForSetWith
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
        if isSelectionComplete, isSelectionASet {
            clearMatchedCards()
            deal(3)
        } else if isSelectionComplete {
            deselectAllCards()
        }
        
        if let chosenIndex = cardsOnTable.firstIndex(of: card),
           cardsOnTable[chosenIndex].status != .matched {
            cardsOnTable[chosenIndex].status = (cardsOnTable[chosenIndex].status == .selected) ? .unselected : .selected
            
            if isSelectionComplete {
                matchCards()
            }
        }
    }
    
    mutating func deselectAllCards() {
        for card in selectedCards {
            if let index = cardsOnTable.firstIndex(of: card) {
                cardsOnTable[index].status = .unselected
            }
        }
    }
    
    mutating func matchCards() {
        let isAMatch = checkForSetWith(selectedCards)
        for card in selectedCards {
            if let index = cardsOnTable.firstIndex(of: card) {
                cardsOnTable[index].status = isAMatch ? .matched : .mismatched
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
        var status: Status = .unselected
        
        enum Status {
            case unselected
            case selected
            case mismatched
            case matched
        }
    }
    
}

