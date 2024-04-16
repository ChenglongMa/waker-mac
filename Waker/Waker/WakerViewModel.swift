//
//  WakerViewModel.swift
//  Waker
//
//  Created by Chenglong Ma on 11/4/2024.
//

import SwiftUI

class WakerViewModel: ObservableObject {

    @AppStorage("isOn") var isOn = true
    @AppStorage("wakeUpInterval") var wakeUpInterval: Double = 5.0 //* 60 // unit: seconds
    @AppStorage("scheduled") var scheduled: Bool = false
    @AppStorage("startTime") private var startTimeStr: String = "09:00"
    @AppStorage("endTime") private var endTimeStr: String = "17:00"
    @AppStorage("allDay") var allDay: Bool = false
    @AppStorage("scheduledDays") var selectedDays: Int = Constants.allWeekDays

    var startTime: Date {
        get { startTimeStr.toTime() }
        set { startTimeStr = newValue.toString() }
    }
    var endTime: Date {
        get { endTimeStr.toTime() }
        set { endTimeStr = newValue.toString() }
    }

    private let checkInterval: TimeInterval = 2 //* 60 // unit: seconds
    private var timer: Timer?

    private var awake: Bool = false
//    @Published var isRunning: Bool = false
    @Published var runningStatus: RunningStatus = RunningStatus.running
    
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
        print("Current status: isOn: \(isOn), todaySelected: \(todaySelected), nowInRange: \(nowInRange), \(startTime.toString()), \(endTime.toString())")
        let isRunning = self.isOn && todaySelected && nowInRange
        
        if isRunning {
            self.runningStatus = RunningStatus.running
        } else if !self.isOn {
            self.runningStatus = RunningStatus.stopped
        } else if scheduled {
            self.runningStatus = RunningStatus.scheduled
        } else {
            self.runningStatus = RunningStatus.error
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
