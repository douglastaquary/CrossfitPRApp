//
//  OnboardingView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Combine
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewlaunch: ViewLaunch
    var body: some View {
        VStack {
            Spacer()
                Text("What's New")
                    .fontWeight(.heavy)
                    .font(.system(size: 50))
                    .frame(width: 300, alignment: .leading)
        
            NewDetail(image: "heart.fill", imageColor: .green, title: "Anote seus PRs sem complicações", description: "Todas as informações sobre os seus PRs em um só lugar")
            NewDetail(image: "paperclip", imageColor: .blue, title: "Organizing your PRs", description: "Organizing your personal records makes the evolution of your exercises more practical")
            NewDetail(image: "paperclip", imageColor: .blue, title: "The powerful insights", description: "The powerful insights elevator allows you to understand your biggest records and the evolution of others")
//                VStack(alignment: .leading) {
//                    NewDetail(image: "heart.fill", imageColor: .green, title: "Anote seus PRs sem complicações", description: "Todas as informações sobre os seus PRs em um só lugar")
//                    NewDetail(image: "paperclip", imageColor: .blue, title: "Organizing your PRs", description: "Organizing your personal records makes the evolution of your exercises more practical")
//                    NewDetail(image: "paperclip", imageColor: .blue, title: "The powerful insights", description: "The powerful insights elevator allows you to understand your biggest records and the evolution of others")
//
//            }

            Spacer()
            VStack {
                Button("Start"){
                    UserDefaults.standard.set(true, forKey: "LaunchBefore")
                    withAnimation(){
                        self.viewlaunch.currentPage = Route.prHistoriesListView.rawValue
                    }
                }
                .buttonStyle(FilledButton(widthSizeEnabled: true))
            }
            .padding()
            
        }
    }
}

struct NewDetail: View {
    var image: String
    var imageColor: Color
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: image)
                    .font(.system(size: 50))
                    .frame(width: 50)
                    .foregroundColor(imageColor)
                    .padding()

                VStack(alignment: .leading) {
                    Text(title).bold()
                
                    Text(description)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }.frame(width: 340, height: 100)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct NewDetail_Previews: PreviewProvider {
    static var previews: some View {
        NewDetail(image: "heart.fill", imageColor: .pink, title: "More Personalized", description: "Top Stories picked for you and recommendations from siri.")
        .previewLayout(.sizeThatFits)
    }
}
