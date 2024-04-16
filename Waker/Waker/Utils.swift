//
//  Utils.swift
//  Waker
//
//  Created by Chenglong Ma on 11/4/2024.
//

import SwiftUI

enum RunningStatus {
    case running
    case scheduled
    case stopped
    case error
}

struct Constants {
    static let allWeekDays = 0b1_111_111
}

class Utils {
    
    @AppStorage("accessibilityEnabled") private static var accessibilityEnabled: Bool = false
    
    static func checkAccessibilityPermission(recheck: Bool = false) {
        //        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        //        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        if recheck || !accessibilityEnabled {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("permission_title", comment: "")
            alert.informativeText = NSLocalizedString("permission_prompt", comment: "")
            alert.alertStyle = .warning
            alert.addButton(withTitle: NSLocalizedString("permission_action", comment: ""))
            alert.addButton(withTitle: NSLocalizedString("Exit", comment: ""))
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
                NSWorkspace.shared.open(url)
                accessibilityEnabled = true
            } else {
                accessibilityEnabled = false
                NSApplication.shared.terminate(nil)
            }
        }
    }
    
    static func pressKeyAlt() {
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let keyCodeOption: UInt16 = 0x3A
        let keyDown = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCodeOption, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCodeOption, keyDown: false)
        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
        print("pressKeyAlt")
    }
    
    static func getScreenSize() -> CGSize {
        return NSScreen.main?.frame.size ?? CGSize.zero
    }
    
    static func moveMouseRandomly() {
        let screenSize = getScreenSize()
        let randomX = CGFloat.random(in: 0..<screenSize.width)
        let randomY = CGFloat.random(in: 0..<screenSize.height)
        let randomPoint = CGPoint(x: randomX, y: randomY)
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let mouseMoveEvent = CGEvent(mouseEventSource: eventSource, mouseType: .mouseMoved, mouseCursorPosition: randomPoint, mouseButton: .left)
        mouseMoveEvent?.post(tap: .cghidEventTap)
        print("moveMouseRandomly")
    }
    
    static func getIdleTime() -> TimeInterval {
        var lastEvent:CFTimeInterval = 0
        lastEvent = CGEventSource.secondsSinceLastEventType(
            CGEventSourceStateID.hidSystemState,
            eventType: CGEventType(rawValue: ~0)!
        )
        return lastEvent
    }
    
    static func getTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
}


extension String {
    func toTime() -> Date {
        let formatter = Utils.getTimeFormatter()
        return formatter.date(from: self) ?? formatter.date(from: "00:00")!
    }
}

extension Date {
    func toString() -> String {
        let formatter = Utils.getTimeFormatter()
        return formatter.string(from: self)
    }
    
    func compareTime(_ other: Date = Date.now) -> ComparisonResult {
        return self.toString().toTime().compare(other.toString().toTime())
    }
    
    func beforeOrSame(_ other: Date = Date.now) -> Bool {
        let res = self.compareTime(other)
        return res.rawValue < ComparisonResult.orderedDescending.rawValue
    }
    
    func afterOrSame(_ other: Date = Date.now) -> Bool {
        let res = self.compareTime(other)
        return res.rawValue > ComparisonResult.orderedAscending.rawValue
    }
    
    func same(_ other: Date = Date.now) -> Bool {
        let res = self.compareTime(other)
        return res == ComparisonResult.orderedSame
    }
    
    func intervalSince(_ time: Date = Date.now) -> TimeInterval {
        let otherTime = time.toString().toTime()
        let thisTime = self.toString().toTime()
        return thisTime.timeIntervalSince(otherTime)
//        let diff = Calendar.current.dateComponents([.hour, .minute], from: otherTime, to: thisTime)
//        return TimeInterval((diff.hour ?? 0) * 60 + (diff.minute ?? 0))
    }
}

extension DateFormatter {
    static var timeOnlyFormatter: DateFormatter {
        let formatter =  DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}
