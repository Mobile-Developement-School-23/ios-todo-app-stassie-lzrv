//
//  DeadlineView.swift
//  TodoList_SUI
//
//  Created by Настя Лазарева on 20.07.2023.
//

import SwiftUI

struct DeadlineView: View {
    @Binding var isSwitchOn: Bool
    @Binding var datePickerHidden: Bool
    @Binding var itemDeadline: Date
    
    var body: some View {
        
        Toggle(isOn: $isSwitchOn) {
            Text("Сделать до")
            if isSwitchOn {
                Button(action: {
                    withAnimation {
                        datePickerHidden.toggle()
                    }
                }) {
                    Text(Formatter.date.string(from: itemDeadline))
                }
            }
        }
        .padding(4)

        if datePickerHidden {
            DatePicker(
                selection: $itemDeadline,
                displayedComponents: [.date],
                label: {}
            )
            .padding(.top, -20)
            .datePickerStyle(GraphicalDatePickerStyle())
        }
    }
}

