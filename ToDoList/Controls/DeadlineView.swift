//
//  DeadlineView.swift
//  ToDoList
//
//  Created by Настя Лазарева on 27.06.2023.
//

import Foundation
import UIKit

class DeadlineView:UIView {
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let label :UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.textColor = UIColor(named: "LabelPrimary")
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    let date_button : UIButton = {
        let date_button = UIButton()
        date_button.setTitleColor(UIColor(named: "ColorBlue"), for: .normal)
        date_button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        date_button.translatesAutoresizingMaskIntoConstraints = false
        date_button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        return date_button
    }()
    
    let switcher:UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    init(){
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "BackSecondary")
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(date_button)
        addSubview(switcher)
        setupConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
            switcher.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            switcher.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            switcher.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8)
        ])
    }
}
