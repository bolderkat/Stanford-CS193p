//
//  ContentView.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var viewModel: SetViewModel
    var body: some View {
        Grid(viewModel.cardsOnTable) { card in
            CardView(card: card)
        }
    }
}

struct CardView: View {
    var card: CardGameModel<SetViewModel.SetCardContent>.Card
    var symbolColor: Color {
        switch card.content.color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(lineWidth: cardStrokeWidth)
            VStack {
                ForEach((1...card.content.number.rawValue), id: \.self) { number in
                    switch card.content.shape {
                    case .diamond:
                        Circle()
                    case .oval:
                        RoundedRectangle(cornerRadius: ovalCornerRadius)
                    case .rectangle:
                        Rectangle()
                    }
                }
            }
            .frame(height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(symbolPadding)
            .foregroundColor(symbolColor)
        }
        .padding(cardPadding)
    }
    
    // MARK:- Drawing Constants
    private let cardCornerRadius: CGFloat = 10
    private let ovalCornerRadius: CGFloat = 30
    private let cardStrokeWidth: CGFloat = 3
    private let cardPadding: CGFloat = 5
    private let symbolPadding: CGFloat = 20
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(viewModel: SetViewModel())
    }
}
