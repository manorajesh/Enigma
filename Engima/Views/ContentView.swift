//
//  ContentView.swift
//  Engima
//
//  Created by Mano Rajesh on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GameView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game")
                }
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Statistics")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
