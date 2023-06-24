//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Настя Лазарева on 20.06.2023.
//

import Foundation
import UIKit

class TaskViewController: UIViewController {
    
    var fileCache = FileCache()
    var toDoItem :TodoItem?
    
    
    private let colorPicker = UIColorPickerViewController()
    private var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private var stackView = UIStackView()
    let color_button = UIButton()
    
    
    private let cancellButton : UIButton = {
        let cancellButton = UIButton()
        cancellButton.setTitle("Отменить", for: .normal)
        cancellButton.setTitleColor(UIColor(named: "ColorBlue"), for: .normal)
        cancellButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        cancellButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancellButton.addTarget(self, action: #selector(cancellButtonTapped), for: .touchUpInside)
        cancellButton.isEnabled = false
        return cancellButton
    }()
    
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(UIColor(named: "ColorBlue"), for: .normal)
        saveButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        saveButton.isEnabled = false
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return saveButton
    }()
    
    private let textView : UITextView = {
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
    private var switcher = UISwitch()
    private var control = UISegmentedControl(items: ["", "нет", ""])
    let deleteButton = UIButton()
    let date_button = UIButton()
    let optional_separator = Separator()
    
    
    private let datePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileCache.loadJSON(filename: "hw2")
        if(!fileCache.todoItemCollection.isEmpty){
            toDoItem = fileCache.todoItemCollection[0]
        }
        self.hideKeyboardWhenTappedAround()
        self.registerForKeyboardNotification()
        view.backgroundColor = UIColor(named: "BackPrimary")
        setupScrollView()
        setupContentView()
        setupStackView()
        colorPicker.delegate = self
    }
    
    
    
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
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupStackView(){
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        stackView.spacing = 20
        setupHorizontalStackView()
        setupTextView()
        setupVerticalStackView()
        setupDeleteButton()
    }
    
