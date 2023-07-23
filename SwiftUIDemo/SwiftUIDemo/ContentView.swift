//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by 胡永亮 on 2023/7/21.
//

import SwiftUI

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                
            }.frame(width: ScreenWidth, height: 320)
        }.navigationTitle("Game")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
