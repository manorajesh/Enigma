//
//  GameView.swift
//  Engima
//
//  Created by Mano Rajesh on 6/21/23.
//

import SwiftUI
import AVFoundation
import NaturalLanguage

struct MoveStats: Decodable {
    var id = UUID()
    var isCorrect = false
    var selectedNumber = -1
    var correctNumber = -1
    var correctSymbol = ""
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct GameView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var selectedNumber: Int?
    @State private var selectedCharacter: String = ""
    @State private var selectedIndex: Int?
    @State private var roundStart: Date?
    @State private var answerOpacity = 0.0
    
    //    @State var speechSynth = AVSpeechSynthesizer()
    let synthesizer = AVSpeechSynthesizer()
    
    @AppStorage("score")
    var score = 0
    @AppStorage("streak")
    var streak = 0
    @AppStorage("numCorrect")
    var numCorrect = 0
    @AppStorage("longestStreak")
    var longestStreak = 0
    @AppStorage("language")
    var language = "Devanagari"
    @AppStorage("numberSystem")
    var numbers: [String] = ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"]
    
    @State private var isSuccess: Bool?
    
    var body: some View {
        ZStack {
            if let isSuccess = isSuccess {
                Circle()
                    .fill(isSuccess ? .green : .red)
                    .blur(radius: 100.0)
                    .frame(width: isSuccess ? CGFloat(streak+2) * 10+50 : 200)
                    .animation(.easeIn, value: streak)
            }
            
            VStack {
                Text("\(selectedCharacter)")
                    .font(.system(size: 100.0))
                    .textSelection(.enabled)
                    .onTapGesture {
                        let utterance = AVSpeechUtterance(string: selectedCharacter)
                        var langCode: String?
                        switch language {
                        case "Devanagari":
                            langCode = "hi"
                        case "Chinese":
                            langCode = "zh-Hant"
                        default:
                            langCode = "en-US"
                        }
                        utterance.voice = AVSpeechSynthesisVoice(language: langCode)
                        
                        synthesizer.speak(utterance)
                    }
                
                VStack {
                    ForEach(0..<3) { row in
                        HStack {
                            ForEach(1..<4) { column in
                                let number = row * 3 + column
                                Button(action: {
                                    self.selectedNumber = number
                                    print("Tapped number: \(number)")
                                    
                                    if selectedNumber == selectedIndex {
                                        score += 1
                                        streak += 1
                                        numCorrect += 1
                                        withAnimation {
                                            isSuccess = true
                                        }
                                    } else {
                                        score -= 1
                                        streak = 0
                                        withAnimation {
                                            isSuccess = false
                                        }
                                    }
                                    
                                    onRoundFinish(isCorrect: isSuccess!)
                                    getRandomNumber()
                                    print("\(selectedCharacter) at \(selectedIndex!)")
                                }) {
                                    Text("\(number)")
                                        .frame(width: 60, height: 60)
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(30)
                                }
                            }
                        }
                    }
                    HStack {
                        Button(action: {
                            self.selectedNumber = 0
                            print("Tapped number: 0")
                            
                            if selectedNumber == selectedIndex {
                                score += 1
                                streak += 1
                                numCorrect += 1
                                withAnimation {
                                    isSuccess = true
                                }
                            } else {
                                score -= 1
                                streak = 0
                                withAnimation {
                                    isSuccess = false
                                }
                            }
                            onRoundFinish(isCorrect: isSuccess!)
                            getRandomNumber()
                            print("\(selectedCharacter) at \(selectedIndex!)")
                        }) {
                            Text("0")
                                .frame(width: 60, height: 60)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                    }
                }
                
                ZStack {
                    Image(systemName: "lightbulb")
                        .opacity(1.0-answerOpacity)
                    Text("\(selectedIndex ?? -1)")
                        .opacity(answerOpacity)
                }
                .onTapGesture {
                    withAnimation {
                        answerOpacity = 1.0
                    }
                }
                .padding()
            }
        }
        .onAppear {
            getRandomNumber()
        }
    }
    
    func getRandomNumber() {
        selectedIndex = Int.random(in: 0..<numbers.count)
        selectedCharacter = numbers[selectedIndex!]
        
        // Start round timer
        roundStart = Date()
    }
    
    func onRoundFinish(isCorrect: Bool) {
        if longestStreak < streak {
            longestStreak = streak
        }
        
        let stat = RoundStats(context: moc)
        stat.id = UUID()
        stat.timestamp = Date()
        stat.correctNumber = Int16(selectedIndex!)
        stat.displayNumber = selectedCharacter
        stat.selectedNumber = Int16(selectedNumber!)
        stat.isCorrect = isCorrect
        stat.timeTaken = Date().timeIntervalSince(roundStart!)
        stat.language = language
        
        answerOpacity = 0
        
        try? moc.save()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
