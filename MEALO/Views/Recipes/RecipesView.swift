//
//  RecipesView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct RecipesView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                Text("Тут будуть рецепти")
                    .font(.system(size: 25, weight: .bold, design: .monospaced))
                    .navigationTitle("Рецепти")
            }
        }
    }
}

#Preview {
    RecipesView()
}
