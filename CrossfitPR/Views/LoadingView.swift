//
//  LoadingView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 04/12/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ProgressView()
                .foregroundColor(.gray)
            Text("loading.view.title")
                .foregroundColor(.gray)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
