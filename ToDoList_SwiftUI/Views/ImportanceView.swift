//
//  ImportanceView.swift
//  TodoList_SUI
//
//  Created by Настя Лазарева on 20.07.2023.
//

import SwiftUI

struct ImportanceView: View {
    @Binding var selectedImportance: Int
    var body: some View {
        VStack {
            HStack {
                Text("Важность")
                Spacer()
                Picker(selection: $selectedImportance, label: Text("")) {
                    Image("low_priority_icon").tag(0)
                        Text("нет").tag(1)
                        Image("high_priority_icon").tag(2)
                    }
                    .frame(maxWidth: 150)
                    .pickerStyle(SegmentedPickerStyle())
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(4)
        }
    }
}
