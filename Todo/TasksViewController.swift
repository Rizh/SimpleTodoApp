//
//  TasksViewController.swift
//  Todo
//
//  Created by Ans Riaz on 12/11/2016.
//  Copyright © 2016 Ans Riaz. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedList : TodoList!
    var openTodos : Results<TodoItem>!
    var completedTodos : Results<TodoItem>!
    var currentCreateAction:UIAlertAction!
    
    var isEditingMode = false
    
    @IBOutlet weak var tasksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedList.name
        readTodosAndUpateUI()
    }
    
    @IBAction func didClickOnEditTasks(_ sender: AnyObject) {
        isEditingMode = !isEditingMode
        self.tasksTableView.setEditing(isEditingMode, animated: true)
    }
    @IBAction func didClickOnNewTask(_ sender: AnyObject) {
        self.displayAlertToAddTodo(nil)
    }
    func readTodosAndUpateUI(){
        
        completedTodos = self.selectedList.todoList.filter("isCompleted = true")
        openTodos = self.selectedList.todoList.filter("isCompleted = false")
        
        self.tasksTableView.reloadData()
    }
    
    // UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return openTodos.count
        }
        return completedTodos.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "OPEN Todo"
        }
        return "COMPLETED Todo"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        var todo: TodoItem!
        if indexPath.section == 0{
            todo = openTodos[indexPath.row]
        }
        else{
            todo = completedTodos[indexPath.row]
        }
        
        cell?.textLabel?.text = todo.name
        return cell!
    }
    
    
    func displayAlertToAddTodo(_ updatedTodo:TodoItem!){
        
        var title = "New Todo"
        var doneTitle = "Create"
        if updatedTodo != nil{
            title = "Update Todo"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your todo.", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            
            let todoName = alertController.textFields?.first?.text
            
            if updatedTodo != nil{
                // update mode
                try! realm.write{
                    updatedTodo.name = todoName!
                    self.readTodosAndUpateUI()
                }
            }
            else{
                
                let newTask = TodoItem()
                newTask.name = todoName!
                
                try! realm.write{
                    
                    self.selectedList.todoList.append(newTask)
                    self.readTodosAndUpateUI()
                }
            }
            
            print(todoName ?? "Ans")
        }
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Name"
            textField.addTarget(self, action: #selector(TasksViewController.todoNameFieldDidChange(_:)) , for: UIControlEvents.editingChanged)
            if updatedTodo != nil{
                textField.text = updatedTodo.name
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func todoNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            //Deletion will go here
            
            var todoToBeDeleted: TodoItem!
            if indexPath.section == 0{
                todoToBeDeleted = self.openTodos[indexPath.row]
            }
            else{
                todoToBeDeleted = self.completedTodos[indexPath.row]
            }
            
            try! realm.write{
                realm.delete(todoToBeDeleted)
                self.readTodosAndUpateUI()
            }
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            var todoToBeUpdated: TodoItem!
            if indexPath.section == 0{
                todoToBeUpdated = self.openTodos[indexPath.row]
            }
            else{
                todoToBeUpdated = self.completedTodos[indexPath.row]
            }
            
            self.displayAlertToAddTodo(todoToBeUpdated)
            
        }
        
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Done") { (doneAction, indexPath) -> Void in
            
            var todoToBeUpdated: TodoItem!
            if indexPath.section == 0{
                todoToBeUpdated = self.openTodos[indexPath.row]
            }
            else{
                todoToBeUpdated = self.completedTodos[indexPath.row]
            }
            try! realm.write{
                todoToBeUpdated.isCompleted = true
                self.readTodosAndUpateUI()
            }
            
        }
        return [deleteAction, editAction, doneAction]
    }
    
    
}
