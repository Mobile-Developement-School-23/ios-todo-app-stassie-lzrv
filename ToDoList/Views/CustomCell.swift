//
//  CustomCell.swift
//  ToDoList
//
//  Created by Настя Лазарева on 28.06.2023.
//

import Foundation
import UIKit

final class TaskModel {

    var text: String

    let deadline: Date?

    let radioButton: RadioButtonModel

    init(text: String, deadline: Date?, radioButton: RadioButtonModel) {
        self.text = text
        self.deadline = deadline
        self.radioButton = radioButton
    }
}



class CustomCell: UITableViewCell{
    
    var action: (() -> Void)?
    
    static let identifier = "CustomCell"
    
    var text: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(named: "LabelPrimary")
        return label
    }()
    
    var deadline = DeadlineLabel()
    
    let radio_button = RadioButton()
    
    private let highPriorityIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "high_priority_icon"))
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let lowPriorityIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "low_priority_icon"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let arrowIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_chevron"))
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(named: "ColorGrey")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let HstackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 4
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let VstackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(){
        contentView.addSubview(arrowIcon)
        contentView.addSubview(radio_button)
        contentView.addSubview(HstackView)
        HstackView.addArrangedSubview(highPriorityIcon)
        HstackView.addArrangedSubview(lowPriorityIcon)
        HstackView.addArrangedSubview(VstackView)
        VstackView.addArrangedSubview(text)
        VstackView.addArrangedSubview(deadline)
    }
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            radio_button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radio_button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            radio_button.widthAnchor.constraint(equalToConstant: 24),
            radio_button.heightAnchor.constraint(equalToConstant: 24),
            
            arrowIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            arrowIcon.bottomAnchor.constraint(equalTo: HstackView.bottomAnchor),
            arrowIcon.topAnchor.constraint(equalTo: HstackView.topAnchor),

            HstackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            HstackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
           
            HstackView.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -16),
            HstackView.leadingAnchor.constraint(equalTo: radio_button.trailingAnchor, constant: 12)
        ])
    }
    
    
    
    func configure(with model:TodoItem){
        radio_button.action = self.action
        HstackView.arrangedSubviews[0].isHidden = false
        HstackView.arrangedSubviews[1].isHidden = false
        VstackView.arrangedSubviews[1].isHidden = false
        unstrikethrough()
        
        if model.importance == .regular {
            HstackView.arrangedSubviews[0].isHidden = true
            HstackView.arrangedSubviews[1].isHidden = true
        }else if model.importance == .important{
            radio_button.reload(status: .important)
            HstackView.arrangedSubviews[1].isHidden = true
        }else{
            HstackView.arrangedSubviews[0].isHidden = true
        }

        if (model.deadline == nil){
            VstackView.arrangedSubviews[1].isHidden = true
        }
        text.text = model.text
        if let date =  model.deadline {
            deadline.label.text = Formatter.date.string(from: date)
        }
        
        if model.isDone {
            radio_button.reload(status: .on)
            strikethrough()
            VstackView.arrangedSubviews[1].isHidden = true
            HstackView.arrangedSubviews[0].isHidden = true
            HstackView.arrangedSubviews[1].isHidden = true
        }else if model.importance == .important{
            radio_button.reload(status: .important)
        }
        else{
            radio_button.reload(status: .off)
            
        }
      
        setNeedsLayout()
    }
    
    private func strikethrough(){
        guard let text = text.text else {
            return
        }
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        self.text.textColor = UIColor(named: "LabelTertiary")
        self.text.attributedText = attributeString
    }
    
    private func unstrikethrough(){
        guard let text = text.text else { return }
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        self.text.textColor = UIColor(named: "LabelPrimary")
        self.text.attributedText = attributeString
     
    }
}

