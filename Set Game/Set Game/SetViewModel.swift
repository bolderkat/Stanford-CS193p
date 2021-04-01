//
//  SetViewModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

class SetViewModel: ObservableObject {
    @Published private var model = SetModel()
    
    var numberOfCardsInDeck: Int { model.cardDeck.count }
    var cardsOnTable: [Card] { model.cardsOnTable }
    var numberOfMatchedSets: Int { model.matchedCards.count / 3 }
    
    // MARK:- Intents
    
    func startNewGame() {
        model = SetModel()
    }
    
    func dealMoreCards() {
        model.dealThreeMoreCards()
    }
}
