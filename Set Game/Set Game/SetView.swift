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
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(viewModel: SetViewModel())
    }
}
