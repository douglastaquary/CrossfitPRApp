//
//  HSubtitleView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 01/05/22.
//

import SwiftUI


struct HSubtitleView: View {
    var imageSystemName: String = "dumbbell"
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(Color.green.opacity(0.1))
                .frame(width: 32 , height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
                .overlay(Image(systemName: imageSystemName).foregroundColor(.green).opacity(0.5))
                .padding(.trailing, 4)

            Text(LocalizedStringKey(title))
                .foregroundColor(.secondary)
            Spacer()
            Text(LocalizedStringKey(subtitle))
                .bold()
        }
        .frame(height: 42)
    }
}

struct HSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        HSubtitleView(title: "teste", subtitle: "teste")
    }
}


struct EmptyView: View {
    @State var message: String
    var body: some View {
        VStack(alignment: .center) {
            Text(LocalizedStringKey(message))
                .multilineTextAlignment(.center)
                .lineLimit(8)
                .foregroundColor(.secondary)
        }
    }
}


struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(message: "Get started\nnow by adding a new\npersonal record")
    }
}


struct DialogView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue).ignoresSafeArea()

            VStack {
                Circle()
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 44, height: 44)
                Text("Meng To").bold()
                Capsule()
                    .foregroundColor(Color.green)
                    .frame(height: 44)
                    .overlay(Text("Sign up"))
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            .padding()
        }
    }
}


struct DialogUI_Previews: PreviewProvider {
    static var previews: some View {
        DialogView()
    }
}


