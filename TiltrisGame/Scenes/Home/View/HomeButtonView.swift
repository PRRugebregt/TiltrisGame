//
//  HomeButtonView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 08/02/2025.
//

import SwiftUI

struct HomeButtonView: View {
    var text: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(color)
                Text(text)
                    .foregroundStyle(.black)
                    .font(.title)
            }
            .frame(height: 80)
            .padding()
        })
    }
}

#Preview {
    HomeButtonView(text: "", color: .yellow, action: {})
}
