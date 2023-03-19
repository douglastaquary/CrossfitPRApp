//
//  PRPercentagesView.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 26/01/23.
//

import SwiftUI

struct PRPercentagesView: View {
    @State var record: PersonalRecord
    let config = [
        GridItem(.adaptive(minimum: 60))
    ]
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Text(record.prName).font(.title2)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(record.kiloValue.formatted()) kg").font(.title2).fontWeight(.bold)
                }
            }
            .padding()

            VStack(alignment: .leading) {
                Text("Porcentagens do seu record")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(1 ..< 11) { i in
                        Button(action: {}) {
                            VStack(spacing: 8) {
                                let percentage = Int(i*10)
                                let kiloValue = ((record.kiloValue)*percentage)/100
                                Text("100 kg")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                                    .lineLimit(0)
                                    .frame(maxWidth: .infinity)
                                Text("\(percentage)%")
                                    .font(.title3)
                                    .foregroundColor(.primary)
                            }
                            .padding(8)
                            .buttonStyle(CardFilledButton())
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.primary, lineWidth: 1))
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct PRPercentagesView_Previews: PreviewProvider {
    static var previews: some View {
        PRPercentagesView(record: PersonalRecord())
    }
}


struct Cell: View {
    let row: Int
    let column: Int
    
    var body: some View {
        Button(action: {}) {
            Text("\(row), \(column)")
                .frame(width: 320, height: 180)
                .background(Color.blue)
        }
        .buttonStyle(.bordered)
    }
}

struct Row: View {
    let index: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<10) { i in
                    Cell(row: index, column: i)
                }
            }
            .padding([.leading, .trailing], 40)
            .padding(.top, 20)
            .padding(.bottom, 80)
        }
    }
}


struct Grid: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<20) { i in
                    Row(index: i)
                }
            }
        }
    }
}
