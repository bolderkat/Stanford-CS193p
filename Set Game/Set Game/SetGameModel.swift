//
//  SetGameModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

struct SetGameModel<CardContent> where CardContent: Hashable {
    private(set) var cardDeck: [Card] = []
    private(set) var cardsOnTable: [Card] = []
    private(set) var matchedCards: Set<Card> = []
    
    let maxCardsOnTable: Int
    let initialDealAmount: Int
    let dealAmount: Int
    // Number of cards to complete a set
    let completeSelectionAmount: Int
    let checkForSetWith: ([Card]) -> Bool
    
    private var selectedCards: [Card] {
        cardsOnTable.filter { $0.status != .unselected }
    }
    private var isSelectionComplete: Bool {
        selectedCards.count == completeSelectionAmount
    }
    private var isSelectionASet: Bool {
        selectedCards.filter { $0.status == .matched }.count == completeSelectionAmount
    }
    private var isFinalSetSelected: Bool {
        cardsOnTable.allSatisfy { $0.status == .matched }
    }
    
    init(
        maxCardsOnTable: Int,
        initialDealAmount: Int,
        dealAmount: Int,
        completeSelectionAmount: Int,
        checkForSetWith: @escaping ([Card]) -> Bool,
        cardFactory: () -> [CardContent]
    ) {
        self.maxCardsOnTable = maxCardsOnTable
        self.initialDealAmount = initialDealAmount
        self.dealAmount = dealAmount
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
              numberOfCards >= dealAmount else { return }
        for _ in 1...numberOfCards {
            cardsOnTable.append(cardDeck.popLast()!)
        }
    }
    
    mutating func choose(_ card: Card) {
        if isSelectionComplete, isSelectionASet {
            clearMatchedCards()
            if cardsOnTable.count < initialDealAmount {
                deal(dealAmount)
            }
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
        
        if isFinalSetSelected {
            clearMatchedCards()
        }
    }
    
    private mutating func deselectAllCards() {
        for card in selectedCards {
            if let index = cardsOnTable.firstIndex(of: card) {
                cardsOnTable[index].status = .unselected
            }
        }
    }
    
    private mutating func matchCards() {
        let isAMatch = checkForSetWith(selectedCards)
        for card in selectedCards {
            if let index = cardsOnTable.firstIndex(of: card) {
                cardsOnTable[index].status = isAMatch ? .matched : .mismatched
            }
        }
    }
    
    private mutating func clearMatchedCards() {
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

