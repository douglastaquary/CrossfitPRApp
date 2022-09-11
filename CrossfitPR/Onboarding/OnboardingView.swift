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
                Text(LocalizedStringKey("onboarding.view.title"))
                    .fontWeight(.heavy)
                    .font(.system(size: 36))
                    .frame(width: 300, alignment: .leading)
            
            HViewImageAndText(image: "figure.strengthtraining.traditional", imageColor: .green, title: "onboarding.item2.title", description: "onboarding.item2.description")
            
            HViewImageAndText(
                image: "list.bullet",
                imageColor: .green,
                title: "onboarding.item1.title",
                description: "onboarding.item1.description"
            )
            
            HViewImageAndText(image: "chart.xyaxis.line", imageColor: .green, title: "onboarding.item3.title", description: "onboarding.item3.description")
            
            HViewImageAndText(image: "chart.bar", imageColor: .green, title: "onboarding.item4.title", description: "onboarding.item4.description")
  
            Spacer()
            VStack {
                Button("onboarding.button.title"){
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
