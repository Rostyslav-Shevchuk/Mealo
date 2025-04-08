//
//  ProgressBarView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct ProgressBarView: View {
    let title: String
    let value: CGFloat
    let maxValue: CGFloat
    
    // Анімоване значення для прогрес-бара
    @State private var animatedValue: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)

            
            ZStack(alignment: .leading) {
                // Фоновий прогрес-бар
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.progressY)
                
                // Активний прогрес-бар
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.progressR)
                    .frame(width: min(animatedValue / maxValue * 100, 100), height: 10)
            }
            
            Text("\(Int(animatedValue))/\(Int(maxValue))")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(10)
        .background(Color.backgroundB)
        .frame(width: 100, height: 50) // Фіксована ширина для всього VStack
        .cornerRadius(8)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedValue = value
            }
        }
        .onChange(of: value) { newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedValue = newValue
            }
        }
    }
}

#Preview {
    ProgressBarView(title: "Білки", value: 50, maxValue: 150)
}
