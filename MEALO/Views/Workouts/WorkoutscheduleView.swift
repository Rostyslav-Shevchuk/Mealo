//
//  WorkoutReminderView.swift
//  MEALO
//
//  Created by Ростислав on 22.03.2025.
//

import SwiftUI

struct WorkoutReminderView: View {
    var body: some View {
        NavigationStack {
            Text("Тут будуть нагадування")
                .font(.system(size: 25, weight: .bold, design: .monospaced))
            .navigationTitle("Нагадування")
        }
    }
}

#Preview {
    WorkoutReminderView()
}
