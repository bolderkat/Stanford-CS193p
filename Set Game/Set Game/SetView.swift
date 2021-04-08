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
        ZStack {
            VStack {
                HStack {
                    Text("Sets Found: \(viewModel.numberOfSetsFound)/\(viewModel.totalNumberOfSets)")
                        .fontWeight(.semibold)
                        .font(.title2)
                    Spacer()
                    Button(action: {
                        withAnimation(.easeOut(duration: newGameAnimationDuration)) {
                            viewModel.startNewGame()
                        }
                    }, label: {
                        Text("New Game")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                    })
                    .background(RoundedRectangle(cornerRadius: buttonCornerRadius).fill(buttonBackground))
                }
                .padding(.horizontal, 40)
                
                GeometryReader { geometry in
                    Grid(viewModel.cardsOnTable) { card in
                        CardView(card: card, screenBounds: geometry.frame(in: .global)).onTapGesture {
                            withAnimation(.easeOut(duration: dealAnimationDuration)) {
                                viewModel.chooseCard(card)
                            }
                        }
                    }
                }
                Button(action: {
                    withAnimation(.easeOut(duration: dealAnimationDuration)) {
                        viewModel.dealMoreCards()
                    }
                }, label: {
                    Text("Deal 3 More Cards")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                })
                .background(RoundedRectangle(cornerRadius: buttonCornerRadius).fill(buttonBackground))
                .opacity(viewModel.isDealAllowed ? 1 : 0)
            }
            .onAppear(perform: {
                withAnimation(.easeOut(duration: newGameAnimationDuration)) {
                    viewModel.dealInitialCards()
                }
            })
            if viewModel.isGameComplete {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: massiveCircleSize, height: massiveCircleSize, alignment: .center)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("YOU WIN!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Button(action: {
                            withAnimation(.easeOut(duration: newGameAnimationDuration)) {
                                viewModel.startNewGame()
                            }
                        }, label: {
                            Text("START NEW GAME")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding()
                        })
                        .background(RoundedRectangle(cornerRadius: buttonCornerRadius).fill(newGameButtonBackground))
                        .shadow(radius: 4)
//                        .transition(.opacity)
                    }
                }
                .transition(AnyTransition.scale.animation(.easeInOut(duration: newGameAnimationDuration)))
            }
        }
    }
    
    // MARK:- Drawing Constants
    private let newGameAnimationDuration: Double = 0.6
    private let dealAnimationDuration: Double = 0.4
    private let buttonCornerRadius: CGFloat = 15.0
    private let massiveCircleSize: CGFloat = 4000
    private let buttonBackground = Color(red: 0.0 / 255, green: 10.0 / 255, blue: 82.0 / 255)
    private let newGameButtonBackground = Color(red: 62.0 / 255 , green: 220.0 / 255, blue: 100.0 / 255)
}

struct CardView: View {
    var card: SetGameModel<SetViewModel.SetCardContent>.Card
    var screenBounds: CGRect

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .fill(cardBackground)
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
        .transition(.flyInOut(using: screenBounds))
        .aspectRatio(cardAspectRatio, contentMode: .fit)
    }
    
    // MARK:- Drawing Constants
    private let cardCornerRadius: CGFloat = 10
    private let ovalCornerRadius: CGFloat = 40
    private let cardStrokeWidth: CGFloat = 3
    private let cardPadding: CGFloat = 4
    private let symbolPadding: CGFloat = 16
    private let cardAspectRatio: CGFloat = 3.0 / 4.0
    private let cardBackground = Color(red: 248.0 / 255, green: 248.0 / 255, blue: 250.0 / 255)
    
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
