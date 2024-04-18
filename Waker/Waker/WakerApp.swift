//
//  WakerApp.swift
//  Waker
//
//  Created by Chenglong Ma on 11/4/2024.
//  TODO: [Safely open apps on your Mac](https://support.apple.com/en-us/102445)
//

import SwiftUI
import LaunchAtLogin
import Sparkle

@main
struct WakerApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    @AppStorage("appIcon") private var appIcon = "sun.max.fill"
    @AppStorage("appName") private var appName = "Waker - active"
    @AppStorage("lanunchAtLogin") private var launchAtLogin: Bool = false
    
    @StateObject var viewModel = WakerViewModel()
    
    private let updaterDelegate = UpdaterDelegate()
    private let updaterController: SPUStandardUpdaterController

    
    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        self.updaterController = SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: self.updaterDelegate, userDriverDelegate: self.updaterDelegate)
    }
    
    private func updateIconAndName() {
        
        var status: String
        
        switch viewModel.runningStatus {
        case .running:
            status = "active"
            appIcon = "sun.max.fill"
        case .scheduled:
            status = "scheduled"
            appIcon = "sun.haze.fill"
        case .stopped:
            status = "inactive"
            appIcon = "moon.zzz"
        case .error:
            // Unknown status
            status = "error"
            appIcon = "sun.max.trianglebadge.exclamationmark.fill"
        }
        appName = "Waker \(Bundle.main.buildNumber) - \(status)"
    }
    
    var body: some Scene {
        
        //        WindowGroup {
        //            ContentView()
        //        }
        MenuBarExtra(appName, systemImage: appIcon){
            MenuBar(appName: $appName, appIcon: $appIcon, updaterController: updaterController)
                .environmentObject(viewModel)
        }
        .onChange(of: viewModel.runningStatus) { _ in
            updateIconAndName()
        }
        .menuBarExtraStyle(.window)
        
    }
}
