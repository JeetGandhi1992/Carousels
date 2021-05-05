//
//  TabBarView.swift
//  Distance Tracker
//
//  Created by Jeet Gandhi on 6/4/21.
//

import SwiftUI
import Combine

struct TabBarView: View {
    
    @State var selectedTab = 0
    @ObservedObject var tabBarViewModel = TabBarViewModel()
    
    var body: some View {
        TabView(selection: $tabBarViewModel.selectedTab) {
            ContentView()
                .tabItem {
                    Label("Emojis", systemImage: "person.fill")
                }
                .tag(0)
            SpotifyView()
                .tabItem {
                    Label("Spotify",
                          systemImage: "music.note")
                }
                .tag(1)
            GridView()
                .tabItem {
                    Label("Grid",
                          systemImage: "square.grid.3x2")
                }
                .tag(2)
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
    
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
