//
//  HomeView.swift
//  BeActiv
//
//  Created by Danyal Nemati on 11/8/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    //array for welcome message
    let welcomeArray = ["Welcome", "Bienvenido", "سلام"]
    @State private var currentIndex = 0
    var body: some View {
        VStack(alignment: .leading){
            Text(welcomeArray[currentIndex])
                .font(.largeTitle)
                .padding()
                .foregroundColor(.secondary)
                .animation(.easeInOut(duration: 1), value: currentIndex)
                .onAppear{
                    startWelcomeTimer()
                }
            LazyVGrid(columns:Array (repeating: GridItem(spacing: 20), count:2)){
                //sorting the dictionary by id
                ForEach(manager.mockActivities.sorted(by: {$0.value.id < $1.value.id}), id: \.key) { item in
                    ActivityCard(activity: item.value)
                    
                }
                
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
    //cycles through welcomeArray
    func startWelcomeTimer() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HealthManager())
    }
}
