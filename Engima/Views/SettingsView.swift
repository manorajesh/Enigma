//
//  SettingsView.swift
//  Engima
//
//  Created by Mano Rajesh on 6/21/23.
//

import SwiftUI

struct SettingsView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var stats: FetchedResults<RoundStats>
    @Environment(\.managedObjectContext) var moc
    
    @State private var isPresentingConfirm = false
    
    @AppStorage("score")
    var score = 0
    @AppStorage("streak")
    var streak = 0
    @AppStorage("numCorrect")
    var numCorrect = 0
    @AppStorage("longestStreak")
    var longestStreak = 0
    @AppStorage("numberSystem")
    var numbers: [String] = ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumeralPicker()
                } header: {
                    Text("Number System")
                }
                Section {
                    Button(role: .destructive) {
                        isPresentingConfirm = true
                    } label: {
                        Label("Delete ^[\(stats.count) Statistic](inflect: true)", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    .tint(.red)
                    .confirmationDialog("Delete all statistics and data?",
                                        isPresented: $isPresentingConfirm) {
                        Button("Delete?", role: .destructive) {
                            for stat in stats {
                                moc.delete(stat)
                            }
                            
                            try? moc.save()
                            numCorrect = 0
                            streak = 0
                            isPresentingConfirm.toggle()
                        }
                    } message: {
                        Text("You cannot undo this action")
                    }
                } header: {
                    Text("Data Management")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
