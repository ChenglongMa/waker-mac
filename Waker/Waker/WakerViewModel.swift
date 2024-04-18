//
//  WakerViewModel.swift
//  Waker
//
//  Created by Chenglong Ma on 11/4/2024.
//

import SwiftUI

class WakerViewModel: ObservableObject {

    @AppStorage("isOn") private var _isOn = true
    @AppStorage("wakeUpInterval") var wakeUpInterval: Double = 5.0 // unit: minutes!
    @AppStorage("scheduled") private var _scheduled: Bool = false
    @AppStorage("startTime") private var startTimeStr: String = "09:00"
    @AppStorage("endTime") private var endTimeStr: String = "17:00"
    @AppStorage("allDay") private var _allDay: Bool = false
    @AppStorage("scheduledDays") private var _selectedDays: Int = Constants.ALL_WEEKDAYS

    var startTime: Date {
        get { startTimeStr.toTime() }
        set {
            startTimeStr = newValue.toString()
            _ = self.isStarting()
        }
    }
    var endTime: Date {
        get { endTimeStr.toTime() }
        set {
            endTimeStr = newValue.toString()
            _ = self.isStarting()
        }
    }
    
    var isOn: Bool {
        get { _isOn }
        set {
            _isOn = newValue
            _ = self.isStarting()
        }
    }
    
    var scheduled: Bool {
        get { _scheduled }
        set {
            _scheduled = newValue
            _ = self.isStarting()
        }
    }
    
    var allDay: Bool {
        get { _allDay }
        set {
            _allDay = newValue
            _ = self.isStarting()
        }
    }
    
    var selectedDays: Int {
        get { _selectedDays }
        set {
            _selectedDays = newValue
            _ = self.isStarting()
        }
    }

    private let checkInterval: TimeInterval = 1 * 60 // unit: seconds
    private var timer: Timer?

    private var awake: Bool = false
    @Published var runningStatus: RunningStatus = .running
    
    init() {
        start()
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { _ in
            self.wakeUp()
        }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        print("Timer has stoped.")
    }
    
    func isStarting() -> Bool {
        let weekdayIndex = Calendar.current.component(.weekday, from: Date.now) - 1
        let todaySelected = !scheduled || self.selectedDays & (1 << weekdayIndex) != 0
        let nowInRange = !scheduled || self.allDay || (Date.now.afterOrSame(self.startTime) && Date.now.beforeOrSame(self.endTime))
//        print("Current status: isOn: \(isOn), todaySelected: \(todaySelected), nowInRange: \(nowInRange), \(startTime.toString()), \(endTime.toString())")
        let isRunning = self.isOn && todaySelected && nowInRange
        
        if isRunning {
            self.runningStatus = .running
        } else if !self.isOn {
            self.runningStatus = .stopped
        } else if scheduled {
            self.runningStatus = self.selectedDays == 0 ? .stopped : .scheduled
        } else {
            self.runningStatus = .error
        }
        
        return isRunning
    }
    
    @objc func wakeUp() {
        if !self.isStarting() {
            return
        }
        let idleTime = Utils.getIdleTime()
        print("idle time is: \(idleTime)")
        if idleTime > self.wakeUpInterval * 60 {
            print("System idle for more than \(self.wakeUpInterval) minutes.")
            if !self.awake {
                Utils.checkAccessibilityPermission(recheck: true)
            }
            Utils.pressKeyAlt()
            self.awake = false
        } else {
            self.awake = true
        }
    }
}
