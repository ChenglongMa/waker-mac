//
//  WakerApp.swift
//  Waker
//
//  Created by Chenglong Ma on 11/4/2024.
//

import SwiftUI
import LaunchAtLogin

@main
struct WakerApp: App {
    @AppStorage("appIcon") private var appIcon = "sun.max.fill"
    @AppStorage("appName") private var appName = "Waker - active"
    @State private var wakeUpInterval: String = ""
    @State private var showingWakeUpIntervalPrompt = false
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @AppStorage("lanunchAtLogin") private var launchAtLogin: Bool = false
    @StateObject var viewModel = WakerViewModel()
    
    @State private var isPresented = false
    @State private var userInput = ""
    
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
        appName = "Waker - \(status)"
    }
    
    var body: some Scene {
        
        //        WindowGroup {
        //            ContentView()
        //        }
        MenuBarExtra(appName, systemImage: appIcon){
            MenuBar(viewModel: viewModel, appName: $appName, appIcon: $appIcon)
        }
        .onChange(of: viewModel.runningStatus) { _ in
            updateIconAndName()
        }
        .menuBarExtraStyle(.window)
    }
}
