//
//  StatisticsView.swift
//  Engima
//
//  Created by Mano Rajesh on 6/21/23.
//

import SwiftUI

struct StatisticsView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var stats: FetchedResults<RoundStats>
    @Environment(\.managedObjectContext) var moc
    
    @AppStorage("score")
    var score = 0
    @AppStorage("streak")
    var streak = 0
    @AppStorage("numCorrect")
    var numCorrect = 0
    @AppStorage("longestStreak")
    var longestStreak = 0
    
    @State private var accuracy = 0.0
    @State private var averageTimeTaken = 0.0
    @State private var mostMissed = ":)"
    @State private var isPresentingConfirm = false
    
    var body: some View {
        NavigationView {
            Group {
                List {
                    VStack(alignment: .center) {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text("Accuracy")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text("\(String(format: "%.0f", accuracy*100))%")
                                    .font(.title2)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Most Missed")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text("\(mostMissed)")
                                    .font(.title2)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Average Time Taken")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text("\(String(format: "%.2f", averageTimeTaken)) s")
                                    .font(.title2)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Longest Streak")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text("\(longestStreak)")
                                    .font(.title2)
                            }
                        }
                    }
                    
                    ForEach(stats) { stat in
                        NavigationLink {
                            StatDetail(stat: stat)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(stat.isCorrect ? .green : .red)
                                    .blur(radius: 30.0)
                                    .frame(width: 1000, height: 50)
                                
                                Text("\(stat.displayNumber ?? "") → \(stat.correctNumber)")
                                    .font(.title3)
                            }
                            .padding(.horizontal)
                            .edgesIgnoringSafeArea([.bottom, .top])
                        }
                    }
                }
                .navigationTitle("Statistics")
            }
        }
        .onAppear {
            accuracy = stats.count > 0 && stats.count > numCorrect ? Double(numCorrect) / Double(stats.count) : 1.0
            averageTimeTaken = getAverageTimeTaken()
            print(Double(numCorrect) / Double(stats.count))
            print(Double(numCorrect))
            print(Double(stats.count))
            mostMissed = getMostMissed()
        }
    }
    
    func getMostMissed() -> String {
        var missedCounts: [String: Int] = [:]
        for stat in stats {
            if !stat.isCorrect {
                missedCounts[stat.displayNumber!] = missedCounts[stat.displayNumber!] ?? 0 + 1
            }
        }
        
        if let maxEntry = missedCounts.max(by: { a, b in a.value < b.value }) {
            return maxEntry.key
        } else {
            return ":)"
        }
    }
    
    func getAverageTimeTaken() -> Double {
        var sum = 0.0
        let count = stats.count
        
        for stat in stats {
            sum += stat.timeTaken
        }
        
        return sum / Double(count)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
