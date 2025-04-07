//
//  CalorieProgressBarView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct CalorieProgressBarView: View {
    let consumedCalories: CGFloat
    let remainingCalories: CGFloat
    let burnedCalories: CGFloat
    let progress: CGFloat
    
    // Анімовані значення для тексту
    @State private var animatedConsumed: CGFloat = 0
    @State private var animatedRemaining: CGFloat = 0
    @State private var animatedBurned: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 20) {
            // Скільки з'їдено калорій
            VStack {
                Text("\(Int(animatedConsumed))")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text("З’їдено")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Круговой прогрес-бар
            ZStack {
                // Фоновий півкруг (синій)
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(Color.blue.opacity(0.3), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(180))
                    .frame(width: 138, height: 138)
                // Жовтий прогрес-бар (півкруг) з анімацією
                Circle()
                    .trim(from: 0.0, to: progress * 0.5)
                    .stroke(Color.yellow, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(180))
                    .frame(width: 138, height: 138)
                
                // Текст всередині кола
                VStack(spacing: 5) {
                    Text("\(Int(animatedRemaining))")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Text("Залишилось")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Спалені калорії
            VStack(spacing: 0) {
                Text("\(Int(animatedBurned))")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text("Спалено")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            // Анімація для тексту
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedConsumed = consumedCalories
                animatedRemaining = remainingCalories
                animatedBurned = burnedCalories
            }
        }
        .onChange(of: consumedCalories) { newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedConsumed = newValue
            }
        }
        .onChange(of: remainingCalories) { newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedRemaining = newValue
            }
        }
        .onChange(of: burnedCalories) { newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedBurned = newValue
            }
        }
    }
}

#Preview {
    CalorieProgressBarView(consumedCalories: 500, remainingCalories: 1500, burnedCalories: 300, progress: 0.25)
}
