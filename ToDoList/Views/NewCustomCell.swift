//
//  NewCustomCell.swift
//  ToDoList
//
//  Created by Настя Лазарева on 30.06.2023.
//

import Foundation
import UIKit

class NewCustomCell: UITableViewCell{
    
    var action: (() -> Void)?
    
    static let identifier = "NewCustomCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Новое"
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(named: "ColorBlue")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let icon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "plus"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(icon)
        addSubview(label)
        setupConstraints()
        
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor,constant: 12),
            label.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -12)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
