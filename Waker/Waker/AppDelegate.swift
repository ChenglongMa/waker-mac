//
//  AppDelegate.swift
//  Waker
//
//  Created by Chenglong Ma on 11/4/2024.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        Utils.checkAccessibilityPermission()
    }
}
