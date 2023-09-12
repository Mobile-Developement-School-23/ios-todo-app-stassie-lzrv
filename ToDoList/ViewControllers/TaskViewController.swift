//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Настя Лазарева on 20.06.2023.
//

import Foundation
import UIKit


class TaskViewController: UIViewController {
    var fileCache: FileCacheProtocol = FileCacheCoreData()
    var toDoItem :TodoItem?
    
    weak var delegate: UpdateDelegate?
    
    let navBar = NavBar()
    private let importanceView = ImportanceView()
    private let deadlineView = DeadlineView()
    private let colorPickerView = ColorPickerView()
    private let colorPicker = UIColorPickerViewController()
    private var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private var stackView = UIStackView()
    private let deleteButton = UIButton()
    private let optionalSeparator = Separator()
    private let separatorFirst = Separator()
    private let separatorSecond = Separator()
    
    
    private var isLandscape: Bool = UIDevice.current.orientation.isLandscape {
        didSet {
            deleteButton.isHidden = isLandscape
            importanceView.isHidden = isLandscape
            deadlineView.isHidden = isLandscape
            colorPickerView.isHidden = isLandscape
            optionalSeparator.isHidden = isLandscape
            separatorFirst.isHidden = isLandscape
            separatorSecond.isHidden = isLandscape
            if isLandscape {
                let bounds = UIScreen.main.bounds
                let minHeight = bounds.height > bounds.width ? bounds.width : bounds.height
                let barHeight = navBar.frame.height
                textView.heightAnchor.constraint(greaterThanOrEqualToConstant:  minHeight - 32 - barHeight).isActive = true
            } else {
                textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
            }
        }
    }
    
    
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.text = "Что надо сделать?"
        textView.textColor = UIColor(named: "LabelTertiary")
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(named: "BackSecondary")
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 17, right: 16)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 16
        return textView
    }()
    
    
    
    private let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileCache.load()
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotification()
        view.backgroundColor = UIColor(named: "BackPrimary")
        setupScrollView()
        setupContentView()
        setupStackView()
        colorPicker.delegate = self
        if(toDoItem != nil){
            configure(with: toDoItem!)
        }
        isLandscape =  UIDevice.current.orientation.isLandscape
        deleteButton.layer.opacity = 0
        navBar.layer.opacity = 0
        stackView.arrangedSubviews[1].layer.opacity = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.4) {
            self.navBar.layer.opacity = 1
            self.textView.layer.opacity = 1
            
            self.deleteButton.alpha = 1
            self.stackView.arrangedSubviews[1].layer.opacity = 1
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        isLandscape = UIDevice.current.orientation.isLandscape
    }
    
    func configure(with todoItem: TodoItem){
        toDoItem = todoItem
        textView.text = toDoItem?.text
        if(toDoItem?.hexColor != nil){
            textView.textColor = UIColor(hex: (toDoItem?.hexColor)!)
        }else{
            textView.textColor = UIColor(named: "LabelPrimary")
        }
        navBar.saveButton.isEnabled = true
        deleteButton.isEnabled = true
        
        if toDoItem?.importance == .low {
            importanceView.control.selectedSegmentIndex = 0
        } else if toDoItem?.importance == .important {
            importanceView.control.selectedSegmentIndex = 2
        }
        if(toDoItem?.hexColor != nil){
            colorPickerView.button.backgroundColor = UIColor(hex: (toDoItem?.hexColor)!)
        }
        
        if toDoItem?.deadline != nil {
            deadlineView.date_button.isHidden = false
            deadlineView.date_button.setTitle(Formatter.date.string(from: (toDoItem?.deadline)!), for: .normal)
            deadlineView.switcher.isOn = true
            datePicker.date = (toDoItem?.deadline!)!
            deadlineView.stackView.layoutIfNeeded()
        }
        
        
        
    }
    
  
    @objc
    func colorPickerButtonPressed(){
        self.present(colorPicker,animated: true)
    }
    
    @objc func datePickerHandler(sender: UIDatePicker) {
        let strDate = Formatter.date.string(from: datePicker.date)
        deadlineView.date_button.setTitle(strDate, for: .normal)
    }
    
    
    @objc
    private func deleteButtonTapped(){
        guard let id = toDoItem?.id else {return}
        fileCache.delete(with: id)
        deleteButton.isEnabled = false
        delegate?.didUpdate()
        self.dismiss(animated: true)
    }
    
    @objc
    private func saveButtonTapped(){
        
        guard let text = textView.text else {return}
        if text == "" || textView.textColor == UIColor(named: "LabelTertiary") {
            return
        }
        
        var importance = Importance.basic
        var deadline: Date? = nil
        let hexColor: String? = colorPickerView.button.backgroundColor?.toHex
        let selectedImportanceInd = importanceView.control.selectedSegmentIndex
        if selectedImportanceInd == 0 {
            importance = .low
        }else if selectedImportanceInd == 2{
            importance = .important
        }
        if (deadlineView.switcher.isOn){
            deadline = datePicker.date
        }
        
        if(toDoItem == nil){
            let newItem = TodoItem(
                text: text,
                importance: importance,
                deadline: deadline,
                hexColor: hexColor)
            self.toDoItem = newItem
            fileCache.insert(item: newItem)
        } else{
            let newItem = TodoItem(id: (self.toDoItem?.id)!,
                                   text: text,
                                   importance: importance,
                                   deadline: deadline,
                                   hexColor: hexColor)
            self.toDoItem = newItem
            fileCache.update(item: newItem)
        }
        
        delegate?.didUpdate()
        self.dismiss(animated: true)
        navBar.saveButton.isEnabled = false
        
        
    }
    
    @objc
    private func cancellButtonTapped(){
        viewWillDisappear(true)
        self.dismiss(animated: true)
    }
    
    
    @objc
    private func switcherPressed(){
        if(deadlineView.switcher.isOn){
            self.deadlineView.date_button.isHidden = false
            self.deadlineView.date_button.setTitle(Formatter.date.string(from: self.datePicker.date), for: .normal)
            
        }else{
            
            self.deadlineView.date_button.isHidden = true
            UIView.animate(withDuration: 0.5, animations:{
                self.optionalSeparator.layer.opacity = 0
                self.datePicker.isHidden = true
                self.datePicker.layer.opacity = 0
            })
        }
    }
    
    
    @objc
    private func showCalendar(){
        if self.datePicker.isHidden == true{
            UIView.animate(withDuration: 0.5, animations: {
                self.datePicker.layer.opacity = 1
                self.optionalSeparator.layer.opacity = 1
                self.datePicker.isHidden = false;
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.optionalSeparator.layer.opacity = 0
                self.datePicker.layer.opacity = 0
                self.datePicker.isHidden = true;
            })
        }
    }
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification){
        let userInfo = notification.userInfo
        guard let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let kbFrameSize = keyboardFrame.cgRectValue
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
        
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification){
        scrollView.contentInset = .zero
    }
}


