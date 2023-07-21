//
//  TaskVC.swift
//  TodoList_SUI
//
//  Created by Настя Лазарева on 20.07.2023.
//

import SwiftUI

struct TaskVC: View {
    @Binding var items: [TodoItem]
    @State var itemText: String
    @State var itemDate: Date = Date()
    @State private var itemImportance = 1
    
    @State private var savePressed = false
    @State private var isCancelButtonPressed = false
    @State private var isDeadlineOn = false
    @State private var isCalendarVisible = false

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    VStack {
                        TextEditor(text: $itemText)
                            .background(Color("BackSecondary"))
                            .frame(minHeight: 88)
                    }
                    .frame(minHeight: 120)
                    .background(Color("BackSecondary"))
                    .cornerRadius(16)
                    .padding(.bottom, 16)
                    Section {
                        ImportanceView(selectedImportance: $itemImportance)
                        DeadlineView(isSwitchOn: $isDeadlineOn, datePickerHidden: $isCalendarVisible, itemDeadline: $itemDate)
                    }
                    Section {
                        Button(action: {
                            self.isCancelButtonPressed = true
                        }) {
                            Text("Удалить")
                                .foregroundColor(Color("ColorRed"))
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .padding(.vertical, 10)
                            
                        }
                    }
                    .navigationBarTitle("Дело")
                    .navigationBarTitleDisplayMode(.inline)
                    
                    .navigationBarItems(leading:
                                            Button("Отменить") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    )
                    .navigationBarItems(trailing:
                                            Button(action: {
                        var deadlineForItem: Date?
                        if isDeadlineOn {
                            deadlineForItem = itemDate
                        }
                        var importance = Importance.basic
                        if itemImportance == 0 {
                            importance = .low
                        } else if itemImportance == 2 {
                            importance = .important
                        }
                        let item = TodoItem(text: itemText, importance: importance, deadline: deadlineForItem, isDone: false, creationDate:  Date())
                        items.append(item)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Сохранить")
                    } .disabled(itemText.isEmpty)
                    )
                }
                
            }
            
        }
        .background(Color("BackPrimary"))
        
    }
}


