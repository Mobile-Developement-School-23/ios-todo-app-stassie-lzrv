//
//  ContentView.swift
//  TodoList_SUI
//
//  Created by Настя Лазарева on 19.07.2023.
//

import SwiftUI

struct MainVC: View {
    @State var isItemViewPresented = false
    @State var doneItemsHidden = true
    @State var items: [TodoItem] = [
        TodoItem(text: "Купить что-то", importance: .basic, isDone: true),
        TodoItem(text: "Купить что-то", importance: .basic, isDone: true),
        TodoItem(text: "Задание", importance: .basic, deadline: Date()),
        TodoItem(text: "Задание", importance: .basic, deadline: Date()),
        TodoItem(text: "Купить что-то", importance: .important),
        TodoItem(text: "Купить что-то", importance: .basic, isDone: true),
        TodoItem(text: "сделать зарядку", importance: .basic),
        TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы пок…", importance: .basic),
        TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем?", importance: .basic),
        TodoItem(text: "Купить сыр", importance: .basic),
        
    ]
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Мои дела")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(Color.black)
                .background(Color(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)))
                .padding(.top, 52)
                .padding(.leading, 32)
            HStack {
                Text("Выполнено — \(items.filter { $0.isDone }.count)")
                    .foregroundColor(Color("LabelTertiary"))
                
                Spacer()
                Button(action: {
                    print("скрыть показать кнопка")
                    doneItemsHidden.toggle()
                }) {
                    Text(doneItemsHidden ? "Скрыть" : "Показать")
                        .foregroundColor(Color("ColorBlue"))
                }
            }
            .padding(.horizontal)
            .padding(.top, 2)
            .padding(.leading)
            .padding(.trailing)
            
            ZStack {
                List {
                    ForEach(items.indices.filter { doneItemsHidden || !items[$0].isDone }, id: \.self) { index in
                        TaskCell(passedTaskItem: $items[index])
                            .listRowInsets(EdgeInsets())
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    print("удалить свайп")
                                } label: {
                                    Image( "trash_button")
                                }
                                Button(action: {
                                    print("инфо свайп")
                                }){
                                    Image("info_button")
                                }
                                .tint(Color("ColorLightGrey"))
                            }
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    print("завершить свайп")
                                    items[index].isDone.toggle()
                                }) {
                                    Image("radioButton_on_white")
                                }
                                .tint(Color("ColorGreen"))
                            }
                    }
                    Button {
                        self.isItemViewPresented = true
                        print("новая задача")
                    } label: {
                        Text("Новое")
                            .foregroundColor(Color("LabelTertiary"))
                            .padding(.leading, 34)
                    }
                    .frame(height: 37)
                }
                .background(Color(UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)))
                .scrollContentBackground(.hidden)
                VStack {
                    Spacer()
                    Button {
                        self.isItemViewPresented = true
                        print("новая задача")
                    } label: {
                        Image("plus")
                            .resizable()
                            .frame(width: 44, height: 44)
                        
                    }.sheet(isPresented: $isItemViewPresented) {
                        TaskVC(items: $items, itemText: "Что надо сделать?")
                    }
                }
            }
        }
        .background(Color("BackPrimary"))
    }
}