extension TaskViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "LabelTertiary") {
            textView.text = nil
            textView.textColor = colorPickerView.button.backgroundColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if(textView.textColor != UIColor(named: "LabelTertiary")){
            navBar.saveButton.isEnabled = true
            deleteButton.isEnabled = true
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor(named: "LabelTertiary")
            navBar.saveButton.isEnabled = false
            deleteButton.isEnabled = false
            
        }
    }
}

extension TaskViewController {
    
    private func setupScrollView(){
        scrollView.backgroundColor = UIColor(named: "BackPrimary")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 56),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupContentView(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor,constant: 20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor,constant: -20),
            
        ])
    }
    
    private func setupStackView(){
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.spacing = 16
        setupHorizontalStackView()
        setupTextView()
        setupVerticalStackView()
        setupDeleteButton()
    }
    
    private func setupHorizontalStackView(){
        view.addSubview(navBar)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -32),
            navBar.heightAnchor.constraint(equalToConstant: 56),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
        ])
        navBar.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        navBar.cancellButton.addTarget(self, action: #selector(cancellButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupTextView(){
        textView.delegate = self
        textView.layer.opacity = 0
        stackView.addArrangedSubview(textView)
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        
    }
    
    private func setupVerticalStackView(){
        let verticalSV = UIStackView()
        verticalSV.axis = .vertical
        verticalSV.backgroundColor = UIColor(named: "BackSecondary")
        verticalSV.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(verticalSV)
        NSLayoutConstraint.activate([
            verticalSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        verticalSV.spacing = 0
        verticalSV.distribution = .equalSpacing
        verticalSV.layer.cornerRadius = 16
        verticalSV.addArrangedSubview(importanceView)
        verticalSV.addArrangedSubview(separatorFirst)
        verticalSV.addArrangedSubview(colorPickerView)
        verticalSV.addArrangedSubview(separatorSecond)
        
        colorPickerView.button.addTarget(self, action: #selector(colorPickerButtonPressed), for: .touchUpInside)
        
        verticalSV.addArrangedSubview(deadlineView)
        optionalSeparator.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        verticalSV.addArrangedSubview(optionalSeparator)
        optionalSeparator.layer.opacity = 0
        
        deadlineView.date_button.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
        deadlineView.date_button.isHidden = true
        datePicker.date = Date.tomorrow
        deadlineView.switcher.addTarget(self, action: #selector(switcherPressed), for: .valueChanged)
        verticalSV.addArrangedSubview(datePicker)
        datePicker.isHidden = true
        datePicker.addTarget(self, action: #selector(datePickerHandler(sender:)), for: UIControl.Event.valueChanged)
    }
    
    private func setupDeleteButton(){
        
        deleteButton.backgroundColor = UIColor(named: "BackSecondary")
        deleteButton.isEnabled = false
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        deleteButton.setTitleColor(UIColor(named: "ColorRed"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.layer.cornerRadius = 16
        stackView.addArrangedSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
    }
    
}


extension TaskViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorPickerView.button.backgroundColor = color
        if(textView.textColor != UIColor(named: "LabelTertiary")){
            textView.textColor = color
        }
    }
}
