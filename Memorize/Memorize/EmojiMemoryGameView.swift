//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Daniel Luo on 3/10/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    var viewModel: EmojiMemoryGame
    var body: some View {
        HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.chooseCard(card)
                }
                .font(viewModel.cards.count >= 10 ? .body : .largeTitle)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 3)
                    .foregroundColor(Color.orange)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}
