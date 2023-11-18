//
//  ActiveTabView.swift
//  BeActiv
//
//  Created by Danyal Nemati on 11/8/23.
//

import SwiftUI
struct ActiveTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection:$selectedTab){
            HomeView()
                .tag("Home")
                .tabItem{
                    Image(systemName:"house")
                }
                .environmentObject(manager)
            ContentView()
                .tag("Content")
                .tabItem{
                    Image(systemName:"person")
                }
        
        }
    }
}

struct ActiveTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTabView()
    }
}

struct Previews_ActiveTabView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
