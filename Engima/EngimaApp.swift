//
//  EngimaApp.swift
//  Engima
//
//  Created by Mano Rajesh on 6/20/23.
//

import SwiftUI

@main
struct EngimaApp: App {
    let dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
