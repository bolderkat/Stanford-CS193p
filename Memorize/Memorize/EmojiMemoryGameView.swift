//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(viewModel.score)")
                    .foregroundColor(themeColor)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { viewModel.startNewGame() }, label: {
                    Text("New Game")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(buttonPadding)
                })
                .background(RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundColor(themeColor))
            }
            .padding(.horizontal, horizontalHeaderPadding)
            .padding(.top, verticalHeaderPadding)
            
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.chooseCard(card)
                }
            }
            
            Text(themeName)
                .foregroundColor(themeColor)
                .font(.title)
                .fontWeight(.bold)
        }
    }
    
    // MARK:- Drawing Constants
    let cornerRadius: CGFloat = 10
    let horizontalHeaderPadding: CGFloat = 20
    let verticalHeaderPadding: CGFloat = 10
    let buttonPadding: CGFloat = 8
    var themeName: String { viewModel.themeName }
    var themeColor: Color { viewModel.themeColor }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: edgeLineWidth)
                        .foregroundColor(card.color)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(card.color)
                    }
                }
            }
            .font(.system(size: fontSize(for: geometry.size)))
            .padding(cardPadding)
        }
    }
    
    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
    let cardPadding: CGFloat = 5
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}
