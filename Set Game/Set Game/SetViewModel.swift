//
//  SetViewModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

class SetViewModel: ObservableObject {
    @Published private var model = createSetGame()
    static private let maxCardsOnTable = 18
    static private let initialDealAmount = 12
    static private let dealAmount = 3
    static private let completeSelectionAmount = 3
    
    private static func createSetGame() -> SetGameModel<SetCardContent> {
        var setGame = SetGameModel<SetCardContent>(
            maxCardsOnTable: Self.maxCardsOnTable,
            initialDealAmount: Self.initialDealAmount,
            dealAmount: Self.dealAmount,
            completeSelectionAmount: Self.completeSelectionAmount,
            checkForSetWith: match,
            cardFactory: {
//                var contents: [SetCardContent] = []
//                for color in SetViewModel.Color.allCases {
//                    for shape in SetViewModel.Shape.allCases {
//                        for number in SetViewModel.Number.allCases {
//                            for shading in SetViewModel.Shading.allCases {
//                                contents.append(SetCardContent(
//                                    color: color,
//                                    shape: shape,
//                                    number: number,
//                                    shading: shading
//                                ))
//                            }
//                        }
//                    }
//                }
//                return contents
                return Array.init(repeating: SetCardContent(color: .red, shape: .diamond, number: .one, shading: .open), count: 12)
            })
        return setGame
    }
    
    private static func match(cards: [SetGameModel<SetCardContent>.Card]) -> Bool {
        guard cards.count == 3 else { return false }
        
        let first = cards[0].content
        let second = cards[1].content
        let third = cards[2].content
        
        if checkCardAttributeForSet(first: first.color, second: second.color, third: third.color),
           checkCardAttributeForSet(first: first.shape, second: second.shape, third: third.shape),
           checkCardAttributeForSet(first: first.number, second: second.number, third: third.number),
           checkCardAttributeForSet(first: first.shading, second: second.shading, third: third.shading) {
            return true
        } else {
            return false
        }
    }
    
    private static func checkCardAttributeForSet<Attribute: Equatable>(first: Attribute, second: Attribute, third: Attribute) -> Bool {
        // Per Set game rules, return true if all attributes MATCH or are COMPLETELY DIFFERENT
        return (first == second && second == third) || (first != second && second != third && third != first)
    }
    
    var cardsOnTable: [SetGameModel<SetCardContent>.Card] { model.cardsOnTable }
    var totalNumberOfSets: Int { (model.cardDeck.count + model.cardsOnTable.count + model.matchedCards.count) / Self.completeSelectionAmount }
    var numberOfSetsFound: Int { model.matchedCards.count / Self.completeSelectionAmount }
    var numberOfCardsRemaining: Int { model.cardDeck.count }
    var isDealAllowed: Bool { cardsOnTable.count <= Self.maxCardsOnTable - Self.dealAmount }
    var isGameComplete: Bool { numberOfSetsFound == totalNumberOfSets }

    
    
    
    // MARK:- Intents
    func chooseCard(_ card: SetGameModel<SetCardContent>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = SetViewModel.createSetGame()
        dealInitialCards()
    }
    
    func dealInitialCards() {
        guard cardsOnTable.count == 0 else { return }
        model.deal(Self.initialDealAmount)
    }
    
    func dealMoreCards() {
        guard isDealAllowed else { return }
        model.deal(Self.dealAmount)
    }
    
    // MARK:- Set Card Content
    enum Color: CaseIterable {
        case red
        case green
        case purple
    }
    
    enum Shape: CaseIterable {
        case oval
        case rectangle
        case diamond
    }
    
    enum Number: Int, CaseIterable {
        case one = 1
        case two
        case three
    }
    
    enum Shading: CaseIterable {
        case solid
        case light
        case open
    }
    
    struct SetCardContent: Hashable {
        let color: Color
        let shape: Shape
        let number: Number
        let shading: Shading
    }
}
