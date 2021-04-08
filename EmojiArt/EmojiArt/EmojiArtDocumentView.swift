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
                .onDrop(of: [.image], isTargeted: nil) { providers, location in
                    return drop(providers: providers)
                }
        }
    }
    
    private func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            document.setBackgroundURL(url)
        }
        return found
    }
    
    // MARK:- Drawing Constants
    private let defaultEmojiSize: CGFloat = 40.0
}
