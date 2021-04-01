//
//  SetViewModel.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import Foundation

class SetViewModel: ObservableObject {
    @Published private var model = createSetGame()

    private static func createSetGame() -> CardGameModel<SetCardContent> {
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
        contents.shuffle()
        var setGame = CardGameModel<SetCardContent>(maxCardsOnTable: 21, minimumDealThreshold: 3)
        setGame.createCards(with: contents)
        let initialDealAmount = 12
        setGame.deal(initialDealAmount)
        return setGame
    }
    
    let subsequentDealAmount = 3
    var numberOfCardsInDeck: Int { model.cardDeck.count }
    var cardsOnTable: [CardGameModel<SetCardContent>.Card] { model.cardsOnTable }
    var numberOfMatchedSets: Int { model.matchedCards.count / 3 }
    
    
    // MARK:- Intents
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
