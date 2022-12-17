//
//  Extensions.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 29/03/22.
//

import Foundation
import SwiftUI

struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {
    typealias Index = Base.Index
    typealias Element = (index: Index, element: Base.Element)

    let base: Base

    var startIndex: Index { base.startIndex }

    var endIndex: Index { base.endIndex }

    func index(after i: Index) -> Index {
        base.index(after: i)
    }

    func index(before i: Index) -> Index {
        base.index(before: i)
    }

    func index(_ i: Index, offsetBy distance: Int) -> Index {
        base.index(i, offsetBy: distance)
    }

    subscript(position: Index) -> Element {
        (index: position, element: base[position])
    }
}

extension RandomAccessCollection {
    func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }
}

// Butons Extensions

struct FilledButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    var widthSizeEnabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.headline)
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .frame(maxWidth: widthSizeEnabled ? .infinity : .none)
            .padding()
            .background(isEnabled ? Color.green : .gray)
            .cornerRadius(8)
    }
}

struct OutlineButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .fontWeight(.bold)
            .foregroundColor(configuration.isPressed ? .gray : .green)
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                ).stroke(Color.green.opacity(0.15))
        )
    }

}

struct OpacityButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : Color.green.opacity(0.15))
        

        HStack {
            Image(systemName: "figure.strengthtraining.traditional")
                .padding(.leading)
                .foregroundColor(.green)
            Text("Add new record")
                .padding([.bottom, .top, .trailing])
                .foregroundColor(.green)
                .fontWeight(.bold)
                .cornerRadius(12)
        }
        .padding([.trailing, .leading], 56)
        .background(Color.green.opacity(0.15))
        .cornerRadius(10)
        
    }

}

extension Int {
    var pounds: Measurement<Unit> {
        let cleanResult = String(format: "%.0f", self)
        return Measurement(value: Double(cleanResult) ?? 0.0, unit: UnitMass.pounds)
    }
    
    var kilograms: Measurement<Unit> {
        let kgResult = (Double(self) * 0.4)
        let cleanResult = String(format: "%.0f", kgResult)
        return Measurement(value: Double(cleanResult) ?? 0.0, unit: UnitMass.kilograms)
    }
}

extension Measurement {
    var string: String {
        return String(describing: "\(self.value)")
    }
}


extension TimeInterval {
    
    var double: Double {
        return Double(self * 1_000)
    }

    var seconds: Int {
        return Int(self.rounded())
    }

    var milliseconds: Int {
        return Int(self * 1_000)
    }
}


extension Date {
    var dateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}


extension String {
  static func randomNotificationMessage(list:[String]) -> String {
    assert(!list.isEmpty,"Empty Lists not supported")
    return list.randomElement() ?? ""
  }
}

extension View {
    func typeOfUserContentAllowed(_ isPRO: Bool) -> some View {
        return self.environment(\.isPro, isPRO)
    }
        
    func storyManager(_ service: StoreKitManager) -> some View {
        return self.environment(\.storeKitManager, service)
    }
}


extension EnvironmentValues {
    var isPro: Bool {
        get { self[UserIsProKey.self] }
        set { self[UserIsProKey.self] = newValue }
    }
    
    var storeKitManager: StoreKitManager {
        get { self[StoreKitManagerKey.self] }
        set { self[StoreKitManagerKey.self] = newValue }
    }
    
}

