//
//  UpdaterViewModel.swift
//  Waker
//
//  Created by Chenglong Ma on 17/4/2024.
//  Refer to: https://sparkle-project.org/documentation/programmatic-setup/
//

import SwiftUI
import Sparkle

class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdates = false
    
    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }
}

// This is the view for the Check for Updates menu item
// Note this intermediate view is necessary for the disabled state on the menu item to work properly before Monterey.
// See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more info
struct CheckForUpdatesView: View {
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater
    
    init(updater: SPUUpdater) {
        self.updater = updater
        
        // Create our view model for our CheckForUpdatesView
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
    }
    
    var body: some View {
        Button("Check for Updates", action: updater.checkForUpdates)
            .buttonStyle(PlainButtonStyle())
            .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
    }
}