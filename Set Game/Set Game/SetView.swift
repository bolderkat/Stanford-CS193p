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
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .stroke(lineWidth: cardStrokeWidth)
                    .foregroundColor(cardOutlineColor)
                VStack {
                    ForEach((1...card.content.number.rawValue), id: \.self) { number in
                        ZStack {
                            cardSymbol
                                
                        }
                        .frame(height: geometry.size.height / 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(symbolPadding)
                .foregroundColor(symbolColor)
            }
            .padding(cardPadding)
        }
    }
    
    // MARK:- Drawing Constants
    private let cardCornerRadius: CGFloat = 10
    private let ovalCornerRadius: CGFloat = 40
    private let cardStrokeWidth: CGFloat = 3
    private let cardPadding: CGFloat = 5
    private let symbolPadding: CGFloat = 20
    
    // MARK:- Drawing Properties
    var cardSymbol: some View {
        switch card.content.shape {
        case .diamond:
            return AnyView(
                ZStack {
                    Diamond()
                        .stroke()
                    Diamond()
                        .opacity(symbolOpacity)
                }
            )
        case .oval:
            return AnyView(
                ZStack {
                    RoundedRectangle(cornerRadius: ovalCornerRadius)
                        .stroke()
                    RoundedRectangle(cornerRadius: ovalCornerRadius)
                        .opacity(symbolOpacity)
                }
            )
        case .rectangle:
            return AnyView(
                ZStack {
                    Rectangle()
                        .stroke()
                    Rectangle()
                        .opacity(symbolOpacity)
                }
                .aspectRatio(1, contentMode: .fit)
            )
        }
    }
    
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
            return 0.3
        case .open:
            return 0
        }
    }
    
    var cardOutlineColor: Color {
        switch card.status {
        case .unselected:
            return .black
        case .selected:
            return .yellow
        case .mismatched:
            return .red
        case .matched:
            return .green
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(viewModel: SetViewModel())
    }
}
