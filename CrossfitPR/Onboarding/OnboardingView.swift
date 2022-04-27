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
        
                
                VStack(alignment: .leading) {
                    NewDetail(image: "heart.fill", imageColor: .green, title: "Anote seus PRs sem complicações", description: "Todas as informações sobre os seus PRs em um só lugar")
                    NewDetail(image: "paperclip", imageColor: .blue, title: "New Spotlight Tab", description: "Discover great stories selected by our editors.")
                    NewDetail(image: "play.rectangle.fill", imageColor: .black, title: "Wods para treinar em casa", description: "Wods gratuitos para treinar a qualquer hora e lugar")
            }

            Spacer()
            
            Button(action: {
                UserDefaults.standard.set(true, forKey: "LaunchBefore")
                withAnimation(){
                    self.viewlaunch.currentPage = Route.prHistoriesListView.rawValue
                }
            }){
            Text("Começar")
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 350, height: 48)
                .background(Color.green)
                .cornerRadius(8)
                .padding(.top, 50)
            }
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
        .padding(10)
    }
}
