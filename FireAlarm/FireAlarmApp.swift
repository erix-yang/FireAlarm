//
//  FireAlarmApp.swift
//  FireAlarm
//
//  Created by Eric Yang on 2024-11-06.
//

import SwiftUI

@main
struct FireAlarmApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
