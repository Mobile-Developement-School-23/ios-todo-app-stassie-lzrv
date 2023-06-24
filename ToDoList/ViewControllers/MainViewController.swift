//
//  ViewController.swift
//  ToDoList
//
//  Created by Настя Лазарева on 15.06.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackPrimary")
        setupLabel()
        setupAddButton()
        self.present(TaskViewController(), animated: true)
    }
    
    
    private func setupLabel(){
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = UIColor(named: "LabelPrimary")
        label.font = UIFont.systemFont(ofSize: 38, weight: .bold)
        label.text = "Moи дела"
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width*0.1),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.1),
            label.widthAnchor.constraint(equalToConstant: view.frame.width*0.5),
            label.heightAnchor.constraint(equalToConstant: view.frame.height*0.1)
        ])
    }
    
    private func setupAddButton(){
        var button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)?.withTintColor(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.backgroundColor = .clear
        
//        var shadows = UIView()
//        shadows.frame = button.frame
//        shadows.clipsToBounds = false
//        button.addSubview(shadows)
//
//        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
//        let layer0 = CALayer()
//        layer0.shadowPath = shadowPath0.cgPath
//        layer0.shadowColor = UIColor(red: 0, green: 0.191, blue: 0.4, alpha: 0.3).cgColor
//        layer0.shadowOpacity = 1
//        layer0.shadowRadius = 20
//        layer0.shadowOffset = CGSize(width: 0, height: 8)
//        layer0.bounds = shadows.bounds
//        layer0.position = shadows.center
//        shadows.layer.addSublayer(layer0)
//

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: view.frame.width*0.2),
            button.heightAnchor.constraint(equalToConstant: view.frame.width*0.2),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width*0.4),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height*0.8)
       ])
        
        button.addTarget(self, action: #selector(newTaskButtonPressed), for: .touchUpInside)
    }
    
    @objc
       private func newTaskButtonPressed(){
           self.present(TaskViewController(), animated: true)
           //self.navigationController?.pushViewController(TaskViewController(), animated: true)
       }

    
    
}

