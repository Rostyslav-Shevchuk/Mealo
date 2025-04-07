//
//  ProgressBarView.swift
//  MEALO
//
//  Created by Ростислав on 26.03.2025.
//

import SwiftUI

struct ProgressBarView: View {
    let title: String
    let value: CGFloat
    let maxValue: CGFloat
    let progressColor: Color
    
    @State private var animatedValue: CGFloat = 0
    
    // Обмежуємо прогрес до 100%
    private var cappedProgress: CGFloat {
        min(value, maxValue) // Якщо value більше maxValue, беремо maxValue
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
            
            ZStack(alignment: .leading) {
                // Фон прогрес-бара
                Rectangle()
                    .frame(width: 94, height: 5)
                    .cornerRadius(5)
                    .foregroundColor(Color.progressY)
                
                // Прогрес-бар із анімацією (обмежений до maxValue)
                Rectangle()
                    .frame(width: cappedProgress / maxValue * 94, height: 5)
                    .cornerRadius(5)
                    .foregroundColor(progressColor)
                    .overlay(
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(progressColor)
                            .offset(x: cappedProgress / maxValue * 94 - 5)
                    )
            }
            
            // Відображаємо поточне значення і максимальне значення
            Text("\(Int(value))/\(Int(maxValue))")
                .font(.system(size: 7, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 110, height: 35, alignment: .center)
        .background(Color.backgroundB)
        .cornerRadius(8)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedValue = cappedProgress
            }
        }
        .onChange(of: value) { newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedValue = min(newValue, maxValue) // Обмежуємо анімацію
            }
        }
    }
}

#Preview {
    ProgressBarView(title: "Білки", value: 150, maxValue: 100, progressColor: .green)
}
