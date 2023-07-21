//
//  TaskCell.swift
//  TodoList_SUI
//
//  Created by Настя Лазарева on 19.07.2023.
//

import SwiftUI

struct TaskCell: View {
    @Binding var passedTaskItem: TodoItem
    
    var body: some View
    {
        HStack(spacing: 16)
        {
            Image(passedTaskItem.isDone ? "radioButton_on" : passedTaskItem.importance == .important ? "radioButton_imp" : "radioButton_off")
                .gesture(TapGesture().onEnded {
                    withAnimation {
                        passedTaskItem.isDone.toggle()
                        print(passedTaskItem.isDone)
                    }
                })
            HStack(spacing: 0){
                Text("")
                if(passedTaskItem.importance != .basic){
                    Image( passedTaskItem.importance == .important ? "high_priority_icon" :"low_priority_icon")
                }
                VStack(spacing: 0){
                    if(passedTaskItem.isDone){
                        Text(passedTaskItem.text)
                            .strikethrough(true, color: .gray)
                            .foregroundColor(.gray)
                            .font(.system(size: 17))
                            .lineLimit(3)
                            .frame(maxWidth: 252,alignment: .leading)
                        
                    }else{
                        Text(passedTaskItem.text)
                            .font(.system(size: 17))
                            .lineLimit(3)
                            .frame(maxWidth: 252,alignment: .leading)
                    }
                    if let deadline = passedTaskItem.deadline {
                        DeadlineLabel(label: deadline)
                    }
                }
                
            }
            Spacer()
            Image("icon_chevron")
        }
        .padding(16)
    }
    
}

