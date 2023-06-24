//
//  Separator.swift
//  ToDoList
//
//  Created by Настя Лазарева on 24.06.2023.
//

import Foundation
import UIKit

final class Separator: UIView{
    init(){
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "SupportSeparator")
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
