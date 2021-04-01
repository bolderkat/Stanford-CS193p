//
//  SetModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

struct SetModel {
    var cardDeck: [Card] = []
    var cardsOnTable: [Card] = []
    var matchedCards: Set<Card> = []
    
    let maxCardsOnTable = 21
    let minimumDealThreshold = 3
    
    init() {
        for color in Card.Color.allCases {
            for shape in Card.Shape.allCases {
                for number in Card.Number.allCases {
                    for shading in Card.Shading.allCases {
                        cardDeck.append(Card(
                            color: color,
                            shape: shape,
                            number: number,
                            shading: shading
                        ))
                    }
                }
            }
        }
        cardDeck.shuffle()
        dealFirstTwelveCards()
    }
    
    private mutating func dealFirstTwelveCards() {
        for _ in 1...12 {
            cardsOnTable.append(cardDeck.popLast()!)
        }
    }
    
    mutating func dealThreeMoreCards() {
        if cardsOnTable.count < maxCardsOnTable, cardDeck.count >= minimumDealThreshold {
            for _ in 1...3 {
                cardsOnTable.append(cardDeck.popLast()!)
            }
        }
    }
}

struct Card: Hashable {
    enum Color: CaseIterable { case red, green, purple }
    enum Shape: CaseIterable { case oval, rectangle, diamond }
    enum Number: Int, CaseIterable { case one = 1, two, three }
    enum Shading: CaseIterable { case solid, light, open }
    
    let color: Color
    let shape: Shape
    let number: Number
    let shading: Shading
    var isMatched = false
}
