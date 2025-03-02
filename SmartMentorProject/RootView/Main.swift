//
//  ContentView.swift
//  SmartMentorProject
//
//  Created by Shahad Bagarish on 03/02/2025.
//

import SwiftUI

struct Main: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                ChatView( )
                //                                TabView {
//                //                    UserProgressView()
//                //                        .tabItem {
//                //                            Label("Overview", systemImage: "pencil.and.outline")
//                //                        }
//                
//                                    ChatView()
//                                        .tabItem {
//                                            Label("Mentor", systemImage: "ellipsis.message.fill")
//                                        }
//                
//                                    UserProfileView()
//                                        .tabItem {
//                                            Label("Profile", systemImage: "person.crop.circle")
//                                        }
//                                }
//                                .accentColor(.accent)
                
            }
        }
        
    }
}

#Preview {
    Main()
}
