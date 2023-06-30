//
//  ImportanceView.swift
//  ToDoList
//
//  Created by Настя Лазарева on 27.06.2023.
//

import Foundation
import UIKit

class ImportanceView: UIView{
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.textColor = UIColor(named: "LabelPrimary")
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let control : UISegmentedControl = {
        let control = UISegmentedControl(items: ["", "нет", ""])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.setTitle(nil, forSegmentAt: 0)
        control.setTitle(nil, forSegmentAt: 2)
        control.setImage(UIImage(named: "low_priority_icon.svg"), forSegmentAt: 0)
        control.setImage(UIImage(named: "high_priority_icon.svg"), forSegmentAt: 2)
        control.selectedSegmentIndex = 1
        return control
    }()
    
    
    init(){
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "BackSecondary")
        layer.cornerRadius = 16
        addSubview(control)
        addSubview(label)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            label.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            control.topAnchor.constraint(equalTo: topAnchor, constant: 10 ),
            control.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            control.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            control.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
