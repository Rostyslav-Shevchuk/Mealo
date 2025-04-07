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
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .frame(alignment: .center)
            
            ZStack(alignment: .leading) {
                // Фоновий прогрес-бар
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.progressY)
                    .frame(width: 100, height: 10) // Фіксована ширина
                
                // Активний прогрес-бар
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.progressR)
                    .frame(width: min(animatedValue / maxValue * 100, 100), height: 10)
            }
            .frame(width: 100) // Фіксована ширина для ZStack
            
            Text("\(Int(animatedValue))/\(Int(maxValue))")
                .font(.caption)
                .foregroundColor(.white)
                .frame(width: 100, alignment: .leading) // Фіксована ширина
        }
        .padding(5)
        .background(Color.backgroundB)
        .frame(width: 100) // Фіксована ширина для всього VStack
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
