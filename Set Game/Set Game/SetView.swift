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
            CardView(card: card).onTapGesture {
                viewModel.chooseCard(card)
            }
        }
    }
}

struct CardView: View {
    var card: SetGameModel<SetViewModel.SetCardContent>.Card

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(Color.white)
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(lineWidth: cardStrokeWidth)
                .foregroundColor(cardOutlineColor)
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
            .opacity(symbolOpacity)
            .padding(symbolPadding)
            .foregroundColor(symbolColor)
        }
        .padding(cardPadding)
    }
    
    // MARK:- Drawing Constants
    private let cardCornerRadius: CGFloat = 10
    private let ovalCornerRadius: CGFloat = 40
    private let cardStrokeWidth: CGFloat = 3
    private let cardPadding: CGFloat = 5
    private let symbolPadding: CGFloat = 20
    
    // MARK:- Drawing Properties
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
    
    var symbolOpacity: Double {
        switch card.content.shading {
        case .solid:
            return 1
        case .light:
            return 0.5
        case .open:
            return 0.1
        }
    }
    
    var cardOutlineColor: Color {
        if card.isMatched {
            return .green
        } else if card.isSelected {
            return .yellow
        } else {
            return .black
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(viewModel: SetViewModel())
    }
}
