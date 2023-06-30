//
//  ColorPickerView.swift
//  ToDoList
//
//  Created by Настя Лазарева on 27.06.2023.
//

import Foundation
import UIKit

class ColorPickerView: UIView{
    let button: UIButton = {
        let color_button = UIButton()
        color_button.backgroundColor = UIColor(named: "LabelPrimary")
        color_button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        color_button.layer.cornerRadius = 16
        color_button.translatesAutoresizingMaskIntoConstraints = false
        return color_button
    }()
    
    private let label:UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.textColor = UIColor(named: "LabelPrimary")
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "BackSecondary")
        layer.cornerRadius = 16
        addSubview(label)
        addSubview(button)
        setupConstraints()
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            label.leadingAnchor.constraint(equalTo:leadingAnchor,constant: 16),
            label.trailingAnchor.constraint(equalTo:trailingAnchor,constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 32),
            button.widthAnchor.constraint(equalToConstant: 32),
            button.trailingAnchor.constraint(equalTo:trailingAnchor,constant: -16),
            button.topAnchor.constraint(equalTo: topAnchor,constant: 12),
            button.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
