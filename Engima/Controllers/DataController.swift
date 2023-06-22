//
//  DataController.swift
//  Engima
//
//  Created by Mano Rajesh on 6/21/23.
//

import Foundation
import CoreData

class DataController: NSObject, ObservableObject {
    let container = NSPersistentContainer(name: "Engima")
    
    override init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
