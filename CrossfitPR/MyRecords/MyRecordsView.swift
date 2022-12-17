//
//  MyRecordsView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 17/12/22.
//

import SwiftUI

struct MyRecordsView: View {
    @State var showNewPRView = false
    
    var body: some View {
        VStack{
            Text("Você ainda não\ntem nenhum record gravado.\n\nComeçe agora mesmo\nadicionando um novo record.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 64)
                OpaqueActionButton(
                    imageName: "figure.cross.training",
                    title: "Add new record",
                    completion: { self.showNewPRView.toggle() }
                ).sheet(isPresented: $showNewPRView) {
                    NewRecordView()
                }
        }
    }
}

struct MyRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecordsView()
    }
}
