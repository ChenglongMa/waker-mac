//
//  MenuBar.swift
//  Waker
//
//  Created by Chenglong Ma on 13/4/2024.
//

import SwiftUI
import LaunchAtLogin
import Sparkle
import UserNotifications

struct MenuBar: View {
    
    @EnvironmentObject var viewModel: WakerViewModel
    @Binding var appName: String
    @Binding var appIcon: String
    
    @State private var isOn: Bool = true
    @AppStorage("lanunchAtLogin") private var launchAtLogin: Bool = false
    @State private var everyday: Bool = true
    @State var selectedDays: Int = 0
    
    @State private var wakeUpInterval: Double = 5.0
    @State private var scheduled: Bool = false
    @State private var startTime: Date = "09:00".toTime()
    @State private var endTime: Date = "17:00".toTime()
    
    @State private var allDay: Bool = false
    
    @State private var selectedSymbolIndex = 0
    @State private var customSymbolName = ""
    @State private var observer: NSKeyValueObservation?
    
    private let weekdays: [String] = Calendar.current.shortStandaloneWeekdaySymbols
    @State private var firstWeekdayIndex = Calendar.current.firstWeekday - 1
    
    let updaterController: SPUStandardUpdaterController
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    private let backgroundColor: Color = Color(NSColor.windowBackgroundColor)
    
    
    
    var body: some View {
        
        VStack(spacing:15) {
            Toggle(isOn: $isOn) {
                Label(appName, systemImage: appIcon)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .padding(10)
            .toggleStyle(.switch)
            .background(self.backgroundColor)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 0)
            .padding(.horizontal)
            
            VStack{
                HStack{
                    Text("Wake Up Interval")
                    Spacer()
                    TextField("Wake Up Interval", value: $wakeUpInterval,
                              formatter: self.formatter, prompt: Text("Interval")
                    )
                    .textFieldStyle(.roundedBorder)
                    .fixedSize()
                    Text("mins")
                }.padding([.horizontal, .top])
                
                Slider(value: $wakeUpInterval, in: 1...30)
                    .padding([.horizontal, .bottom])
            }
            .onChange(of: wakeUpInterval) { wakeUpInterval in
                viewModel.wakeUpInterval = round(wakeUpInterval * 10) / 10.0
            }
            .background(self.backgroundColor)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 0)
            .padding(.horizontal)
            
            Toggle("Scheduled", isOn: $scheduled)//.animation())
                .toggleStyle(CustomToggleStyle())
                .padding(.horizontal)
            
            if scheduled {
                self.scheduleView()
            }
            
            // Spacer() // Necessary for animation
            Toggle("Launch at login", isOn: Binding<Bool>(
                get: { launchAtLogin },
                set: { enabled in
                    LaunchAtLogin.isEnabled = enabled
                    launchAtLogin = enabled
                }
            ))
            .toggleStyle(CustomToggleStyle())
            .padding(.horizontal)
            
            Divider()
            HStack {
                Link("GitHub", destination: URL(string: "https://github.com/ChenglongMa/waker-mac")!)
                //                Divider().frame(width: 1)
                //                Link("Feedback", destination: URL(string: "https://github.com/ChenglongMa/waker/issues")!)
                Divider().frame(width: 1)
                CheckForUpdatesView(updater: updaterController.updater)
                Divider().frame(width: 1)
                Button("Quit"){
                    viewModel.stop()
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
                .buttonStyle(.link)
            }.padding()
        }
        .padding(.vertical)
        .onChange(of: isOn) { isOn in
            print("isOn changed")
            viewModel.isOn = isOn
        }
        .onChange(of: scheduled) { scheduled in
            print("scheduled changed")
            viewModel.scheduled = scheduled
        }
        .onChange(of: selectedDays) { selectedDays in
            viewModel.selectedDays = selectedDays
        }
        .onAppear{
            print("appear")
            updaterController.startUpdater()
            //            self.updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: self.updaterDelegate, userDriverDelegate: nil)
            observer = NSApplication.shared.observe(\.keyWindow) { x, y in
                let isVisible = NSApplication.shared.keyWindow != nil
                print("Is visible: \(isVisible)")
                
                if isVisible {
                    wakeUpInterval = viewModel.wakeUpInterval
                    startTime = viewModel.startTime
                    endTime = viewModel.endTime
                    selectedDays = viewModel.selectedDays
                    scheduled = viewModel.scheduled
                    allDay = viewModel.allDay
                    isOn = viewModel.isOn
                    self.firstWeekdayIndex = Calendar.current.firstWeekday - 1
                }
            }
        }
    }
    
    func scheduleView() -> some View {
        return VStack {
            Toggle(isOn: Binding<Bool>(
                get: { everyday },
                set: { selectAll in
                    selectedDays = selectAll ? Constants.ALL_WEEKDAYS : 0
                    everyday = selectAll
                }
            )){
                Text("Everyday").frame(maxWidth: .infinity, minHeight: 0)
            }
            .padding([.leading, .trailing, .top])
            .toggleStyle(.switch)
            
            HStack {
                Spacer()
                let weekdayRange = Array(firstWeekdayIndex..<7) + (0..<firstWeekdayIndex)
                ForEach(weekdayRange, id: \.self) { day in
                    weekdayToggle(day)
                }
                Spacer()
            }.padding(.horizontal)
            
            HStack{
                DatePicker("From", selection: $startTime, displayedComponents: [.hourAndMinute])
                    .labelsHidden()
                    .disabled(allDay)
                
                DatePicker("to", selection: $endTime, displayedComponents: [.hourAndMinute])
                    .padding(.trailing)
                    .disabled(allDay)
                
                Toggle("All Day", isOn: $allDay)
                    .toggleStyle(.checkbox)
            }.padding()
        }
        .onChange(of: allDay) { allDay in
            viewModel.allDay = allDay
        }
        .onChange(of: startTime) { startTime in
            viewModel.startTime = startTime
        }
        .onChange(of: endTime) { endTime in
            viewModel.endTime = endTime
        }
        .background(self.backgroundColor)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 0)
        .padding(.horizontal)
        // TODO: add animation
        //        .transition(.opacity)
        //        .disabled(!scheduled)
    }
    
    func weekdayToggle(_ day: Int) -> some View {
        Toggle(isOn: Binding(
            get: { self.selectedDays & (1 << day) != 0 },
            set: { newValue in
                if newValue {
                    self.selectedDays |= (1 << day)
                    self.everyday = self.selectedDays == Constants.ALL_WEEKDAYS
                } else {
                    self.selectedDays &= ~(1 << day)
                    self.everyday = false
                }
            }
        )){
            Text(self.weekdays[day])
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)
                .fixedSize(horizontal: true, vertical: false)
        }
        .toggleStyle(.button)
    }
    
    func getSelectedDays() -> [Int] {
        var selectedWeekdays: [Int] = []
        
        for i in 0..<7 {
            if self.selectedDays & (1 << i) != 0 {
                selectedWeekdays.append(i)
            }
        }
        return selectedWeekdays
    }
}

struct CustomToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        Toggle(isOn: configuration.$isOn){
            configuration.label
                .frame(maxWidth: .infinity, minHeight: 0)
        }
        .padding(10)
        .toggleStyle(.switch)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 0)
        
    }
}

#Preview {
    MenuBar(appName: Binding.constant("Waker - active"),appIcon: Binding.constant("sun.max.fill"), updaterController: SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil))
        .environmentObject(WakerViewModel())
        .frame(width: 500)
}
