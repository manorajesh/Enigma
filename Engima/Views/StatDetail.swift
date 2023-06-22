//
//  StatDetail.swift
//  Engima
//
//  Created by Mano Rajesh on 6/21/23.
//

import SwiftUI
import Charts

struct StatDetail: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var stats: FetchedResults<RoundStats>
    let stat: RoundStats
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    Text("\(stat.language ?? "Unknown")")
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("Language")
                }
                Section {
                    Text("\(stat.displayNumber ?? "")")
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("Display Number")
                }
                Section {
                    Text("\(stat.correctNumber)")
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("Correct Number")
                }
                Section {
                    Text("\(stat.selectedNumber)")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(stat.isCorrect ? .green : .red)
                } header: {
                    Text("Selected Number")
                }
                Section {
                    Text("\(stat.timeTaken) seconds")
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("Time Taken to Answer")
                }
                Section {
                    Text("\(stat.timestamp?.formatted() ?? "Unknown")")
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("Time Stamp")
                }
                Section {
                    Text("\(stat.id?.uuidString ?? "Unknown")")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.gray)
                } header: {
                    Text("ID")
                } footer: {
                    Text("Internal representation of round")
                }
                
                Section {
                    let indexedStats = stats.enumerated().map { Statistic(id: $0, timeTaken: $1.timeTaken) }

                    Chart(indexedStats) {
                        LineMark(x: .value("Index", $0.id), y: .value("Time Taken", $0.timeTaken))
                    }
                    .padding()
                } header: {
                    Text("Graph of Time Taken")
                }
            }
            .textSelection(.enabled)
        }
        .navigationTitle("Details")
    }
}

struct Statistic: Identifiable {
    let id: Int
    let timeTaken: Double
}

struct StatDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        
    }
}
