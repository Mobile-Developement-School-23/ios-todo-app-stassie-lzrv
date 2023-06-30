//
//  DeadlineLabel.swift
//  ToDoList
//
//  Created by Настя Лазарева on 28.06.2023.
//

import Foundation
import UIKit

class DeadlineLabel:UIStackView{
    
    private let icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "deadline_icon")
        view.tintColor = UIColor(named: "LabelTertiary")
        return view
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(named: "LabelTertiary")
        return label
    }()
    
    init(){
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 4
        alignment = .center
        addArrangedSubview(icon)
        addArrangedSubview(label)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
