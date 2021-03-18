//
//  Grid.swift
//  Memorize
//
//  Created by Daniel Luo on 3/11/21.
//

import SwiftUI

struct Grid<Item, ItemView> : View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    init (_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            let layout = GridLayout(itemCount: items.count, in: geometry.size)
            ForEach(items) { item in
                body(for: item, in: layout)
            }
        }
    }
    
    func body(for item: Item, in layout: GridLayout) -> some View {
        Group {
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
            }
        }
    }
}

