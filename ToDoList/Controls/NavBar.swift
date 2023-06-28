//
//  NavBar.swift
//  ToDoList
//
//  Created by Настя Лазарева on 27.06.2023.
//

import Foundation
import UIKit

class NavBar: UIStackView{
     let cancellButton : UIButton = {
        let cancellButton = UIButton()
        cancellButton.setTitle("Отменить", for: .normal)
        cancellButton.setTitleColor(UIColor(named: "ColorBlue"), for: .normal)
        cancellButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        cancellButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancellButton.isEnabled = false
        return cancellButton
    }()
    
    let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(UIColor(named: "ColorBlue"), for: .normal)
        saveButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        saveButton.isEnabled = false
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return saveButton
    }()
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Дело"
        label.textColor = UIColor(named: "LabelPrimary")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addArrangedSubview(cancellButton)
        addArrangedSubview(label)
        addArrangedSubview(saveButton)
        axis = .horizontal
        spacing = 10
        distribution = .equalSpacing
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
