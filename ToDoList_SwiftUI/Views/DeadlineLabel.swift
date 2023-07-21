//
//  DeadlineLabelView.swift
//  TodoList_SUI
//
//  Created by Настя Лазарева on 19.07.2023.
//

import SwiftUI

struct DeadlineLabel: View {
    
    var label: Date
    var body: some View {
        HStack{
            Image("deadline_icon")
            Text(Formatter.date.string(from: label))
                .foregroundColor(Color("LabelTertiary"))
                .font(.system(size: 15))
            Spacer()
        }
       
        
    }
}


extension Formatter {
    static var date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        formatter.dateFormat = "d MMMM "
        return formatter
    }()
}
