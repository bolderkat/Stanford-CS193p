//
//  Set_GameApp.swift
//  Set Game
//
//  Created by Daniel Luo on 3/31/21.
//

import SwiftUI

@main
struct Set_GameApp: App {
    var body: some Scene {
        WindowGroup {
            SetView(viewModel: SetViewModel())
        }
    }
}
