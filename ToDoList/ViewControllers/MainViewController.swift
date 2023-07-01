//
//  ViewController.swift
//  ToDoList
//
//  Created by Настя Лазарева on 15.06.2023.
//

import UIKit
import LocalAuthentication
import FileCachePackage

class MainViewController: UIViewController{
    
    let fileCache = FileCache<TodoItem>()
    let fileName = "todo_data"
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let stackView = UIStackView()
    var currentItems :[TodoItem] = []
    var doneAreHidden = true
    
    var selectedCell : CustomCell?
    var selectedCellImageViewSnapshot: UIView?
    var animator: Animator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackPrimary")
        title = "Мои дела"
        loadData()
        view.addSubview(tableView)
        view.addSubview(stackView)
        setupTableView()
        setupStackView()
        setupAddButton()
    }
    
    
    private func loadData(){
        fileCache.loadJSON(filename: fileName)
        currentItems = doneAreHidden ? fileCache.todoItemCollection.filter { !$0.isDone  } : fileCache.todoItemCollection
        
    }
    
    private func setupStackView(){
        stackView.axis = .horizontal
        
        let label = UILabel()
        label.text = "Выполнено - 0"
        label.textColor = UIColor(named: "LabelTertiary")
        label.font = .systemFont(ofSize: 15)
        stackView.addArrangedSubview(label)
        let button = UIButton()
        button.setTitle("Показать", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitleColor(UIColor(named: "ColorBlue"), for: .normal)
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(button)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -32),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
        ])
        
    }
    
    private func setupAddButton(){
        
        var button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 20
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.pinCenterX(to: view),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        ])
        
        button.addTarget(self, action: #selector(openNewTaskVC), for: .touchUpInside)
    }
    
    @objc
    private func openNewTaskVC(){
        openTaskView()
    }
    
    @objc
    private func showButtonTapped(){
        guard let button = stackView.arrangedSubviews[1] as? UIButton else {return}
        let sorted = fileCache.todoItemCollection.filter { !$0.isDone  }
        
        if !doneAreHidden{
            currentItems = sorted
            tableView.reloadData()
            button.setTitle("Показать", for: .normal)
        } else {
            currentItems = fileCache.todoItemCollection
            tableView.reloadData()
            button.setTitle("Скрыть", for: .normal)
        }
        doneAreHidden = !doneAreHidden
        
        
    }
    
    func setupTableView(){
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        tableView.register(NewCustomCell.self, forCellReuseIdentifier: NewCustomCell.identifier)
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .zero
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    
    
    private func openTaskView(with model: TodoItem? = nil){
        
        
        
        guard let model = model else {
            let controller = TaskViewController()
            controller.delegate = self
            self.present( controller, animated: true)
            return
        }
        
        let controller = TaskViewController()
        controller.transitioningDelegate = self
        controller.toDoItem = model
        controller.delegate = self
        controller.configure(with: model)
        
        self.present(controller,animated: true)
        
    }
    
    
    func changeStatus(on: TodoItem, at: IndexPath){
        guard let ind  = fileCache.todoItemCollection.firstIndex(where: {$0.id == on.id}) else {
            
            return
        }
        
        fileCache.todoItemCollection[ind].isDone = !fileCache.todoItemCollection[ind].isDone
        
        fileCache.saveJSON(filename: fileName)
        loadData()
        tableView.reloadData()
        updateHeader()
        
    }
    
    func updateHeader(){
        guard var label = stackView.arrangedSubviews[0] as? UILabel else {return}
        label.text = "Выполнено - \(fileCache.todoItemCollection.filter({$0.isDone == true}).count)"
    }
    
    func delete(at indexPath: IndexPath) {
        
        let id = currentItems[indexPath.row].id
        
        fileCache.deleteTask(with: id)
        fileCache.saveJSON(filename: fileName)
        
        
        loadData()
        tableView.reloadData()
        updateHeader()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItems.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.currentItems.count {
            guard tableView.cellForRow(at: indexPath) is NewCustomCell else { return }
            openTaskView()
        }else {
            
            guard tableView.cellForRow(at: indexPath) is CustomCell else { return }
            let model = self.currentItems[indexPath.row]
            selectedCell = tableView.cellForRow(at: indexPath) as? CustomCell
            selectedCellImageViewSnapshot = selectedCell?.contentView.snapshotView(afterScreenUpdates: false)
            openTaskView(with: model)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.currentItems.count {
            let newCell = tableView.dequeueReusableCell(withIdentifier: NewCustomCell.identifier, for: indexPath)
            guard let inputCell = newCell as? NewCustomCell else {
                return UITableViewCell()
            }
            inputCell.action = { [weak self]  in
                self?.openTaskView()
            }
            
            return inputCell
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {fatalError("Impossible to deque a cell")}
        
        
        let model = currentItems[indexPath.row]
        cell.action = { [weak self] in
            guard let self = self else { return }
            let model = self.currentItems[indexPath.row]
            self.changeStatus(on: model, at: indexPath)
        }
        cell.configure(with: model)
        return cell
        
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard tableView.cellForRow(at: indexPath) is CustomCell else { return nil }
        
        let acceptButton = UIContextualAction(style: .normal, title:  "", handler: {
            [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let self = self else { return success(true) }
            let model = self.currentItems[indexPath.row]
            self.changeStatus(on: model, at: indexPath)
            success(true)
        })
        
        acceptButton.image = UIImage(named: "radioButton_on_white")
        acceptButton.backgroundColor = UIColor(named: "ColorGreen")
        return UISwipeActionsConfiguration(actions: [acceptButton])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard tableView.cellForRow(at: indexPath) is CustomCell else { return nil }
        
        let infoButton = UIContextualAction(style: .normal, title:  "", handler: {
            [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let self = self else { return success(true) }
            let model = self.currentItems[indexPath.row]
            self.openTaskView(with: model)
            success(true)
        })
        
        let deleteButton = UIContextualAction(style: .destructive, title:  "", handler: {
            [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let self = self else { return success(true) }
            self.delete(at: indexPath)
            success(true)
        })
        
        infoButton.image = UIImage(named: "info_button")
        infoButton.backgroundColor = UIColor(named: "ColorLightGrey")
        
        deleteButton.image = UIImage(named: "trash_button")
        deleteButton.backgroundColor = UIColor(named: "ColorRed")
        
        return UISwipeActionsConfiguration(actions: [deleteButton, infoButton])
    }
    
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(title: "Preview", children: [
                UIAction(title: "Посмотреть") { [weak self] _ in
                    guard let self = self else { return }
                    let model = self.currentItems[indexPath.row]
                    self.openTaskView(with: model)
                },
                UIAction(title: "Удалить") { [weak self] _ in
                    guard let self = self else { return }
                    self.delete(at: indexPath)
                },
                UIAction(title: "Завершить") { [weak self] _ in
                    guard let self = self else { return }
                    self.changeStatus(on: self.currentItems[indexPath.row], at: indexPath)
                }
            ])
        }
        
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
            [weak self] () -> UIViewController? in
            guard let self = self else { return nil }
            
            let item = self.currentItems[indexPath.row]
            
            let controller = TaskViewController()
            controller.toDoItem = item
            controller.delegate = self
            controller.configure(with: item)
            
            let navigationController = UINavigationController(rootViewController: controller)
            return navigationController
        }, actionProvider: actionProvider)
        return config
    }
    
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let previewedController = animator.previewViewController else { return }
        animator.addCompletion {
            self.present(previewedController, animated: true)
        }
    }
}


extension MainViewController: UpdateDelegate{
    func didUpdate(){
        loadData()
        tableView.reloadData()
        updateHeader()
    }
}

extension MainViewController{
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