    private func setupHorizontalStackView(){
        let label = UILabel()
        label.text = "Дело"
        label.textColor = UIColor(named: "LabelPrimary")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        let horizontalSV = UIStackView(arrangedSubviews: [cancellButton,label,saveButton])
        horizontalSV.axis = .horizontal
        horizontalSV.spacing = 10
        horizontalSV.distribution = .equalSpacing
        horizontalSV.backgroundColor = .clear
        view.addSubview(horizontalSV)
        horizontalSV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalSV.topAnchor.constraint(equalTo: view.topAnchor),
            horizontalSV.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -32),
            horizontalSV.heightAnchor.constraint(equalToConstant: 56),
            horizontalSV.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            horizontalSV.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16)
        ])
    }
    
    private func setupTextView(){
        textView.delegate = self
        stackView.addArrangedSubview(textView)
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            textView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
        if (toDoItem != nil){
            textView.text = toDoItem?.text
            if(toDoItem?.hexColor != nil){
                textView.textColor = UIColor(hex: (toDoItem?.hexColor)!)
            }else{
                textView.textColor = UIColor(named: "LabelPrimary")
            }
            saveButton.isEnabled = true
            deleteButton.isEnabled = true
        }
    }
    
    private func setupVerticalStackView(){
        let verticalSV = UIStackView()
        verticalSV.axis = .vertical
        verticalSV.backgroundColor = UIColor(named: "BackSecondary")
        verticalSV.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(verticalSV)
        NSLayoutConstraint.activate([
            verticalSV.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            verticalSV.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
        ])
        verticalSV.spacing = 0
        verticalSV.distribution = .equalSpacing
        verticalSV.alignment = .fill
        verticalSV.layer.cornerRadius = 16
        
        let imp_view = UIView()
        imp_view.backgroundColor = UIColor(named: "BackSecondary")
        imp_view.layer.cornerRadius = 16
        let imp_label = UILabel()
        imp_label.text = "Важность"
        imp_label.textColor = UIColor(named: "LabelPrimary")
        imp_label.font = UIFont.systemFont(ofSize: 17)
        imp_view.addSubview(imp_label)
        imp_label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imp_label.leadingAnchor.constraint(equalTo:imp_view.leadingAnchor,constant: 10),
            imp_label.trailingAnchor.constraint(equalTo:imp_view.trailingAnchor,constant: -10),
            imp_label.topAnchor.constraint(equalTo: imp_view.topAnchor),
            imp_label.bottomAnchor.constraint(equalTo: imp_view.bottomAnchor),
            
        ])
        verticalSV.addArrangedSubview(imp_view)
        imp_view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imp_view.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        imp_view.addSubview(control)
        control.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            control.topAnchor.constraint(equalTo: imp_view.topAnchor, constant: 10 ),
            control.bottomAnchor.constraint(equalTo: imp_view.bottomAnchor,constant: -10),
            control.trailingAnchor.constraint(equalTo: imp_view.trailingAnchor,constant: -16)
        ])
        control.setTitle(nil, forSegmentAt: 0)
        control.setTitle(nil, forSegmentAt: 2)
        control.setImage(UIImage(named: "low_priority_icon.svg"), forSegmentAt: 0)
        control.setImage(UIImage(named: "high_priority_icon.svg"), forSegmentAt: 2)
        control.selectedSegmentIndex = 1
        
        if toDoItem != nil {
            if toDoItem?.importance == .unimportant {
                control.selectedSegmentIndex = 0
            } else if toDoItem?.importance == .important {
                control.selectedSegmentIndex = 2
            }
        }
        
        let separator_1 = Separator()
        verticalSV.addArrangedSubview(separator_1)
        separator_1.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor,constant: -16).isActive = true
        separator_1.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor,constant: 16).isActive = true
        
        let color_picker_view = UIView()
        color_picker_view.translatesAutoresizingMaskIntoConstraints = false
        color_picker_view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        color_picker_view.backgroundColor = UIColor(named: "BackSecondary")
        color_picker_view.layer.cornerRadius = 16
        verticalSV.addArrangedSubview(color_picker_view)
        let separator_2 = Separator()
        verticalSV.addArrangedSubview(separator_2)
        separator_2.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor,constant: -16).isActive = true
        separator_2.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor,constant: 16).isActive = true
        let color_label = UILabel()
        color_label.text = "Цвет"
        color_label.textColor = UIColor(named: "LabelPrimary")
        color_label.font = UIFont.systemFont(ofSize: 17)
        color_label.translatesAutoresizingMaskIntoConstraints = false
        color_picker_view.addSubview(color_label)
        NSLayoutConstraint.activate([
            color_label.leadingAnchor.constraint(equalTo:color_picker_view.leadingAnchor,constant: 10),
            color_label.trailingAnchor.constraint(equalTo:color_picker_view.trailingAnchor,constant: -10),
            color_label.topAnchor.constraint(equalTo: color_picker_view.topAnchor),
            color_label.bottomAnchor.constraint(equalTo: color_picker_view.bottomAnchor),
        ])
        
        color_button.backgroundColor = UIColor(named: "LabelPrimary")
        if(toDoItem?.hexColor != nil){
            color_button.backgroundColor = UIColor(hex: (toDoItem?.hexColor)!)
        }
        color_button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        color_button.layer.cornerRadius = 16
        color_button.translatesAutoresizingMaskIntoConstraints = false
        color_picker_view.addSubview(color_button)
        NSLayoutConstraint.activate([
            color_button.setHeight(10),
            color_button.setWidth(32),
            color_button.trailingAnchor.constraint(equalTo:color_picker_view.trailingAnchor,constant: -16),
            color_button.topAnchor.constraint(equalTo: color_picker_view.topAnchor,constant: 12),
            color_button.bottomAnchor.constraint(equalTo: color_picker_view.bottomAnchor,constant: -12),
        ])
        color_button.addTarget(self, action: #selector(colorPickerButtonPressed), for: .touchUpInside)
        
        let deadline_view = UIView()
        deadline_view.backgroundColor = UIColor(named: "BackSecondary")
        deadline_view.layer.cornerRadius = 16
        verticalSV.addArrangedSubview(deadline_view)
        deadline_view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deadline_view.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        let deadlineSV = UIStackView()
        deadlineSV.axis = .vertical
        deadlineSV.alignment = .leading
        deadlineSV.distribution = .equalSpacing
        deadlineSV.spacing = 1
        deadline_view.addSubview(deadlineSV)
        deadlineSV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deadlineSV.leadingAnchor.constraint(equalTo: deadline_view.leadingAnchor,constant: 10),
            deadlineSV.trailingAnchor.constraint(equalTo: deadline_view.trailingAnchor,constant: -10),
            deadlineSV.topAnchor.constraint(equalTo: deadline_view.topAnchor,constant: 8),
            deadlineSV.bottomAnchor.constraint(equalTo: deadline_view.bottomAnchor,constant: -8)
        ])
        
        verticalSV.addArrangedSubview(optional_separator)
        optional_separator.trailingAnchor.constraint(equalTo: verticalSV.trailingAnchor,constant: -16).isActive = true
        optional_separator.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor,constant: 16).isActive = true
        optional_separator.isHidden = true
        
        let deadline_label = UILabel()
        deadline_label.text = "Сделать до"
        deadline_label.textColor = UIColor(named: "LabelPrimary")
        deadline_label.font = UIFont.systemFont(ofSize: 17)
        deadline_label.translatesAutoresizingMaskIntoConstraints = false
        
        date_button.setTitleColor(UIColor(named: "ColorBlue"), for: .normal)
        date_button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        date_button.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
        date_button.translatesAutoresizingMaskIntoConstraints = false
        date_button.heightAnchor.constraint(equalToConstant: 18).isActive = true

        deadlineSV.addArrangedSubview(deadline_label)
        deadlineSV.addArrangedSubview(date_button)
        
        if toDoItem != nil && toDoItem?.deadline != nil {
            date_button.isHidden = false
            date_button.setTitle(Formatter.date.string(from: (toDoItem?.deadline)!), for: .normal)
            switcher.isOn = true
            deadlineSV.layoutIfNeeded()
        }else{
            date_button.isHidden = true
        }
        
        switcher.translatesAutoresizingMaskIntoConstraints = false
        deadline_view.addSubview(switcher)
        NSLayoutConstraint.activate([
            switcher.trailingAnchor.constraint(equalTo: deadline_view.trailingAnchor,constant: -16),
            switcher.topAnchor.constraint(equalTo: deadline_view.topAnchor,constant: 8),
            switcher.bottomAnchor.constraint(equalTo: deadline_view.bottomAnchor,constant: -8)
        ])
        switcher.addTarget(self, action: #selector(switcherPressed), for: .valueChanged)
        
        verticalSV.addArrangedSubview(datePicker)
        datePicker.date = Date.tomorrow
        datePicker.isHidden = true
        datePicker.addTarget(self, action: #selector(datePickerHandler(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc
    func colorPickerButtonPressed(){
        self.present(colorPicker,animated: true)
    }
    
    @objc func datePickerHandler(sender: UIDatePicker) {
        let strDate = Formatter.date.string(from: datePicker.date)
        date_button.setTitle(strDate, for: .normal)
        
        
    }
    
    private func setupDeleteButton(){
        
        deleteButton.backgroundColor = UIColor(named: "BackSecondary")
        deleteButton.isEnabled = false
        if(toDoItem != nil){
            deleteButton.isEnabled = true
        }
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(UIColor(named: "LabelTertiary"), for: .disabled)
        deleteButton.setTitleColor(UIColor(named: "ColorRed"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.layer.cornerRadius = 16
        stackView.addArrangedSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
            
        ])
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
    }
    
    
    @objc
    private func deleteButtonTapped(){
        fileCache.deleteTask(with: "1")
        fileCache.saveJSON(filename: "hw2")
        cancellButtonTapped()
        deleteButton.isEnabled = false
    }
    
    @objc
    private func saveButtonTapped(){
        guard let text = textView.text else {return}
        if text == "" || textView.textColor == UIColor(named: "LabelTertiary") {
            
            return
        }
        var importance = Importance.regular
        var deadline: Date? = nil
        let hexColor: String? = color_button.backgroundColor?.toHex
        let selected_importance_ind = control.selectedSegmentIndex
        if selected_importance_ind == 0 {
            importance = .unimportant
        }else if selected_importance_ind == 2{
            importance = .important
        }
        if (switcher.isOn){
            deadline = datePicker.date
        }
        
        toDoItem = TodoItem(id: "1",
                            text: text,
                            importance: importance,
                            deadline: deadline,
                            hexColor: hexColor)
        fileCache.addNewTask(toDoItem!)
        fileCache.saveJSON(filename: "hw2")
        saveButton.isEnabled = false
        
    }
    
    @objc
    private func cancellButtonTapped(){
        toDoItem = nil
        textView.text = "Что надо сделать?"
        textView.textColor = UIColor(named: "LabelTertiary")
        if(switcher.isOn){
            switcher.setOn(false, animated: true)
            datePicker.isHidden = true
            deleteButton.isEnabled = false
        }
        date_button.isHidden = true
        control.selectedSegmentIndex = 1
        color_button.backgroundColor = UIColor(named: "LabelPrimary")
        cancellButton.isEnabled = false
        saveButton.isEnabled = false
        deleteButton.isEnabled = false
    }
    
    
    
    @objc
    private func switcherPressed(){
        if(switcher.isOn){
            self.date_button.isHidden = false
            self.date_button.setTitle(Formatter.date.string(from: self.datePicker.date), for: .normal)
        }else{
            optional_separator.isHidden = false
            self.date_button.isHidden = true
            UIView.animate(withDuration: 0.5, animations:{
                self.datePicker.isHidden = true
                self.datePicker.layer.opacity = 0
            })
        }
    }
    
    
    @objc
    private func showCalendar(){
        if self.datePicker.isHidden == true{
            optional_separator.isHidden = false
            UIView.animate(withDuration: 0.7, animations: {
                self.datePicker.layer.opacity = 1
                self.datePicker.isHidden = false;
            })
        }else{
            optional_separator.isHidden = true
            UIView.animate(withDuration: 0.7, animations: {
                self.datePicker.layer.opacity = .zero
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
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
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
            textView.textColor = color_button.backgroundColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if(textView.textColor != UIColor(named: "LabelTertiary")){
            saveButton.isEnabled = true
            deleteButton.isEnabled = true
            cancellButton.isEnabled = true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor(named: "LabelTertiary")
            saveButton.isEnabled = false
            deleteButton.isEnabled = false
        }
    }
}


extension Date {
    
    static var tomorrow:  Date { return Date().dayAfter }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TaskViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        color_button.backgroundColor = color
        if(textView.textColor != UIColor(named: "LabelTertiary")){
            textView.textColor = color
        }
    }
}
