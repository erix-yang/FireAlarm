//
//  FireAlarmApp.swift
//  FireAlarm
//
//  Created by Eric Yang on 2024-11-06.
//

import SwiftUI

@main
struct FireAlarmApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

