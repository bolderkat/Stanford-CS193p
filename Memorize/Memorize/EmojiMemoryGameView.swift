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
                Button(action: {
                    withAnimation(.easeInOut) {
                        viewModel.startNewGame()
                    }
                }, label: {
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
                    withAnimation(.linear(duration: cardFlipDuration)) {
                        viewModel.chooseCard(card)
                    }
                }
            }
            
            Text(themeName)
                .foregroundColor(themeColor)
                .font(.title)
                .fontWeight(.bold)
        }
    }
    
    // MARK:- Drawing Constants
    private let cornerRadius: CGFloat = 10
    private let horizontalHeaderPadding: CGFloat = 20
    private let verticalHeaderPadding: CGFloat = 10
    private let buttonPadding: CGFloat = 8
    private let cardFlipDuration: Double = 0.6
    private var themeName: String { viewModel.themeName }
    private var themeColor: Color { viewModel.themeColor }
}



struct CardView: View {
    var card: MemoryGame<String>.Card
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90))
                                .onAppear {
                                    startBonusTimeAnimation()
                                }
                        } else {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90))
                        }
                    }
                    .padding(cardPadding)
                    .foregroundColor(card.color)
                    .opacity(circleOpacity)
                    .transition(.identity)
                    Text(card.content)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                        .animation(card.isMatched ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false) : .default)
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(.scale)
                .foregroundColor(card.color)
                .font(.system(size: fontSize(for: geometry.size)))
                .padding(cardPadding)
            }
        }
    }
    
    // MARK: - Drawing Constants
    private let cardPadding: CGFloat = 5
    private let circleOpacity: Double = 0.4
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.6
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.chooseCard(game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
