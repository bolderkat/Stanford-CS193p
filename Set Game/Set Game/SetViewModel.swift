//
//  SetViewModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

class SetViewModel: ObservableObject {
    @Published private var model = createSetGame()
    
    private static func createSetGame() -> SetGameModel<SetCardContent> {
        var setGame = SetGameModel<SetCardContent>(
            maxCardsOnTable: 21,
            minimumDealAmount: 3,
            completeSelectionAmount: 3,
            checkForSetWith: match,
            cardFactory: {
                var contents: [SetCardContent] = []
                for color in SetViewModel.Color.allCases {
                    for shape in SetViewModel.Shape.allCases {
                        for number in SetViewModel.Number.allCases {
                            for shading in SetViewModel.Shading.allCases {
                                contents.append(SetCardContent(
                                    color: color,
                                    shape: shape,
                                    number: number,
                                    shading: shading
                                ))
                            }
                        }
                    }
                }
                return contents
            })
        
        let initialDealAmount = 12
        setGame.deal(initialDealAmount)
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
    
    private let subsequentDealAmount = 3
    var numberOfCardsInDeck: Int { model.cardDeck.count }
    var cardsOnTable: [SetGameModel<SetCardContent>.Card] { model.cardsOnTable }
    var numberOfMatchedSets: Int { model.matchedCards.count / 3 }
    
    
    
    // MARK:- Intents
    func chooseCard(_ card: SetGameModel<SetCardContent>.Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = SetViewModel.createSetGame()
    }
    
    func dealMoreCards() {
        model.deal(subsequentDealAmount)
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
