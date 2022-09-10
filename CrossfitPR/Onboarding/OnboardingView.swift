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
                    .font(.system(size: 36))
                    .frame(width: 300, alignment: .leading)
            
            HViewImageAndText(image: "list.bullet", imageColor: .green, title: "Organizing your records", description: "Organizing your personal records makes the evolution of your exercises more practical")
            
            HViewImageAndText(image: "figure.strengthtraining.traditional", imageColor: .green, title: "Anote seus PRs sem complicações", description: "Seus recordes pessoais em um só lugar: fácil e prático.")
            
            HViewImageAndText(image: "chart.xyaxis.line", imageColor: .green, title: "Gráficos simplificados", description: "Gráficos simples e fáceis de entender para mostrar sua evolucão")
            
            HViewImageAndText(image: "chart.bar", imageColor: .green, title: "The Powerful Insights", description: "The powerful insights elevator allows you to understand your biggest records and the evolution of others")
  
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
