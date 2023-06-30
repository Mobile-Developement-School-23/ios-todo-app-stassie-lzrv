//
//  RadioButton.swift
//  ToDoList
//
//  Created by Настя Лазарева on 28.06.2023.
//

import Foundation
import UIKit


struct RadioButtonModel{
    
}

class RadioButton:UIButton{
    
    var action: (() -> Void)?
    
    var status : RadioButtonStatus?
    
    let icon:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor(named: "LabelTertiary")
        return view
    }()
    
    init(){
        super.init(frame: .zero)
        if status == nil{
            status = .off
            icon.image = UIImage(named: "radioButton_off")
            
        }
        addSubview(icon)
        setupConstraints()
        addTarget(self, action: #selector(RadioButtonTapped), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func reload(status: RadioButtonStatus){
        self.status = status
        switch status{
        case .on:
            icon.image = UIImage(named: "radioButton_on")
        case .off:
            icon.image = UIImage(named: "radioButton_off")
        case .important:
            icon.image = UIImage(named: "radioButton_imp")
        }
        setNeedsLayout()
    }
    
    @objc
    func RadioButtonTapped(){
        action?()
    }
}

enum RadioButtonStatus{
    case on
    case off
    case important
}
