//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Daniel Luo on 4/8/21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                    }
                }
            }
            .padding(.horizontal)
            Color.yellow
                .edgesIgnoringSafeArea([.horizontal, .bottom])
        }
    }
    
    // MARK:- Drawing Constants
    private let defaultEmojiSize: CGFloat = 40.0
}
